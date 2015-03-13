<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tbx="http://trilliumbridge.org/xform"
    xmlns:core="http://www.omg.org/spec/CTS2/1.1/Core"
    xmlns:codeSystem="http://schema.omg.org/spec/CTS2/1.0/CodeSystem"
    xmlns:mapVersion="http://www.omg.org/spec/CTS2/1.1/MapVersion" 
    xmlns:mapServices="http://www.omg.org/spec/CTS2/1.1/MapEntryServices" 
    exclude-result-prefixes="xs tbx core codeSystem mapVersion mapServices"
    version="2.0">
    
    <xsl:variable name="codesystems" as="element(codeSystem:CodeSystemCatalogEntryDirectory)">
        <xsl:copy-of select="document('http://rd.phast.fr/REST/sts_rest_beta_2/0004/codesystems')/codeSystem:CodeSystemCatalogEntryDirectory"/>
    </xsl:variable>
    
    
    <!-- Code system translator -->
    <xsl:function name="tbx:uriToEntityReference" as="element(tbx:conceptReference)">
        <xsl:param name="uri"/>
        
        <xsl:variable name="code" select="replace($uri, '.*/', '')"/>
        <xsl:variable name="codeSystemUri" select="replace($uri, '/.*','')"/>
        <xsl:variable name="codeSystemEntry"
            select="$codesystems//codeSystem:entry[@about=$codeSystemUri]"/>
        <tbx:conceptReference uri="{$uri}" xmlns="http://www.omg.org/spec/CTS2/1.1/Core">
            <core:namespace>
                <xsl:value-of select="$codeSystemEntry/@codeSystemName"/>
            </core:namespace>
            <core:name>
                <xsl:value-of select="$code"/>
            </core:name>
        </tbx:conceptReference>
    </xsl:function>
    
    
    <!-- Terminology access routines
        
        getMapEntry takes a code system and code and value set map entry, which provides the 
        name of the map to use in the transformation.
        
        The map entry provides -->
    
    <xsl:template name="getMapEntry">

        <xsl:param name="language" tunnel="yes"/>
        <xsl:param name="vsmapentry"/>
        <xsl:param name="code"/>
        <xsl:param name="codeSystem"/>
        <xsl:param name="displayName"/>

        <xsl:if test="not($code or $codeSystem)">
            <xsl:message terminate="yes" select="concat('Code(',$code,') (', $codeSystem, ')')"></xsl:message>
        </xsl:if>
        
        <xsl:variable name="target">
            <xsl:choose>
                <xsl:when test="$vsmapentry/tbx:uripattern">
                    <xsl:variable name="docroot">
                        <xsl:value-of select="replace(replace($vsmapentry/tbx:uripattern, '\{code\}', $code), '\{codeSystem\}', $codeSystem)"/>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="$vsmapentry/@entireMap='true'">
                            <xsl:copy-of
                                select="document($docroot)/mapVersion:MapEntryList/mapVersion:entry/mapVersion:entry[mapVersion:mapFrom/core:namespace=$codeSystem and mapVersion:mapFrom/core:name=$code]/mapVersion:mapSet/mapVersion:mapTarget/mapVersion:mapTo"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="document($docroot)/mapServices:MapTargetListMsg/mapServices:mapTargetList/mapServices:entry/mapVersion:mapTo"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$target/mapVersion:mapTo">
                <xsl:variable name="conceptReference" select="tbx:uriToEntityReference($target/mapVersion:mapTo/@uri)"/>
                <code codeSystem="{substring-after(substring-before($conceptReference/@uri,'/'), 'urn:oid:')}"
                    codeSystemName="{$conceptReference/core:namespace}" code="{$target/mapVersion:mapTo/core:name}"
                    displayName="{$target/mapVersion:mapTo/core:designation}" xmlns="urn:hl7-org:v3">
                    <translation>
                        <xsl:apply-templates select="@* | node()" mode="inside"/>
                    </translation>
                </code>
            </xsl:when>
            <xsl:otherwise>
                <code displayName="{$displayName}" nullFlavor="NI" xmlns="urn:hl7-org:v3">
                    <translation>
                        <xsl:apply-templates select="@* | node()" mode="inside"/>
                    </translation>
                </code>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template name="cr">
        <xsl:value-of select="'&#xa;'"/>
    </xsl:template>
    
</xsl:stylesheet>