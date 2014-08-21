package edu.mayo.trilliumbridge.core.xslt;

import edu.mayo.trilliumbridge.core.TrilliumBridgeTransformer;
import org.apache.commons.io.IOUtils;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.util.Map;
import java.util.Map.Entry;

/**
 * The XSLT Transformation logic.
 */
@Component
public class XsltTrilliumBridgeTransformer implements TrilliumBridgeTransformer {

    protected enum DocumentType { CCDA, EPSOS }

    private OutputXsltTranformFactory xsltTranformFactory = new OutputXsltTranformFactory();

    private static final Resource NO_OP_XSLT = new ClassPathResource("/xslt/noop.xsl");

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
        if(! outputFormat.equals(Format.XML)) {
            return this.xsltTranformFactory.getOutputTransform(outputFormat, type);
        } else {
            return null;
        }
    }

    protected InputStream getEpsosToCcdaXslt() {
        try {
            return NO_OP_XSLT.getInputStream();
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }

    protected InputStream getCcdaToEpsosXslt() {
        try {
            return NO_OP_XSLT.getInputStream();
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }

    protected void doTransformAndFormat(
            InputStream xmlInputStream,
            InputStream documentXsltInputStream,
            InputStream outputFormatXsltInputStream,
            OutputStream outputStream,
            Map<String,String> parameters){
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
            if(outputFormatXsltInputStream != null) {
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
            Map<String,String> parameters){
        try {
            // Source XML File
            StreamSource xmlFile = new StreamSource(xmlInputStream);

            // Source XSLT Stylesheet
            StreamSource xsltFile = new StreamSource(xsltInputStream);
            TransformerFactory xsltFactory = TransformerFactory.newInstance();

            xsltFactory.setURIResolver(new URIResolver() {
                @Override
                public Source resolve(String href, String base) throws TransformerException {
                    href = "/xslt/" + href;
                    try {
                        return new StreamSource(new ClassPathResource(href).getInputStream());
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                }
            });

            javax.xml.transform.Transformer transformer = xsltFactory.newTransformer(xsltFile);

            if(parameters != null){
                for(Entry<String, String> entry : parameters.entrySet()){
                    transformer.setParameter(entry.getKey(), entry.getValue());
                }
            }

            // Send transformed output to the console
            StreamResult resultStream = new StreamResult(outputStream);

            // Apply the transformation
            transformer.transform(xmlFile, resultStream);
        } catch(Exception ex) {
            throw new RuntimeException(ex);
        } finally {
            IOUtils.closeQuietly(xmlInputStream);
            IOUtils.closeQuietly(xsltInputStream);
        }
    }
}