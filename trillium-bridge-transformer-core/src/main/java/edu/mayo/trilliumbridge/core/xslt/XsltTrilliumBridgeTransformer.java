package edu.mayo.trilliumbridge.core.xslt;

import com.fasterxml.jackson.databind.ObjectMapper;
import edu.mayo.trilliumbridge.core.TransformException;
import edu.mayo.trilliumbridge.core.TransformOption;
import edu.mayo.trilliumbridge.core.TransformOptionDefinition;
import edu.mayo.trilliumbridge.core.TrilliumBridgeTransformer;
import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.springframework.core.io.support.PropertiesLoaderUtils;

import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.util.*;
import java.util.Map.Entry;

/**
 * The XSLT transformation logic.
 */
public class XsltTrilliumBridgeTransformer implements TrilliumBridgeTransformer {

    private ObjectMapper mapper = new ObjectMapper();

    private Logger log = Logger.getLogger(this.getClass());

    private XsltDirectoryResourceFactory resourceFactory = XsltDirectoryResourceFactory.instance();

    private static final String EPSOS2CCDA_XSLT_PROP = "xslt.epsos2ccda";
    private static final String CCDA2EPSOS_XSLT_PROP = "xslt.ccda2epsos";

    private static final String XSLT_CONFIG_FILE_PATH = "/xslt/xslt.properties";

    protected enum DocumentType {CCDA, EPSOS}

    private String EPSOS2CCDA_OPTIONS_FILE_PATH = "/xslt/epsos2ccda_options.json";
    private String CCDA2EPSOS_OPTIONS_FILE_PATH = "/xslt/ccda2epsos_options.json";

    private OutputXsltTranformFactory xsltTranformFactory = new OutputXsltTranformFactory();

    private Set<TransformOptionDefinition> epsosToCcdaOptions;

    private Set<TransformOptionDefinition> ccdaToEpsosOptions;

    private static final String XSLT_BASE_PATH = "/xslt/";
    private static final String NO_OP_XSLT = "noop.xsl";

    private javax.xml.transform.Transformer epsos2ccdaTransformer;

    private javax.xml.transform.Transformer ccda2epsosTransformer;

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

        this.epsos2ccdaTransformer = XsltUtils.buildTransformer(
                this.resourceFactory.getResource(XSLT_BASE_PATH + properties.getProperty(EPSOS2CCDA_XSLT_PROP, NO_OP_XSLT)));
        this.ccda2epsosTransformer = XsltUtils.buildTransformer(
                this.resourceFactory.getResource(XSLT_BASE_PATH + properties.getProperty(CCDA2EPSOS_XSLT_PROP, NO_OP_XSLT)));

        this.epsosToCcdaOptions = this.getOptions(EPSOS2CCDA_OPTIONS_FILE_PATH);
        this.ccdaToEpsosOptions = this.getOptions(CCDA2EPSOS_OPTIONS_FILE_PATH);
    }

    @Override
    public void ccdaToEpsos(InputStream ccdaStream, OutputStream epsosStream, Format outputFormat, List<TransformOption> parameters) {
        this.doTransformAndFormat(
                ccdaStream,
                this.ccda2epsosTransformer,
                this.getFormatXslt(outputFormat, DocumentType.EPSOS), epsosStream, parameters);
    }

    @Override
    public void epsosToCcda(InputStream epsosStream, OutputStream ccdaStream, Format outputFormat, List<TransformOption> parameters) {
        this.doTransformAndFormat(
                epsosStream,
                this.epsos2ccdaTransformer,
                this.getFormatXslt(outputFormat, DocumentType.CCDA), ccdaStream, parameters);
    }

    protected javax.xml.transform.Transformer getFormatXslt(Format outputFormat, DocumentType type) {
        if (!outputFormat.equals(Format.XML)) {
            return this.xsltTranformFactory.getOutputTransform(outputFormat, type);
        } else {
            return null;
        }
    }

    protected void doTransformAndFormat(
            InputStream xmlInputStream,
            javax.xml.transform.Transformer documentXsltTransformer,
            javax.xml.transform.Transformer outputFormatXsltTransformer,
            OutputStream outputStream,
            List<TransformOption> transformOptions) {
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        Map<String,String> parameters = this.toParameters(transformOptions);
        try {
            if (outputFormatXsltTransformer != null) {
                this.transform(xmlInputStream, documentXsltTransformer, out, parameters);
                this.transform(new ByteArrayInputStream(out.toByteArray()), outputFormatXsltTransformer, outputStream, parameters);
            } else {
                this.transform(xmlInputStream, documentXsltTransformer, outputStream, parameters);
            }
        } finally {
            IOUtils.closeQuietly(out);
        }
    }

    private Map<String, String> toParameters(List<TransformOption> transformOptions) {
        if(transformOptions == null) {
            return null;
        }

        Map<String,String> parameters = new HashMap<String,String>();

        for(TransformOption option : transformOptions) {
            parameters.put(option.getOptionName(), option.getOptionValue());
        }

        return parameters;
    }

    protected void transform(
            InputStream xmlInputStream,
            javax.xml.transform.Transformer xsltTransformer,
            OutputStream outputStream,
            Map<String, String> parameters) {
        try {
            // Source XML File
            StreamSource xmlFile = new StreamSource(xmlInputStream);

            synchronized (xsltTransformer) {
                if (parameters != null) {
                    for (Entry<String, String> entry : parameters.entrySet()) {
                        xsltTransformer.setParameter(entry.getKey(), entry.getValue());
                    }
                }

                // Send transformed output to the console
                StreamResult resultStream = new StreamResult(outputStream);

                // Apply the transformation
                xsltTransformer.transform(xmlFile, resultStream);

                xsltTransformer.reset();
            }
        } catch (Exception ex) {
            throw new TransformException(ex);
        } finally {
            IOUtils.closeQuietly(xmlInputStream);
        }
    }

    @Override
    public Set<TransformOptionDefinition> getCcdaToEpsosOptions() {
        return this.ccdaToEpsosOptions;
    }

    @Override
    public Set<TransformOptionDefinition> getEpsosToCcdaOptions() {
        return this.epsosToCcdaOptions;
    }

    protected Set<TransformOptionDefinition> getOptions(String optionsPath) {
        try {
            return new HashSet<TransformOptionDefinition>(
                    Arrays.asList(
                        mapper.readValue(
                            this.resourceFactory.getResource(optionsPath).getInputStream(), TransformOptionDefinition[].class)));
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }

}