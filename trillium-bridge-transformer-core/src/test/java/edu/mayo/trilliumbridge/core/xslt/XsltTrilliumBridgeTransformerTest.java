package edu.mayo.trilliumbridge.core.xslt;

import edu.mayo.trilliumbridge.core.TrilliumBridgeTransformer;
import org.apache.commons.io.IOUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.xml.sax.SAXException;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collection;

import static org.custommonkey.xmlunit.XMLAssert.assertXMLEqual;

@RunWith(Parameterized.class)
public class XsltTrilliumBridgeTransformerTest {

    private static Resource marthaCcda = new ClassPathResource("/nooptransform/ccda/RTD_CCD_Martha.xml");
    private static Resource marthaEpsos = new ClassPathResource("/nooptransform/epsos/RTD_CCD_Martha_as_PS.xml");
    private static Resource paoloCcda = new ClassPathResource("/nooptransform/ccda/RTD_PS_Paolo_IT_as_CCD.xml");
    private static Resource paoloEpsos = new ClassPathResource("/nooptransform/epsos/RTD_PS_Paolo_IT_L3_v2.xml");

    private Resource ccdaResource;
    private Resource epsosResource;

    @Parameterized.Parameters
    public static Collection tests() {
        return Arrays.asList(new Object[][]{
                {marthaCcda, marthaEpsos},
                {paoloCcda, paoloEpsos}
        });
    }

    public XsltTrilliumBridgeTransformerTest(Resource ccdaResource, Resource epsosResource) {
        super();
        this.ccdaResource = ccdaResource;
        this.epsosResource = epsosResource;
    }

    @Test
    public void testCcdaToEpsos() throws IOException, SAXException {
        XsltTrilliumBridgeTransformer transformer = new XsltTrilliumBridgeTransformer();

        ByteArrayOutputStream out = new ByteArrayOutputStream();
        transformer.ccdaToEpsos(this.ccdaResource.getInputStream(), out, TrilliumBridgeTransformer.Format.XML);

        assertXMLEqual(new String(out.toByteArray()), new String(IOUtils.toByteArray(epsosResource.getInputStream())));
    }

    @Test
    public void testEpsosToCcda() throws IOException, SAXException {
        XsltTrilliumBridgeTransformer transformer = new XsltTrilliumBridgeTransformer();

        ByteArrayOutputStream out = new ByteArrayOutputStream();
        transformer.epsosToCcda(this.epsosResource.getInputStream(), out, TrilliumBridgeTransformer.Format.XML);

        assertXMLEqual(new String(out.toByteArray()), new String(IOUtils.toByteArray(ccdaResource.getInputStream())));
    }
}
