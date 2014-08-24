package edu.mayo.trilliumbridge.core.xslt;

import org.junit.Test;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;

import static org.junit.Assert.assertTrue;

/**
 */
public class XsltDirectoryResourceFactoryTest {

    @Test
    public void testGetResourceDefault() throws Exception {
        XsltDirectoryResourceFactory factory = new XsltDirectoryResourceFactory();

        assertTrue(factory.getResource("test") instanceof ClassPathResource);
    }

    @Test
    public void testGetResourceOverride() throws Exception {
        System.setProperty(XsltDirectoryResourceFactory.TBT_HOME_PROP, "test");
        XsltDirectoryResourceFactory factory = new XsltDirectoryResourceFactory();

        assertTrue(factory.getResource("test") instanceof FileSystemResource);
        System.clearProperty(XsltDirectoryResourceFactory.TBT_HOME_PROP);
    }
}
