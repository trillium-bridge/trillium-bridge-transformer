package edu.mayo.trilliumbridge.cli;

import org.kohsuke.args4j.CmdLineException;
import org.kohsuke.args4j.CmdLineParser;
import org.kohsuke.args4j.Option;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.support.PropertiesLoaderUtils;

import java.io.IOException;
import java.util.Properties;

/**
 */
public abstract class AbstractBaseCliLauncher {

    @Option(name="-h", aliases={"-help","--help"}, usage ="Print this message")
    private boolean help = false;

    @Option(name="-v", aliases={"-version","--version"}, usage ="Print the application version")
    private boolean version;

    public void doMain(String[] args) throws IOException {
        System.setProperty("log4j.configuration", "trilliumbridge-cli-log4j.xml");

        CmdLineParser parser = new CmdLineParser(this);

        // if you have a wider console, you could increase the value;
        // here 80 is also the default
        parser.setUsageWidth(80);

        try {
            // parse the arguments.
            parser.parseArgument(args);
        } catch( CmdLineException e ) {
            System.err.print(e.getMessage());
            parser.printUsage(System.err);
            return;
        }

        if(this.help){
            parser.printUsage(System.out);
            return;
        }

        if(this.version){
            Properties properties = PropertiesLoaderUtils.loadProperties(
                    new ClassPathResource("/trilliumbridge-version.properties"));
            System.out.println(properties.getProperty("app.version"));
            return;
        }

        try {
            this.run();
        } catch( Exception e ) {
            System.err.print(e.getMessage());
        }
    }

    protected abstract void run() throws Exception;

}
