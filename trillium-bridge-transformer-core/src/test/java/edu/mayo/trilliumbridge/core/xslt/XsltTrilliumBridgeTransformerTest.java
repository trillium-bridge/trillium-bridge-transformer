package edu.mayo.trilliumbridge.core.xslt;

import org.junit.Test;

import static org.junit.Assert.*;

public class XsltTrilliumBridgeTransformerTest {


    @Test
    public void testTransformerParams() {
        XsltTrilliumBridgeTransformer transformer = new XsltTrilliumBridgeTransformer();

        assertNotNull(transformer.getTransformerParams());
    }

}
