package edu.mayo.trilliumbridge.core.xslt;

import com.fasterxml.jackson.databind.ObjectMapper;
import edu.mayo.trilliumbridge.core.TrilliumBridgeTransformer;
import edu.mayo.trilliumbridge.core.UnsupportedOutputFormatException;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Factory for providing XSLTs for transformations.
 */
public class OutputXsltTransformFactory {

    private static final String OUTPUT_FORMATS_BASE_PATH = "/outputformats";
    private static final String OUTPUT_FORMATS_JSON_PATH = OUTPUT_FORMATS_BASE_PATH + "/outputformats.json";

    private XsltDirectoryResourceFactory resourceFactory = XsltDirectoryResourceFactory.instance();

    private Map<OutputTransformKey, javax.xml.transform.Transformer> transformMap = new HashMap<OutputTransformKey, javax.xml.transform.Transformer>();

    public OutputXsltTransformFactory() {
        super();
        ObjectMapper mapper = new ObjectMapper();

        List<Map<String, String>> jsonList;
        try {
            jsonList = mapper.readValue(this.resourceFactory.getResource(OUTPUT_FORMATS_JSON_PATH).getInputStream(), List.class);
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }

        for (final Map<String, String> json : jsonList) {
            String useFor = json.get("useFor");

            List<XsltTrilliumBridgeTransformer.DocumentType> usedForList;
            if (useFor.equals("BOTH")) {
                usedForList = Arrays.asList(XsltTrilliumBridgeTransformer.DocumentType.CCDA, XsltTrilliumBridgeTransformer.DocumentType.EPSOS);
            } else {
                usedForList = Arrays.asList(XsltTrilliumBridgeTransformer.DocumentType.valueOf(useFor));
            }

            for (XsltTrilliumBridgeTransformer.DocumentType type : usedForList) {
                transformMap.put(
                        new OutputTransformKey(
                                type,
                                TrilliumBridgeTransformer.Format.valueOf(json.get("output"))),

                                XsltUtils.buildTransformer(
                                                    resourceFactory.getResource(OUTPUT_FORMATS_BASE_PATH + "/" + json.get("xslt"))));
            }
        }
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

    protected javax.xml.transform.Transformer getOutputTransform(TrilliumBridgeTransformer.Format format, XsltTrilliumBridgeTransformer.DocumentType documentType) {
        OutputTransformKey key = new OutputTransformKey(documentType, format);

        if (!this.transformMap.containsKey(key)) {
            throw new UnsupportedOutputFormatException(format);
        } else {
            return this.transformMap.get(key);
        }
    }
}
