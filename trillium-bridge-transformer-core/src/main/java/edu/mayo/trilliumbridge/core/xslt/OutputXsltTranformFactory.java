package edu.mayo.trilliumbridge.core.xslt;

import com.fasterxml.jackson.databind.ObjectMapper;
import edu.mayo.trilliumbridge.core.TrilliumBridgeTransformer;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 */
public class OutputXsltTranformFactory {

    private static final String OUTPUT_FORMATS_BASE_PATH = "/outputformats";
    private static final String OUTPUT_FORMATS_JSON_PATH = OUTPUT_FORMATS_BASE_PATH + "/outputformats.json";

    private Map<OutputTransformKey, InputStreamFactory> transformMap = new HashMap<OutputTransformKey, InputStreamFactory>();

    public OutputXsltTranformFactory() {
        super();
        ObjectMapper mapper = new ObjectMapper();

        List<Map<String,String>> jsonList;
        try {
            jsonList = mapper.readValue(new ClassPathResource(OUTPUT_FORMATS_JSON_PATH).getInputStream(), List.class);
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }

        for(final Map<String,String> json : jsonList) {
            transformMap.put(
                    new OutputTransformKey(
                            XsltTrilliumBridgeTransformer.DocumentType.valueOf(json.get("useFor")),
                            TrilliumBridgeTransformer.Format.valueOf(json.get("output"))),

                    new InputStreamFactory() {

                        @Override
                        public InputStream getInputStream() {
                            try {
                                return new ClassPathResource(OUTPUT_FORMATS_BASE_PATH + "/" + json.get("xslt")).getInputStream();
                            } catch (IOException e) {
                                throw new IllegalStateException(e);
                            }
                        }

                    });
        }

    }

    private interface InputStreamFactory {
        InputStream getInputStream();
    }

    private class OutputTransformKey {
        private XsltTrilliumBridgeTransformer.DocumentType documentType;
        private TrilliumBridgeTransformer.Format format;

        private OutputTransformKey(XsltTrilliumBridgeTransformer.DocumentType documentType, TrilliumBridgeTransformer.Format format) {
            this.documentType = documentType;
            this.format = format;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;

            OutputTransformKey that = (OutputTransformKey) o;

            if (documentType != that.documentType) return false;
            if (format != that.format) return false;

            return true;
        }

        @Override
        public int hashCode() {
            int result = documentType.hashCode();
            result = 31 * result + format.hashCode();
            return result;
        }
    }

    protected InputStream getOutputTransform(TrilliumBridgeTransformer.Format format, XsltTrilliumBridgeTransformer.DocumentType documentType) {
        return this.transformMap.get(new OutputTransformKey(documentType, format)).getInputStream();
    }
}
