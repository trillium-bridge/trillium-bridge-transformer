<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tbx="http://trilliumbridge.org/xform"
    xmlns:bx="http://schemas.microsoft.com/2003/10/Serialization/"
    exclude-result-prefixes="xs tbx"
    version="2.0">
    <xsl:include href="TBParameters.xsl"/>
    
    <xsl:variable name="splitchunk" select="'(\P{L}*)(\p{L}[\p{L}\p{Zs}-]+\p{L}\p{P}?\P{N})(.*)'"/>
    
    <xsl:function name="tbx:trans" as="xs:string">
        <xsl:param name="translator"/>
        <xsl:param name="text"/>
        <xsl:value-of select="doc(concat($translator, '?text=', encode-for-uri($text)))/bx:string"/>
    </xsl:function>
    
    <xsl:function name="tbx:translateChunk">
        <xsl:param name="translator"/>
        <xsl:param name="chunk"/>
        <xsl:choose>
            <xsl:when test="matches($chunk, $splitchunk)">
                 <xsl:variable name="leading" select="replace($chunk, $splitchunk, '$1')"/>
                 <xsl:variable name="core" select="replace($chunk, $splitchunk, '$2')"/>
                 <xsl:variable name="trailing" select="replace($chunk, $splitchunk, '$3')"/>
                 <xsl:value-of select="concat($leading, tbx:trans($translator, $core), tbx:translateChunk($translator, $trailing))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$chunk"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    <xsl:function name="tbx:translate" as="xs:string">
        <xsl:param name="text" as="xs:string"/>
        <xsl:param name="fromlanguage" as="xs:string"/>
        <xsl:param name="tolanguage" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$usebing = 'true' and string-length(normalize-space($text))">
                <xsl:variable name="translator" select="concat($translationbase, '/from/', substring($fromlanguage, 1,2), '/to/', substring($tolanguage, 1, 2))"/>
                <xsl:value-of select="tbx:translateChunk($translator, $text)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>

        
    </xsl:function>
</xsl:stylesheet>