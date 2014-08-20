package edu.mayo.trilliumbridge.webapp.example;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ExampleCcdaController implements InitializingBean {

    @Resource(name="exampleCcdas")
    private List<ExampleCcda> exampleCcdas;

    private Map<String,String> xmlMap = new HashMap<String,String>();

    @Override
    public void afterPropertiesSet() throws Exception {
        for(ExampleCcda exampleCcda : this.exampleCcdas) {
            this.xmlMap.put(exampleCcda.getName(), exampleCcda.getXml());
        }
    }

    @RequestMapping(value = "/examples/ccda/{ccda}", method = RequestMethod.GET, produces = MediaType.TEXT_XML_VALUE)
    @ResponseBody
    public String getExampleCcda(@PathVariable("ccda") String ccda){
        return this.xmlMap.get(ccda);
    }
}
