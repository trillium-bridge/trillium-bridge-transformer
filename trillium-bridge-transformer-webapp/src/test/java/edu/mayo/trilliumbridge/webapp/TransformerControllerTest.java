package edu.mayo.trilliumbridge.webapp;

import org.apache.commons.lang.StringUtils;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.web.context.WebApplicationContext;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.webAppContextSetup;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml")
public class TransformerControllerTest {

    @Autowired
    private WebApplicationContext wac;

    private MockMvc mockMvc;

    @Before
    public void setup() {
        this.mockMvc = webAppContextSetup(this.wac).build();
    }

    @Test
    public void testEpsos2ccda() throws Exception {
        String testContent = "<test>content</test>";

        byte[] xml = this.mockMvc.perform(post("/epsos2ccda").accept(MediaType.APPLICATION_XML).content(testContent.getBytes())).andExpect(status().is(200)).andReturn().getResponse().getContentAsByteArray();

        assertTrue(StringUtils.isNotEmpty(new String(xml, "UTF-8")));
    }

    @Test
    public void testCcda2Epsos() throws Exception {
        String testContent = "<test>content</test>";

        byte[] xml = this.mockMvc.perform(post("/ccda2epsos").accept(MediaType.APPLICATION_XML).content(testContent.getBytes())).andExpect(status().is(200)).andReturn().getResponse().getContentAsByteArray();

        assertTrue(StringUtils.isNotEmpty(new String(xml, "UTF-8")));
    }

    @Test
    public void testEpsos2ccdaNoBody() throws Exception {
        byte[] xml = this.mockMvc.perform(post("/epsos2ccda")).andExpect(status().is(400)).andReturn().getResponse().getContentAsByteArray();

        assertEquals(new String(xml, "UTF-8").trim(), "No file or XML content body sent.".trim());
    }

    @Test
    public void testCcda2EpsosNoBody() throws Exception {
        byte[] xml = this.mockMvc.perform(post("/ccda2epsos")).andExpect(status().is(400)).andReturn().getResponse().getContentAsByteArray();

        assertEquals(new String(xml, "UTF-8").trim(), "No file or XML content body sent.".trim());
    }

    @Test
    public void testBadAccept() throws Exception {
        this.mockMvc.perform(post("/epsos2ccda").accept(MediaType.IMAGE_JPEG)).andExpect(status().is(406));
    }
}
