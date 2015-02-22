<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/">
        <xsl:apply-templates>
            <xsl:with-param name="p1" tunnel="yes">P1</xsl:with-param>
            <xsl:with-param name="p2" tunnel="yes">P2</xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:call-template name="status">
            <xsl:with-param name="state">S1</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    
    <xsl:template name="status">
        <xsl:param name="state" required="yes"/>
        <xsl:param name="p1" tunnel="yes"/>
        <xsl:param name="p2">NOTUNNEL</xsl:param>
        <xsl:value-of select="concat($state,': ',$p1,', ',$p2)"/>
        <xsl:call-template name="status2">
            <xsl:with-param name="state">S2</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="status2">
        <xsl:param name="state" required="yes"/>
        <xsl:param name="p1" tunnel="yes"/>
        <xsl:param name="p2" tunnel="yes">NOTUNNEL</xsl:param>
        <xsl:value-of select="concat($state,': ',$p1,', ',$p2)"/>
    </xsl:template>
    
</xsl:stylesheet>