package edu.mayo.trilliumbridge.core;

/**
 */
public class UnsupportedOutputFormatException extends RuntimeException {

    public UnsupportedOutputFormatException(TrilliumBridgeTransformer.Format format) {
       super("Output format " + format.toString() + " is currently unavailable for the requested transformation.");
    }
}
