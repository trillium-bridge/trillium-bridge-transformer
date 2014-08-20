package edu.mayo.trilliumbridge.cli;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class Ccda2EpsosLauncher extends AbstractBaseCliLauncher {

    public static void main(String[] args) throws IOException {
        new Ccda2EpsosLauncher().doMain(args);
    }

    @Override
    protected void doTransform(InputStream in, OutputStream out) throws Exception {
        this.getTransformer().ccdaToEpsos(in, out, null);
    }

}
