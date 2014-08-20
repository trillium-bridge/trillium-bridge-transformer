package edu.mayo.trilliumbridge.webapp;

import edu.mayo.trilliumbridge.webapp.example.ExampleCcda;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.List;

@Controller
public class HomeController {

    @Value("${app.version}")
    private String version;

    @Resource(name="exampleCcdas")
    private List<ExampleCcda> exampleCcdas;

    @RequestMapping(
            value = "/",
            method = RequestMethod.GET,
            produces = MediaType.TEXT_HTML_VALUE)
    public ModelAndView getHomePage(){
        ModelAndView home = new ModelAndView("home");
        home.addObject("exampleCcdas", exampleCcdas);
        home.addObject("version", version);

        return home;
    }

    @RequestMapping(value = "/api", method = RequestMethod.GET)
    public ModelAndView getApiPage(){
        ModelAndView home = new ModelAndView("api");

        home.addObject("version", version);

        return home;
    }

}
