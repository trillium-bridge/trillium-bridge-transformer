package edu.mayo.trilliumbridge.webapp;

import org.springframework.http.HttpStatus;

/**
 */
public class UserInputException  extends RuntimeException {

    private static final HttpStatus DEFAULT_STATUS = HttpStatus.BAD_REQUEST;

    private HttpStatus status;

    private static final long serialVersionUID = 1L;

    /**
     * Instantiates a new user input exception.
     *
     * @param message the message
     */
    public UserInputException(String message) {
        this(message, DEFAULT_STATUS);
    }

    public UserInputException(String message, HttpStatus status) {
        super(message);
        this.status = status;
    }

    public HttpStatus getStatus() {
        return status;
    }

    public void setStatus(HttpStatus status) {
        this.status = status;
    }
}
