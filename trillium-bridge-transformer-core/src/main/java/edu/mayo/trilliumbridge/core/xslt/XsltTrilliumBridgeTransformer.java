package edu.mayo.trilliumbridge.core.xslt;

import edu.mayo.trilliumbridge.core.TransformException;
import edu.mayo.trilliumbridge.core.TrilliumBridgeTransformer;
import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PropertiesLoaderUtils;

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

/**
 * The XSLT transformation logic.
 */
public class XsltTrilliumBridgeTransformer implements TrilliumBridgeTransformer {

    private Logger log = Logger.getLogger(this.getClass());

    private XsltDirectoryResourceFactory resourceFactory = new XsltDirectoryResourceFactory();

    private static final String EPSOS2CCDA_XSLT_PROP = "xslt.epsos2ccda";
    private static final String CCDA2EPSOS_XSLT_PROP = "xslt.ccda2epsos";

    private static final String XSLT_CONFIG_FILE_PATH = "/xslt/xslt.properties";

    protected enum DocumentType {CCDA, EPSOS}

    private OutputXsltTranformFactory xsltTranformFactory = new OutputXsltTranformFactory();

    private static final String XSLT_BASE_PATH = "/xslt/";
    private static final String NO_OP_XSLT = "noop.xsl";

    private Resource epsos2ccdaXslt;

    private Resource ccda2epsosXslt;

    public XsltTrilliumBridgeTransformer() {
        super();
        Properties properties;
        try {
            properties = PropertiesLoaderUtils.loadProperties(this.resourceFactory.getResource(XSLT_CONFIG_FILE_PATH));
        } catch (IOException e) {
            //No props found -- use no-op
            log.warn("Cannot find XSLT properties file. Is there one on the classpath at " + XSLT_CONFIG_FILE_PATH + "?", e);
            properties = new Properties();
        }

        this.epsos2ccdaXslt = this.resourceFactory.getResource(XSLT_BASE_PATH + properties.getProperty(EPSOS2CCDA_XSLT_PROP, NO_OP_XSLT));
        this.ccda2epsosXslt = this.resourceFactory.getResource(XSLT_BASE_PATH + properties.getProperty(CCDA2EPSOS_XSLT_PROP, NO_OP_XSLT));
    }

    @Override
    public void ccdaToEpsos(InputStream ccdaStream, OutputStream epsosStream, Format outputFormat) {
        this.doTransformAndFormat(
                ccdaStream,
                this.getCcdaToEpsosXslt(),
                this.getFormatXslt(outputFormat, DocumentType.EPSOS), epsosStream, null);
    }

    @Override
    public void epsosToCcda(InputStream epsosStream, OutputStream ccdaStream, Format outputFormat) {
        this.doTransformAndFormat(
                epsosStream,
                this.getEpsosToCcdaXslt(),
                this.getFormatXslt(outputFormat, DocumentType.CCDA), ccdaStream, null);
    }

    protected InputStream getFormatXslt(Format outputFormat, DocumentType type) {
        if (!outputFormat.equals(Format.XML)) {
            return this.xsltTranformFactory.getOutputTransform(outputFormat, type);
        } else {
            return null;
        }
    }

    protected InputStream getEpsosToCcdaXslt() {
        try {
            return this.epsos2ccdaXslt.getInputStream();
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }

    protected InputStream getCcdaToEpsosXslt() {
        try {
            return this.ccda2epsosXslt.getInputStream();
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }

    protected void doTransformAndFormat(
            InputStream xmlInputStream,
            InputStream documentXsltInputStream,
            InputStream outputFormatXsltInputStream,
            OutputStream outputStream,
            Map<String, String> parameters) {
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
            if (outputFormatXsltInputStream != null) {
                this.transform(xmlInputStream, documentXsltInputStream, out, parameters);
                this.transform(new ByteArrayInputStream(out.toByteArray()), outputFormatXsltInputStream, outputStream, parameters);
            } else {
                this.transform(xmlInputStream, documentXsltInputStream, outputStream, parameters);
            }
        } finally {
            IOUtils.closeQuietly(out);
        }
    }

    protected void transform(
            InputStream xmlInputStream,
            InputStream xsltInputStream,
            OutputStream outputStream,
            Map<String, String> parameters) {
        try {
            // Source XML File
            StreamSource xmlFile = new StreamSource(xmlInputStream);

            // Source XSLT Stylesheet
            StreamSource xsltFile = new StreamSource(xsltInputStream);
            TransformerFactory xsltFactory = TransformerFactory.newInstance();

            xsltFactory.setURIResolver(new URIResolver() {
                @Override
                public Source resolve(String href, String base) throws TransformerException {
					if(!href.startsWith("http:"))
                    	href = "/xslt/" + href;
                    try {
                        return new StreamSource(resourceFactory.getResource(href).getInputStream());
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
            });

            javax.xml.transform.Transformer transformer = xsltFactory.newTransformer(xsltFile);

            if (parameters != null) {
                for (Entry<String, String> entry : parameters.entrySet()) {
                    transformer.setParameter(entry.getKey(), entry.getValue());
                }
            }

            // Send transformed output to the console
            StreamResult resultStream = new StreamResult(outputStream);

            // Apply the transformation
            transformer.transform(xmlFile, resultStream);
        } catch (Exception ex) {
            throw new TransformException(ex);
        } finally {
            IOUtils.closeQuietly(xmlInputStream);
            IOUtils.closeQuietly(xsltInputStream);
        }
    }
}