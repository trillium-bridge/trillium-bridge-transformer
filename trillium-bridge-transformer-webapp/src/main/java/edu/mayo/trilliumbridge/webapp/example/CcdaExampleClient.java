package edu.mayo.trilliumbridge.webapp.example;

import edu.mayo.trilliumbridge.webapp.BasicRequestFactory;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

//Unused now.
//@Component("exampleCcdas")
public class CcdaExampleClient implements FactoryBean, InitializingBean {

    private RestTemplate restTemplate;

    @Value("${github.username:}")
    private String githubUsername;

    @Value("${github.password:}")
    private String githubPassword;

    @Override
    public void afterPropertiesSet() throws Exception {
        if(StringUtils.isBlank(this.githubUsername) || StringUtils.isBlank(this.githubPassword)) {
            this.restTemplate = BasicRequestFactory.createTemplate();
        } else {
            this.restTemplate = BasicRequestFactory.createTemplate(this.githubUsername, this.githubPassword);
        }
    }

    @Override
    public Object getObject() throws Exception {
        return this.getExamples();
    }

    @Override
    public Class<?> getObjectType() {
        return List.class;
    }

    @Override
    public boolean isSingleton() {
        return true;
    }

    protected List<ExampleCcda> getExamples() throws IOException {
        List<ExampleCcda> returnList = new ArrayList<ExampleCcda>();

        List<Map<String,Object>> results = this.restTemplate.getForObject("https://api.github.com/repos/jmandel/sample_ccdas/contents", List.class);

        for(Map<String,Object> result : results) {
            String collectionName = result.get("name").toString();
            if(result.get("type").equals("dir") && collectionName.equals("HL7 Samples")) {
                List<Map<String,Object>> files = this.restTemplate.getForObject(URI.create(result.get("url").toString()), List.class);
                for(Map<String,Object> file : files) {
                    Map<String,Object> entry = this.restTemplate.getForObject(URI.create(file.get("url").toString()), Map.class);
                    String xml = new String(Base64.decodeBase64(entry.get("content").toString()), "UTF-8");
                    String name = entry.get("name").toString();

                    returnList.add(new ExampleCcda(name, collectionName, xml));
                }
            }
        }

        return returnList;
    }
}
