package edu.mayo.trilliumbridge.cli;

import org.kohsuke.args4j.Option;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class Epsos2CcdaLauncher extends AbstractBaseCliLauncher {

    @Option(name="-f", required=true, usage="...")
    private File xml;

    public static void main(String[] args) throws IOException {
        new Epsos2CcdaLauncher().doMain(args);
    }

    @Override
    protected void doTransform(InputStream in, OutputStream out) throws Exception {
        this.getTransformer().epsosToCcda(in, out, null);
    }
}
