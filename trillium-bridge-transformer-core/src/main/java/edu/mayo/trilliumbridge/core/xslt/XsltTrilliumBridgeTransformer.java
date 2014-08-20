package edu.mayo.trilliumbridge.core.xslt;

import edu.mayo.trilliumbridge.core.TrilliumBridgeTransformer;
import org.apache.commons.io.IOUtils;
import org.springframework.stereotype.Component;

import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.Map;
import java.util.Map.Entry;

/**
 * The XSLT Transformation logic.
 */
@Component
public class XsltTrilliumBridgeTransformer implements TrilliumBridgeTransformer {

    @Override
    public void ccdaToEpsos(InputStream ccdaStream, OutputStream epsosStream, Format outputFormat) {
        try {
            IOUtils.copy(new InputStreamReader(ccdaStream), epsosStream, "UTF-8");
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void epsosToCcda(InputStream epsosStream, OutputStream ccdaStream, Format outputFormat) {
        try {
            IOUtils.copy(new InputStreamReader(epsosStream), ccdaStream, "UTF-8");
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Transform.
     *
     * @param xmlInputStream the xml input stream
     * @param xsltInputStream the xslt input stream
     * @param outputStream the output stream
     * @param parameters the parameters
     */
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
        }
    }
}