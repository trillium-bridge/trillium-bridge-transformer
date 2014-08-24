package edu.mayo.trilliumbridge.webapp;

import edu.mayo.trilliumbridge.core.TransformException;
import edu.mayo.trilliumbridge.core.UnsupportedOutputFormatException;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.DefaultHandlerExceptionResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import java.io.IOException;

@ControllerAdvice
public class ErrorHandlingControllerAdvice {

    private Logger log = Logger.getLogger(this.getClass());

    private static String MOZILLA = "Mozilla";

    @Autowired
    private DefaultHandlerExceptionResolver defaultHandlerExceptionResolver;

    @ExceptionHandler(UserInputException.class)
    public ModelAndView handleUserInputException(
            HttpServletRequest request,
            HttpServletResponse response,
            UserInputException ex) {
        ModelAndView mav = new ModelAndView("error");

        response.setStatus(ex.getStatus().value());

        return this.doResolveError(request, response, mav, ex.getMessage());
    }

    @ExceptionHandler(UnsupportedOutputFormatException.class)
    public ModelAndView handleUnsupportedOutputFormatException(
            HttpServletRequest request,
            HttpServletResponse response,
            UnsupportedOutputFormatException ex) {
        ModelAndView mav = new ModelAndView("error");

        response.setStatus(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE);

        return this.doResolveError(request, response, mav, ex.getMessage());
    }

    @ExceptionHandler(TransformException.class)
    public ModelAndView handleTransformException(
            HttpServletRequest request,
            HttpServletResponse response,
            TransformException ex) {
        ModelAndView mav = new ModelAndView("error");

        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        return this.doResolveError(request, response, mav, ex.getMessage());
    }

    @ExceptionHandler(value = Exception.class)
    public ModelAndView defaultErrorHandler(
            HttpServletRequest request,
            HttpServletResponse response,
            Exception ex) {

        class ExceptionHttpServletResponseWrapper extends HttpServletResponseWrapper {

            private String errorMsg;

            private ExceptionHttpServletResponseWrapper(HttpServletResponse response) {
                super(response);
            }


            @Override
            public void sendError(int sc, String msg) throws IOException {
                super.setStatus(sc);
                this.errorMsg = msg;
            }

            @Override
            public void sendError(int sc) throws IOException {
                super.setStatus(sc);
            }
        };

        ExceptionHttpServletResponseWrapper wrapper = new ExceptionHttpServletResponseWrapper(response);

        ModelAndView mav = this.defaultHandlerExceptionResolver.resolveException(request, wrapper, null, ex);

        String message = null;

        // default handler didn't catch it
        if(mav == null) {
            mav = new ModelAndView();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            if(StringUtils.isBlank(message)) {
                message = ex.getMessage();
            }

            if(StringUtils.isBlank(null)) {
                message = "A " + ex.getClass().getName() + " was thrown. Please consult server logs for more information.";
            }

        } else {
            if(StringUtils.isNotBlank(wrapper.errorMsg)) {
                message = wrapper.errorMsg;
            } else {
                message = ex.getMessage();
            }

        }
        mav.setViewName("error");

        log.warn("Server Error", ex);

        return this.doResolveError(request, response, mav, message);
    }

    protected ModelAndView doResolveError(HttpServletRequest request,
                                  HttpServletResponse response,
                                  ModelAndView modelAndView,
                                  String message) {
        String userAgent = request.getHeader("user-agent");
        if(StringUtils.startsWithIgnoreCase(userAgent, MOZILLA)) {
            modelAndView.addObject("message", message);

            return modelAndView;
        } else {
            response.setContentType(MediaType.TEXT_PLAIN_VALUE);

            try {
                response.getWriter().println(message);
            } catch (IOException e) {
                throw new IllegalStateException(e);
            }

            return null;
        }
    }

}
