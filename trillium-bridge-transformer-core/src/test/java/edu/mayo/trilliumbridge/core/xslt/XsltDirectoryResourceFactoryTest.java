package edu.mayo.trilliumbridge.core.xslt;

import org.junit.Test;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;

import java.lang.reflect.Field;

import static org.junit.Assert.assertTrue;

/**
 */
public class XsltDirectoryResourceFactoryTest {

    @Test
    public void testGetResourceDefaultAndOverride() throws Exception {
        XsltDirectoryResourceFactory factory = XsltDirectoryResourceFactory.instance();

        assertTrue(factory.getResource("test") instanceof ClassPathResource);

        System.setProperty(XsltDirectoryResourceFactory.TBT_HOME_PROP, "test");

        // jack the instance to clear it
        Field instance = XsltDirectoryResourceFactory.class.getDeclaredField("instance");
        instance.setAccessible(true);
        instance.set(null, null);

        factory = XsltDirectoryResourceFactory.instance();

        assertTrue(factory.getResource("test") instanceof FileSystemResource);
        System.clearProperty(XsltDirectoryResourceFactory.TBT_HOME_PROP);
    }
}
