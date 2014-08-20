package edu.mayo.trilliumbridge.cli;

import org.kohsuke.args4j.Option;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.io.File;
import java.io.IOException;

public class Epsos2CcdaLauncher extends AbstractBaseCliLauncher {

    @Option(name="-f", required=true, usage="...")
    private File xml;

    public static void main(String[] args) throws IOException {
        new Epsos2CcdaLauncher().doMain(args);
    }

    @Override
    protected void run() throws Exception {
        ClassPathXmlApplicationContext context =
            new ClassPathXmlApplicationContext("qdm-executor-context.xml");

        context.registerShutdownHook();

        //
    }
}
