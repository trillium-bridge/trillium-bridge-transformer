package edu.mayo.trilliumbridge.core;

/**
 */
public class TransformException extends RuntimeException {

    private static final String ERROR_MSG = "XSLT transformation error";

    public TransformException(Exception e) {
        super(ERROR_MSG + ": " + e.getMessage(), e);
    }
}
