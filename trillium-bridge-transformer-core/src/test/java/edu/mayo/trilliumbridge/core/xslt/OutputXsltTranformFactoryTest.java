package edu.mayo.trilliumbridge.core.xslt;

import edu.mayo.trilliumbridge.core.TrilliumBridgeTransformer;
import org.junit.Test;

import static org.junit.Assert.*;

/**
 */
public class OutputXsltTranformFactoryTest {

    @Test
    public void testCcdaHtml() {
        OutputXsltTransformFactory factory = new OutputXsltTransformFactory();

        assertNotNull(
                factory.getOutputTransform(
                        TrilliumBridgeTransformer.Format.HTML,
                        XsltTrilliumBridgeTransformer.DocumentType.CCDA));
    }
}
