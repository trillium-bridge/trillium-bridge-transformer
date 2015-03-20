package edu.mayo.trilliumbridge.core.xslt;

import org.springframework.core.io.Resource;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamSource;
import java.io.IOException;

public final class XsltUtils {

    private static XsltDirectoryResourceFactory resourceFactory = XsltDirectoryResourceFactory.instance();

    protected static  javax.xml.transform.Transformer buildTransformer(Resource xslt) {
        // Source XSLT Stylesheet
        StreamSource xsltFile = null;
        try {
            xsltFile = new StreamSource(xslt.getInputStream());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        TransformerFactory xsltFactory = TransformerFactory.newInstance();

        xsltFactory.setURIResolver(new URIResolver() {
            @Override
            public Source resolve(String href, String base) throws TransformerException {
                if(!href.startsWith("http:") && !href.startsWith("internal/"))
                    href = "/xslt/" + href;
                try {
                    return new StreamSource(resourceFactory.getResource(href).getInputStream());
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }
        });

        javax.xml.transform.Transformer transformer;
        try {
            transformer = xsltFactory.newTransformer(xsltFile);
        } catch (TransformerConfigurationException e) {
            throw new RuntimeException(e);
        }

        return transformer;
    }
}
