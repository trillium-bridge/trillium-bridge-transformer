package edu.mayo.trilliumbridge.core;

import java.io.InputStream;
import java.io.OutputStream;

/**
 */
public interface TrilliumBridgeTransformer {

    public enum Format {XML}

    public void ccdaToEpsos(InputStream ccdaStream, OutputStream epsosStream, Format outputFormat);

    public void epsosToCcda(InputStream epsosStream, OutputStream ccdaStream, Format outputFormat);

}
