package edu.mayo.trilliumbridge.core.xslt;

import org.junit.Test;

import static org.junit.Assert.*;

public class XsltTrilliumBridgeTransformerTest {

    @Test
    public void testCcdaToEpsosOptions() {
        XsltTrilliumBridgeTransformer transformer = new XsltTrilliumBridgeTransformer();

        assertNotNull(transformer.getCcdaToEpsosOptions());
    }

    @Test
    public void testEpsosToCcdaOptions() {
        XsltTrilliumBridgeTransformer transformer = new XsltTrilliumBridgeTransformer();

        assertNotNull(transformer.getEpsosToCcdaOptions());
    }

}
