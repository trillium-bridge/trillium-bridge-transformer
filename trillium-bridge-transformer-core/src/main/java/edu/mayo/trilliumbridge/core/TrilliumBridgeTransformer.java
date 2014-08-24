package edu.mayo.trilliumbridge.core;

import java.io.InputStream;
import java.io.OutputStream;

/**
 * Transformation interface for converting XML files to and from CCDA and epSOS format.
 */
public interface TrilliumBridgeTransformer {

    /**
     * Valid output formats
     */
    public enum Format {XML, HTML, PDF}

    /**
     * Convert a CCDA XML document into epSOS format.
     *
     * @param ccdaStream the CCDA document
     * @param epsosStream the output stream
     * @param outputFormat the output format
     */
    public void ccdaToEpsos(InputStream ccdaStream, OutputStream epsosStream, Format outputFormat);

    /**
     * Convert an epSOS XML document into CCDA format
     *
     * @param epsosStream the epSOS document
     * @param ccdaStream the output stream
     * @param outputFormat the output format
     */
    public void epsosToCcda(InputStream epsosStream, OutputStream ccdaStream, Format outputFormat);

}
