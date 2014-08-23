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

import edu.mayo.trilliumbridge.core.TrilliumBridgeTransformer;
import edu.mayo.trilliumbridge.core.xslt.XsltTrilliumBridgeTransformer;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

@Controller
public class TransformerController {

    private static final String XML_FORMAT = "xml";

    private static final String INPUT_FILE_NAME = "file";

    private TrilliumBridgeTransformer transformer = new XsltTrilliumBridgeTransformer();

    private interface Transformer {
        void transform(InputStream in, OutputStream out, TrilliumBridgeTransformer.Format outputFormat);
    }

    @RequestMapping(value = "/epsos2ccda", method = RequestMethod.POST)
    @ResponseBody
    public void epsos2ccda(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestHeader("Accept") String accept,
            @RequestParam(value = "formatOverride", required = false) String formatOverride)
            throws IOException {
        this.doTransform(request, response, accept, formatOverride, new Transformer() {

            @Override
            public void transform(InputStream in, OutputStream out, TrilliumBridgeTransformer.Format outputFormat) {
                transformer.epsosToCcda(in, out, outputFormat);
            }

        });
    }

    @RequestMapping(value = "/ccda2epsos", method = RequestMethod.POST)
    @ResponseBody
    public void ccda2epsos(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestHeader("Accept") String accept,
            @RequestParam(value = "formatOverride", required = false) String formatOverride)
            throws IOException {
        this.doTransform(request, response, accept, formatOverride, new Transformer() {

            @Override
            public void transform(InputStream in, OutputStream out, TrilliumBridgeTransformer.Format outputFormat) {
                transformer.ccdaToEpsos(in, out, outputFormat);
            }

        });
    }

    protected void doTransform(
            HttpServletRequest request,
            HttpServletResponse response,
            String acceptHeader,
            String formatOverride,
            Transformer transformer)
            throws IOException {

        TrilliumBridgeTransformer.Format responseFormat = null;

        if(StringUtils.isNotBlank(formatOverride)) {
            responseFormat = TrilliumBridgeTransformer.Format.valueOf(formatOverride);
        } else {
            String[] accepts = StringUtils.split(acceptHeader, ',');

            for(String accept : accepts) {
                MediaType askedForType = MediaType.parseMediaType(accept);
                if(askedForType.isCompatibleWith(MediaType.TEXT_HTML) ||
                        askedForType.isCompatibleWith(MediaType.APPLICATION_XHTML_XML)) {
                    responseFormat = TrilliumBridgeTransformer.Format.HTML;
                } else if(askedForType.isCompatibleWith(MediaType.TEXT_XML) ||
                        askedForType.isCompatibleWith(MediaType.APPLICATION_XML)) {
                    responseFormat = TrilliumBridgeTransformer.Format.XML;
                } else if(askedForType.getType().equals("application") && askedForType.getSubtype().equals("pdf")) {
                    responseFormat = TrilliumBridgeTransformer.Format.PDF;
                }

                if(responseFormat != null) {
                    break;
                }
            }
        }

        if(responseFormat == null) {
            throw new UserInputException("Cannot return type: " + acceptHeader);
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

        // create a buffer so we don't use the servlet's output stream unless
        // we get a successful transform, because if we do use it,
        // we can't use the error view anymore.
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        transformer.transform(
                inputStream,
                baos,
                responseFormat);

        try {
            response.getOutputStream().write(baos.toByteArray());
        } finally {
            IOUtils.closeQuietly(baos);
        }

        response.setContentType(contentType);
    }

}