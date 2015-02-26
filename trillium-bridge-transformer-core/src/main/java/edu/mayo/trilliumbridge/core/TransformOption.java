package edu.mayo.trilliumbridge.core;

public class TransformOption {

    private String optionName;

    private String optionValue;

    public TransformOption() {
        super();
    }

    public TransformOption(String optionName, String optionValue) {
        super();
        this.optionName = optionName;
        this.optionValue = optionValue;
    }

    public String getOptionName() {
        return optionName;
    }

    public void setOptionName(String optionName) {
        this.optionName = optionName;
    }

    public String getOptionValue() {
        return optionValue;
    }

    public void setOptionValue(String optionValue) {
        this.optionValue = optionValue;
    }
}
