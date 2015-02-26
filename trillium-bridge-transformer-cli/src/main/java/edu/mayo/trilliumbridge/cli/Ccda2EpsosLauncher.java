package edu.mayo.trilliumbridge.cli;

import edu.mayo.trilliumbridge.core.TrilliumBridgeTransformer;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class Ccda2EpsosLauncher extends AbstractBaseCliLauncher {

    public static void main(String[] args) throws IOException {
        new Ccda2EpsosLauncher().doMain(args);
    }

    @Override
    protected void doTransform(InputStream in, OutputStream out, TrilliumBridgeTransformer.Format format) throws Exception {
        //TODO: handle params here
        this.getTransformer().ccdaToEpsos(in, out, format, null);
    }

}
