package edu.mayo.trilliumbridge.webapp.example;

/**
 */
public class ExampleCcda {

    private String name;
    private String collectionName;
    private String xml;

    public ExampleCcda(String name, String collectionName, String xml) {
        this.name = name;
        this.collectionName = collectionName;
        this.xml = xml;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCollectionName() {
        return collectionName;
    }

    public void setCollectionName(String collectionName) {
        this.collectionName = collectionName;
    }

    public String getXml() {
        return xml;
    }

    public void setXml(String xml) {
        this.xml = xml;
    }
}
