package edu.mayo.trilliumbridge.webapp;

import edu.mayo.trilliumbridge.core.TransformOptionDefinition;
import edu.mayo.trilliumbridge.core.TrilliumBridgeTransformer;
import edu.mayo.trilliumbridge.webapp.example.ExampleCcda;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import java.util.Arrays;
import java.util.List;
import java.util.Set;

@Controller
public class HomeController {

    @Value("${app.version}")
    private String version;

    @Autowired
    private TrilliumBridgeTransformer transformer;

    //Unused
    //@Resource(name="exampleCcdas")
    private List<ExampleCcda> exampleCcdas;

    @RequestMapping(
            value = "/",
            method = RequestMethod.GET,
            produces = MediaType.TEXT_HTML_VALUE)
    public ModelAndView getHomePage(){
        ModelAndView home = new ModelAndView("home");
        home.addObject("exampleCcdas", exampleCcdas);
        home.addObject("version", version);
        home.addObject("options", Arrays.asList(
                new TransformNameAndOptions("transformerParams", this.transformer.getTransformerParams())));

        return home;
    }

    public static class TransformNameAndOptions {
        private String name;
        private Set<TransformOptionDefinition> options;

        public TransformNameAndOptions(String name, Set<TransformOptionDefinition> options) {
            this.name = name;
            this.options = options;
        }

        public Set<TransformOptionDefinition> getOptions() {
            return options;
        }

        public String getName() {
            return name;
        }
    }

    @RequestMapping(value = "/api", method = RequestMethod.GET)
    public ModelAndView getApiPage(){
        ModelAndView home = new ModelAndView("api");

        home.addObject("version", version);

        return home;
    }

}
