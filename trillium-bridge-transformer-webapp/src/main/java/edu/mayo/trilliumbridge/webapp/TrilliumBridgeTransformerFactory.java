package edu.mayo.trilliumbridge.webapp;

import edu.mayo.trilliumbridge.core.TrilliumBridgeTransformer;
import edu.mayo.trilliumbridge.core.xslt.XsltTrilliumBridgeTransformer;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.stereotype.Component;

@Component
public class TrilliumBridgeTransformerFactory implements FactoryBean<TrilliumBridgeTransformer> {

    @Override
    public TrilliumBridgeTransformer getObject() throws Exception {
        return new XsltTrilliumBridgeTransformer();
    }

    @Override
    public Class<?> getObjectType() {
        return TrilliumBridgeTransformer.class;
    }

    @Override
    public boolean isSingleton() {
        return true;
    }
}
