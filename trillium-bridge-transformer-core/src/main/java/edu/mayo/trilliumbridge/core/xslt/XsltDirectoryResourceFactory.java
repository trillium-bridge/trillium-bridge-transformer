package edu.mayo.trilliumbridge.core.xslt;

import org.springframework.core.io.*;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URLDecoder;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


import com.memetix.mst.language.Language;
import com.memetix.mst.translate.Translate;


/**
 */
public class XsltDirectoryResourceFactory {

    public static final String TBT_HOME_PROP = "TBT_HOME";

    public static final String TBT_CONF_DIR = "conf";

	public static final Pattern xlatere = Pattern.compile("http://trilliumbridge.org/from/(\\p{Alpha}{2})/to/(\\p{Alpha}{2})\\?text=(.*)");

    private String envXsltDirOverride;

    private static XsltDirectoryResourceFactory instance;

    private XsltDirectoryResourceFactory() {
        String prop = System.getProperty(TBT_HOME_PROP);
        if (prop != null) {
            this.envXsltDirOverride = prop + File.separator + TBT_CONF_DIR;
        }
    }

	{
		Translate.setClientId("TBXform");
		Translate.setClientSecret("uIBJDNcc5K21BCsK/w2DBQNE4ezCebif0oyiIWAep0Y=");
	}

	protected String translate(String text, String from_language, String to_language) {

		try {
			return Translate.execute(text, Language.fromString(from_language), Language.fromString(to_language));
		} catch (Exception e) {
			return text;
		}
	}

    protected Resource getResource(String path) {
		System.out.println("GetResource: " + path);
        if(path.startsWith("http:")) {
			Matcher m = xlatere.matcher(path);
			try {
				if(m.matches())
					return new ByteArrayResource( ("<string xmlns='http://schemas.microsoft.com/2003/10/Serialization/'>" +
							translate(URLDecoder.decode(m.group(3), "UTF-8"), m.group(1), m.group(2)) + "</string>").getBytes("UTF-8"));
				else
                	return new UrlResource(path);
            } catch (MalformedURLException | UnsupportedEncodingException e) {
                throw new RuntimeException(e);
            }

        } else if (this.envXsltDirOverride != null) {
            return new FileSystemResource(this.envXsltDirOverride + File.separator + path);
        } else {
            return new ClassPathResource(path);
        }
    }

    protected static synchronized XsltDirectoryResourceFactory instance() {
        if(instance == null) {
            instance = new XsltDirectoryResourceFactory();
        }

        return instance;
    }
}
