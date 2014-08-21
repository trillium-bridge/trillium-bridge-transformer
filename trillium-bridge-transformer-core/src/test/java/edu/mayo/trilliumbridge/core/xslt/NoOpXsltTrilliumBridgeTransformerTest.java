package edu.mayo.trilliumbridge.core.xslt;

import edu.mayo.trilliumbridge.core.TrilliumBridgeTransformer;
import org.junit.Test;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.xml.sax.SAXException;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import static org.junit.Assert.*;

public class NoOpXsltTrilliumBridgeTransformerTest {

    private static Resource badId = new ClassPathResource("/sampleinput/epsos/epSOS_RTD_PS_EU_Pivot_CDA_Martha_bad_id.xml");
    private static Resource goodId = new ClassPathResource("/sampleinput/epsos/epSOS_RTD_PS_EU_Pivot_CDA_Martha.xml");

    @Test
    public void testCcdaToEpsosBadId() throws IOException, SAXException {
        XsltTrilliumBridgeTransformer transformer = new XsltTrilliumBridgeTransformer();

        ByteArrayOutputStream out = new ByteArrayOutputStream();
        transformer.epsosToCcda(this.badId.getInputStream(), out, TrilliumBridgeTransformer.Format.XML);

        assertTrue(new String(out.toByteArray()).contains("WARNING!!!! This was a No-Op Transformation"));
    }

    @Test
    public void testCcdaToEpsosGoodId() throws IOException, SAXException {
        XsltTrilliumBridgeTransformer transformer = new XsltTrilliumBridgeTransformer();

        ByteArrayOutputStream out = new ByteArrayOutputStream();
        transformer.epsosToCcda(this.goodId.getInputStream(), out, TrilliumBridgeTransformer.Format.XML);

        assertFalse(new String(out.toByteArray()).contains("WARNING!!!! This was a No-Op Transformation"));
    }

}
