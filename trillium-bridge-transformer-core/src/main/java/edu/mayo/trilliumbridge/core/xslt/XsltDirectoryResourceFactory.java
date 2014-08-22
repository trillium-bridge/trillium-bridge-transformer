package edu.mayo.trilliumbridge.core.xslt;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;

import java.io.File;

/**
 */
public class XsltDirectoryResourceFactory {

    public static final String XSLT_DIR_PROP = "tbt.xslt.dir";

    private String envXsltDirOverride;

    protected XsltDirectoryResourceFactory() {
        String prop = System.getProperty(XSLT_DIR_PROP);
        if(prop != null) {
            this.envXsltDirOverride = prop;
        }
    }

    protected Resource getResource(String path) {
        if(this.envXsltDirOverride != null) {
            return new FileSystemResource(this.envXsltDirOverride + File.separator + path);
        } else {
            return new ClassPathResource(path);
        }
    }
}
