<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:v3="urn:hl7-org:v3"
    version="1.0">
    
    <!-- epSOS to CCDA -->
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- 
        7.1.1 Administrative Gender
        epSOS: /ClinicalDocument[templateId/@root="1.3.6.1.4.1.12559.11.10.1.3.1.1.3"]/recordTarget/patientRole/patient/administrativeGenderCode
        CCD:   /ClinicalDocument[templateId/@root="2.16.840.1.113883.10.20.22.1.2"]/recordTarget/patientRole/patient/administrativeGenderCode
    -->
    <xsl:template match="/v3:ClinicalDocument/v3:templateId[@root='1.3.6.1.4.1.12559.11.10.1.3.1.1.3'][../v3:recordTarget/v3:patientRole/v3:patient/v3:administrativeGenderCode]">
        <xsl:element name="templateId" namespace="urn:hl7-org:v3">
            <xsl:attribute name="root">2.16.840.1.113883.10.20.22.1.2</xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    
    <!-- 
        7.1.2.1 Patient Country of Living
        epSOS: /ClinicalDocument[templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.2.4"]/recordTarget/patientRole/addr/country
        CCD:   /ClinicalDocument[templateId/@root="2.16.840.1.113883.10.20.22.1.2"]/recordTarget/patientRole/addr/country
    -->
    <xsl:template match="/v3:ClinicalDocument/v3:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.2.4'][../v3:recordTarget/v3:patientRole/v3:addr/v3:country]">
        <xsl:element name="templateId" namespace="urn:hl7-org:v3">
            <xsl:attribute name="root">2.16.840.1.113883.10.20.22.1.2</xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    
    <!-- 
        7.1.2.2 Guardian’s Country
        epSOS: /ClinicalDocument[templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.2.4"]/recordTarget/patientRole/patient/guardian/addr/country
        CCD:   /ClinicalDocument[templateId/@root="2.16.840.1.113883.10.20.22.1.2"]/recordTarget/patientRole/patient/guardian/addr/country
    -->
    <xsl:template match="/v3:ClinicalDocument/v3:templateId[@root='1.3.6.1.4.1.19376.1.5.3.1.2.4'][../v3:recordTarget/v3:patientRole/v3:addr/v3:country]">
        <xsl:element name="templateId" namespace="urn:hl7-org:v3">
            <xsl:attribute name="root">2.16.840.1.113883.10.20.22.1.2</xsl:attribute>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>