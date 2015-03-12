<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tbx="http://trilliumbridge.org/xform"
    exclude-result-prefixes="xs tbx"
    version="2.0" xpath-default-namespace="http://trilliumbridge.org/xform" >
    <xsl:output method="xml" indent="yes"/>
    

    
    <xsl:template match="translations" xmlns="http://trilliumbridge.org/xform">
        <xsl:copy>
            <xsl:attribute name="fromlanguage" select="@tolanguage"/>
            <xsl:attribute name="tolanguage" select="@fromlanguage"/>
            <xsl:apply-templates select="@* except (@fromlanguage, @tolanguage)"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="source" xmlns="http://trilliumbridge.org/xform">
        <target>
            <xsl:apply-templates select="@* | node()"/>
        </target>
    </xsl:template>
    
    <xsl:template match="target" xmlns="http://trilliumbridge.org/xform">
        <source>
            <xsl:apply-templates select="@* | node()"/>
        </source>
    </xsl:template>

    
    <xsl:template match="@*|node()" xmlns="http://trilliumbridge.org/xform">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>