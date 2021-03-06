/*
 * Copyright: (c) 2004-2011 Mayo Foundation for Medical Education and 
 * Research (MFMER). All rights reserved. MAYO, MAYO CLINIC, and the
 * triple-shield Mayo logo are trademarks and service marks of MFMER.
 *
 * Except as contained in the copyright notice above, or as used to identify 
 * MFMER as the author of this software, the trade names, trademarks, service
 * marks, or product names of the copyright holder shall not be used in
 * advertising, promotion or otherwise in connection with this software without
 * prior written authorization of the copyright holder.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package edu.mayo.trilliumbridge.webapp;

import edu.mayo.trilliumbridge.core.TransformOption;
import edu.mayo.trilliumbridge.core.TransformOptionDefinition;
import edu.mayo.trilliumbridge.core.TrilliumBridgeTransformer;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.*;

@Controller
public class TransformerController {

    private static final String NO_CONTENT_ERROR_MSG = "No file or XML content body sent.";

    private static final String XML_FORMAT = "xml";

    private static final String INPUT_FILE_NAME = "file";

    @Autowired
    private TrilliumBridgeTransformer transformer;

    private interface Transformer {
        void transform(InputStream in, OutputStream out, TrilliumBridgeTransformer.Format outputFormat);
    }

    @RequestMapping(value = "/epsos2ccda", method = RequestMethod.POST)
    @ResponseBody
    public void epsos2ccda(
            final HttpServletRequest request,
            HttpServletResponse response,
            @RequestHeader(value = "Accept", defaultValue = MediaType.APPLICATION_XML_VALUE) String accept,
            @RequestParam(value = "formatOverride", required = false) String formatOverride)
            throws IOException {
        this.doTransform(request, response, accept, formatOverride, new Transformer() {

            @Override
            public void transform(InputStream in, OutputStream out, TrilliumBridgeTransformer.Format outputFormat) {
                transformer.epsosToCcda(in, out, outputFormat, getParams(request.getParameterMap(), transformer.getTransformerParams()));
            }

        });
    }

    @RequestMapping(value = "/ccda2epsos", method = RequestMethod.POST)
    @ResponseBody
    public void ccda2epsos(
            final HttpServletRequest request,
            HttpServletResponse response,
            @RequestHeader(value = "Accept", defaultValue = MediaType.APPLICATION_XML_VALUE) String accept,
            @RequestParam(value = "formatOverride", required = false) String formatOverride)
            throws IOException {
        this.doTransform(request, response, accept, formatOverride, new Transformer() {

            @Override
            public void transform(InputStream in, OutputStream out, TrilliumBridgeTransformer.Format outputFormat) {
                transformer.ccdaToEpsos(in, out, outputFormat, getParams(request.getParameterMap(), transformer.getCcdaToEpsosOptions()));
            }

        });
    }

    private List<TransformOption> getParams(Map<String,String[]> formParams, Set<TransformOptionDefinition> options) {
        if(formParams == null) {
            return null;
        }

        List<TransformOption> returnList = new ArrayList<TransformOption>();

        for(TransformOptionDefinition option : options) {
            String key = option.getOptionName();

            String[] values = formParams.get(key);

            String value = null;
            if(values == null && option.getOptionType().equals(TransformOptionDefinition.OptionType.BOOLEAN)) {
                value = Boolean.FALSE.toString();
            } else {
                value = StringUtils.join(values, ',');
            }

            returnList.add(new TransformOption(key, value));
        }

        return returnList;
    }

    protected void doTransform(
            HttpServletRequest request,
            HttpServletResponse response,
            String acceptHeader,
            String formatOverride,
            Transformer transformer)
            throws IOException {

        // default to XML if no Accept Header (it should at least be */*, but just in case).
        if(StringUtils.isBlank(acceptHeader)) {
            acceptHeader = MediaType.APPLICATION_ATOM_XML_VALUE;
        }

        TrilliumBridgeTransformer.Format responseFormat = null;

        if(StringUtils.isNotBlank(formatOverride)) {
            responseFormat = TrilliumBridgeTransformer.Format.valueOf(formatOverride);
        } else {
            String[] accepts = StringUtils.split(acceptHeader, ',');

            for(String accept : accepts) {
                MediaType askedForType = MediaType.parseMediaType(accept);
                if(askedForType.isCompatibleWith(MediaType.TEXT_XML) ||
                        askedForType.isCompatibleWith(MediaType.APPLICATION_XML)) {
                    responseFormat = TrilliumBridgeTransformer.Format.XML;
                } else if(askedForType.isCompatibleWith(MediaType.TEXT_HTML) ||
                        askedForType.isCompatibleWith(MediaType.APPLICATION_XHTML_XML)) {
                    responseFormat = TrilliumBridgeTransformer.Format.HTML;
                } else if(askedForType.getType().equals("application") && askedForType.getSubtype().equals("pdf")) {
                    responseFormat = TrilliumBridgeTransformer.Format.PDF;
                }

                if(responseFormat != null) {
                    break;
                }
            }
        }

        if(responseFormat == null) {
            throw new UserInputException("Cannot return type: " + acceptHeader, HttpStatus.NOT_ACCEPTABLE);
        }

        String contentType;
        switch (responseFormat) {
            case XML: contentType = MediaType.APPLICATION_XML_VALUE; break;
            case HTML: contentType = MediaType.TEXT_HTML_VALUE.toString(); break;
            case PDF: contentType = "application/pdf"; break;
            default: throw new IllegalStateException("Illegal Response Format");
        }

        InputStream inputStream;
        if(request instanceof MultipartHttpServletRequest){
            MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
            MultipartFile multipartFile = multipartRequest.getFile(INPUT_FILE_NAME);
            inputStream = multipartFile.getInputStream();
        } else {
            inputStream = request.getInputStream();
        }

        inputStream = this.checkForUtf8BOMAndDiscardIfAny(this.checkStreamIsNotEmpty(inputStream));

        // create a buffer so we don't use the servlet's output stream unless
        // we get a successful transform, because if we do use it,
        // we can't use the error view anymore.
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        transformer.transform(
                inputStream,
                baos,
                responseFormat);

        try {
            response.setContentType(contentType);
            response.getOutputStream().write(baos.toByteArray());
        } finally {
            IOUtils.closeQuietly(baos);
        }

    }

    /**
     * From http://stackoverflow.com/a/19137900/656853
     */
    private InputStream checkStreamIsNotEmpty(InputStream inputStream) throws IOException {
        if(inputStream == null) {
            throw new UserInputException(NO_CONTENT_ERROR_MSG);
        }

        PushbackInputStream pushbackInputStream = new PushbackInputStream(inputStream);
        int b;
        b = pushbackInputStream.read();
        if ( b == -1 ) {
            throw new UserInputException("No file or XML content body sent.");
        }
        pushbackInputStream.unread(b);

        return pushbackInputStream;
    }

    /**
     * From http://stackoverflow.com/a/9737529/656853
     */
    private InputStream checkForUtf8BOMAndDiscardIfAny(InputStream inputStream) throws IOException {
        PushbackInputStream pushbackInputStream = new PushbackInputStream(new BufferedInputStream(inputStream), 3);
        byte[] bom = new byte[3];
        if (pushbackInputStream.read(bom) != -1) {
            if (!(bom[0] == (byte) 0xEF && bom[1] == (byte) 0xBB && bom[2] == (byte) 0xBF)) {
                pushbackInputStream.unread(bom);
            }
        }
        return pushbackInputStream;
    }

}