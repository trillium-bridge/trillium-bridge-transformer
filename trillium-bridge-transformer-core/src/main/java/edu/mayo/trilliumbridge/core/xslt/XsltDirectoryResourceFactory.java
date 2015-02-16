package edu.mayo.trilliumbridge.core.xslt;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;

import java.io.File;
import java.net.MalformedURLException;

/**
 */
public class XsltDirectoryResourceFactory {

    public static final String TBT_HOME_PROP = "TBT_HOME";

    public static final String TBT_CONF_DIR = "conf";

    private String envXsltDirOverride;

    protected XsltDirectoryResourceFactory() {
        String prop = System.getProperty(TBT_HOME_PROP);
        if (prop != null) {
            this.envXsltDirOverride = prop + File.separator + TBT_CONF_DIR;
        }
    }

    protected Resource getResource(String path) {
        if(path.startsWith("http:")) {
            try {
                return new UrlResource(path);
            } catch (MalformedURLException e) {
                throw new RuntimeException(e);
            }
        } else if (this.envXsltDirOverride != null) {
            return new FileSystemResource(this.envXsltDirOverride + File.separator + path);
        } else {
            return new ClassPathResource(path);
        }
    }
}
