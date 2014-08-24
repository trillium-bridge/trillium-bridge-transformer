package edu.mayo.trilliumbridge.core;

/**
 * Exception for when a requested output is not valid or not available.
 */
public class UnsupportedOutputFormatException extends RuntimeException {

    public UnsupportedOutputFormatException(TrilliumBridgeTransformer.Format format) {
        super("Output format " + format.toString() + " is currently unavailable for the requested transformation.");
    }
}
