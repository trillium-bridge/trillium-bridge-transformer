<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:v3="urn:hl7-org:v3"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0" xpath-default-namespace="urn:hl7-org:v3">
    
    <xsl:template name="mapValueSet">
        <xsl:param name="from"/>
        <xsl:param name="to"/>
        <xsl:choose>
            <xsl:when test="$from = $to">
                <xsl:attribute name="code" select="@code"/>
                <xsl:attribute name="codeSystem" select="@codesystem"/>
                <xsl:attribute name="displayName" select="@displayName"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="//ClinicalDocument[templateId/@root='2.16.840.1.113883.10.20.22.1.2']">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="CCDtoepSOS">
                <xsl:with-param name="path" select="concat('/', name())"></xsl:with-param>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="templateId" mode="CCDtoepSOS" xmlns="urn:hl7-org:v3">
        <xsl:param name="path"/>
        <xsl:copy>
            <xsl:if test="@root">
                <xsl:attribute name="root">
                     <xsl:choose>
                         <xsl:when test="@root='2.16.840.1.113883.10.20.22.1.2'">
                             <xsl:text>2.16.840.1.113883.10.20.22.1.3</xsl:text>
                         </xsl:when>
                         <xsl:otherwise>
                             <xsl:value-of select="@root"/>
                         </xsl:otherwise>
                     </xsl:choose>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="@*[name!='root']|node()" mode="CCDtoepSOS">
                <xsl:with-param name="path" select="concat($path, '/', name())"></xsl:with-param>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <!-- epSOS to CCDA -->
    <xsl:template match="@* | node()" mode="#all">
        <xsl:param name="path"/>
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="#current">
                <xsl:with-param name="path" select="concat($path, '/', name())"></xsl:with-param>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <!-- 
        7.1.1 Administrative Gender
        epSOS: /ClinicalDocument[templateId/@root="1.3.6.1.4.1.12559.11.10.1.3.1.1.3"]/recordTarget/patientRole/patient/administrativeGenderCode
        CCD:   /ClinicalDocument[templateId/@root="2.16.840.1.113883.10.20.22.1.2"]/recordTarget/patientRole/patient/administrativeGenderCode

        7.1.1.3 Value Sets
        epSOS AdministrativeGender                1.3.6.1.4.1.12559.11.10.1.3.1.42.34
        CCD Administrative Gender (HL7) Value Set 1.3.6.1.4.1.12559.11.10.1.3.1.42.34

        based on the HL7 AdministrativeGender code system (2.16.840.1.113883.5.1).
    -->
    <xsl:template match="administrativeGenderCode" mode="CCDtoepSOS">
        <xsl:param name="path"/>
        <xsl:choose>
            <xsl:when test="$path='/ClinicalDocument/recordTarget/patientRole/patient/administrativeGenderCode'">
                <recordTarget>
                    <patientRole>
                        <patient>
                            <administrativeGenderCode>
                                <xsl:call-template name="mapValueSet">
                                    <xsl:with-param name="from">1.3.6.1.4.1.12559.11.10.1.3.1.42.34</xsl:with-param>
                                    <xsl:with-param name="to">1.3.6.1.4.1.12559.11.10.1.3.1.42.34</xsl:with-param>
                                </xsl:call-template>
                            </administrativeGenderCode>
                        </patient>
                    </patientRole>
                </recordTarget>
            </xsl:when>
        </xsl:choose>

        <xsl:copy>
            <xsl:apply-templates select="@* | node()">
                <xsl:with-param name="path" select="concat($path,'/',name())"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
        
    
    <!-- 
        7.1.2.1 Patient Country of Living
        7.1.2.2 Guardian's Country
        epSOS:  
/ClinicalDocument/participant/associatedEntity/addr/country

CCD:  
no corresponding structure on the USA side. 

        epSOS: /ClinicalDocument[templateId/@root="1.3.6.1.4.1.19376.1.5.3.1.2.3"]/recordTarget/patientRole/addr/country
        CCD:   /ClinicalDocument[templateId/@root="2.16.840.1.113883.10.20.22.1.2"]/recordTarget/patientRole/addr/country
    -->
    <xsl:template match="country" mode="CCDtoepSOS">
        <xsl:param name="path"/>
        <xsl:choose>
            <xsl:when test="$path='/ClinicalDocument/recordTarget/patientRole/addr/'">
                <recordTarget>
                    <patientRole>
                        <addr>
                            <country>
                                <xsl:call-template name="mapValueSet">
                                    <xsl:with-param name="from">1.3.6.1.4.1.12559.11.10.1.3.1.42.34</xsl:with-param>
                                    <xsl:with-param name="to">1.3.6.1.4.1.12559.11.10.1.3.1.42.34</xsl:with-param>
                                </xsl:call-template>
                            </country>
                        </addr>
                    </patientRole>
                </recordTarget>
            </xsl:when>
        </xsl:choose>
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
   
</xsl:stylesheet>