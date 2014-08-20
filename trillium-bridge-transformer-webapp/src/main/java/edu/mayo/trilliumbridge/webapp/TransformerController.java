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
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/**
 * Handles requests for the application home page.
 *
 * @author <a href="mailto:kevin.peterson@mayo.edu">Kevin Peterson</a>
 */
@Controller
public class TransformerController {

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
            @RequestParam(defaultValue = "application/xml") String encoding)
            throws IOException {
        this.doTransform(request, response, encoding, new Transformer() {

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
            @RequestParam(defaultValue = "application/xml") String encoding)
            throws IOException {
        this.doTransform(request, response, encoding, new Transformer() {

            @Override
            public void transform(InputStream in, OutputStream out, TrilliumBridgeTransformer.Format outputFormat) {
                transformer.ccdaToEpsos(in, out, outputFormat);
            }

        });
    }

    protected void doTransform(
            HttpServletRequest request,
            HttpServletResponse response,
            String encoding,
            Transformer transformer)
            throws IOException {

        response.setContentType(encoding);

        InputStream inputStream;
        if(request instanceof MultipartHttpServletRequest){
            MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
            MultipartFile multipartFile = multipartRequest.getFile(INPUT_FILE_NAME);
            inputStream = multipartFile.getInputStream();
        } else {
            inputStream = request.getInputStream();
        }

        transformer.transform(
                inputStream,
                response.getOutputStream(),
                TrilliumBridgeTransformer.Format.XML);
    }

    /**
     * Handle null pointer exception.
     *
     * @param response the response
     * @param ex the ex
     * @return the model and view
     */
    @ExceptionHandler(UserInputException.class)
    public ModelAndView handleNullPointerException(
            HttpServletResponse response,
            UserInputException ex) {

        ModelAndView mav = new ModelAndView("inputError");
        mav.addObject("message", ex.getLocalizedMessage());

        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);

        return mav;
    }

}