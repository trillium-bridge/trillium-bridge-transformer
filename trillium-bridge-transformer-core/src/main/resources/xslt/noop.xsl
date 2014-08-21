<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:v3="urn:hl7-org:v3"
    version="1.0">

    <xsl:param name="martha_ccda" select="document('../nooptransform/ccda/RTD_CCD_Martha.xml')"/>
    <xsl:param name="martha_epsos" select="document('../nooptransform/epsos/RTD_CCD_Martha_as_PS.xml')"/>
    <xsl:param name="paolo_ccda" select="document('../nooptransform/ccda/RTD_PS_Paolo_IT_as_CCD.xml')"/>
    <xsl:param name="paolo_epsos" select="document('../nooptransform/epsos/RTD_PS_Paolo_IT_L3_v2.xml')"/>

    <xsl:template match="/v3:ClinicalDocument[v3:id[@root='2.16.840.1.113883.19.5.99999.1' and @extension='TT988']]">
        <xsl:copy-of select="$martha_epsos"/>
    </xsl:template>

    <xsl:template match="/v3:ClinicalDocument[v3:id[@root='2.16.840.1.113883.19.5.99999.1' and @extension='TT9881.epSOS']]">
        <xsl:copy-of select="$martha_ccda"/>
    </xsl:template>

    <xsl:template match="/v3:ClinicalDocument[v3:id[@root='2.16.840.1.113883.19.5.99999.1' and @extension='TB1.1.1']]">
        <xsl:copy-of select="$paolo_epsos"/>
    </xsl:template>

    <xsl:template match="/v3:ClinicalDocument[v3:id[@root='2.16.840.1.113883.19.5.99999.1' and @extension='TB1']]">
        <xsl:copy-of select="$paolo_ccda"/>
    </xsl:template>

    <xsl:template match="/v3:ClinicalDocument" priority="-1">
        <xsl:comment>WARNING!!!! This was a No-Op Transformation</xsl:comment>
        <xsl:copy-of select="."/>
        <xsl:comment>WARNING!!!! This was a No-Op Transformation</xsl:comment>
    </xsl:template>

</xsl:stylesheet>