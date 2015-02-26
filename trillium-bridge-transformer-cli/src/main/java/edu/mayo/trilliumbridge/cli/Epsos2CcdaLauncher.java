package edu.mayo.trilliumbridge.cli;

import edu.mayo.trilliumbridge.core.TrilliumBridgeTransformer;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class Epsos2CcdaLauncher extends AbstractBaseCliLauncher {

    public static void main(String[] args) throws IOException {
        new Epsos2CcdaLauncher().doMain(args);
    }

    @Override
    protected void doTransform(InputStream in, OutputStream out, TrilliumBridgeTransformer.Format format) throws Exception {
        //TODO: handle params here
        this.getTransformer().epsosToCcda(in, out, format, null);
    }
}
