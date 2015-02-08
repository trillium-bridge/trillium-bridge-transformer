<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:v3="urn:hl7-org:v3"
    xmlns:tbx="http://trilliumbridge.org/xform" exclude-result-prefixes="xs v3 tbx mapVersion core" version="2.0"
    xmlns:mapVersion="http://www.omg.org/spec/CTS2/1.1/MapVersion"
    xmlns:core="http://www.omg.org/spec/CTS2/1.1/Core" xpath-default-namespace="urn:hl7-org:v3">


    <xsl:variable name="maps">
        <xsl:copy-of select="doc('FP7-SA610756-D3.1.xml')"/>
    </xsl:variable>

    <xsl:variable name="valuesets">
        <xsl:copy-of select="doc('ValueSetMaps.xml')"/>
    </xsl:variable>

    <xsl:param name="from">epSOS</xsl:param>
    <xsl:param name="to">CCD</xsl:param>
    <xsl:param name="tolanguage">en</xsl:param>

    <xsl:template name="getMapEntry">
        <xsl:param name="path"/>
        <xsl:param name="language"/>
        
        <xsl:param name="vsmapentry"/>
        <xsl:param name="code"/>
        <xsl:param name="codeSystem"/>

        
        <xsl:variable name="target"
                select="document($vsmapentry/tbx:base)/mapVersion:MapEntryList/mapVersion:entry/mapVersion:entry[mapVersion:mapFrom/core:namespace=$codeSystem and mapVersion:mapFrom/core:name=$code]/mapVersion:mapSet/mapVersion:mapTarget/mapVersion:mapTo"/>

        <code codeSystem="2.16.840.1.113883.6.1" codeSystemName="{$target/core:namespace}" code="{$target/core:name}"
            displayName="{$target/core:designation}" xmlns="urn:hl7-org:v3">
            <translation>
                <xsl:apply-templates select="@* | node()">
                    <xsl:with-param name="path" select="$path"/>
                    <xsl:with-param name="language" select="$language"/>
                </xsl:apply-templates>
            </translation>
        </code>
    </xsl:template>

    <xsl:template name="mapValueSet">
        <xsl:param name="path"/>
        <xsl:param name="language"/>
        <xsl:param name="context"/>
        <xsl:param name="args" select="current()"/>
        <xsl:for-each select="$context">
            <xsl:choose>
                <xsl:when test="$valuesets/tbx:valuesetmap/tbx:entry[@name=$args/@map]">
                    <xsl:call-template name="getMapEntry">
                        <xsl:with-param name="path" select="$path"/>
                        <xsl:with-param name="language" select="$language"/>
                        <xsl:with-param name="code" select="@code"/>
                        <xsl:with-param name="codeSystem" select="@codeSystemName"/>
                        <xsl:with-param name="vsmapentry" select="$valuesets/tbx:valuesetmap/tbx:entry[@name=$args/@map]"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <code xmlns="urn:hl7-org.v3" displayName="MAP: {$args/@map} not found">
                        <translation>
                            <xsl:apply-templates select="@* | node()">
                                <xsl:with-param name="path" select="$path"/>
                                <xsl:with-param name="language" select="$language"/>
                            </xsl:apply-templates>
                        </translation>
                    </code>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="changeTemplateRoots">
        <xsl:param name="path"/>
        <xsl:param name="language"/>
        <xsl:param name="context"/>
        <xsl:param name="args" select="current()"/>
        <xsl:for-each select="$context">
            <xsl:choose>
                <xsl:when test="$args/tbx:entry[@fromid=current()/@root]">
                    <xsl:if test="$args/tbx:entry[@fromid=current()/@root]/@toid">
                    <templateId root="{$args/tbx:entry[@fromid=current()/@root]/@toid}"
                        xmlns="urn:hl7-org:v3"/>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy>
                        <xsl:apply-templates select="@*"/>
                    </xsl:copy>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="replaceCode" xmlns="urn:hl7-org:v3">
        <xsl:param name="path"/>
        <xsl:param name="language"/>
        <xsl:param name="context"/>
        <xsl:param name="args" select="current()"/>
       
        <xsl:for-each select="$context">
            <xsl:choose>
                <xsl:when test="$args/tbx:entry[tbx:fromcode/tbx:code=current()]">
                    <xsl:if test="$args/tbx:entry[tbx:fromcode/tbx:code=current()]/tbx:tocode">
                        <xsl:copy-of select="$args/tbx:entry[tbx:fromcode/tbx:code=current()]/tbx:tocode/tbx:code"/>  
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy>
                        <xsl:apply-templates select="node() | @*">
                            <xsl:with-param name="path" select="$path"/>
                            <xsl:with-param name="language" select="$language"/>
                        </xsl:apply-templates>
                    </xsl:copy>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="newid">
        <xsl:param name="path"/>
        <xsl:param name="language"/>
        <xsl:param name="context"/>
        <xsl:for-each select="$context">
            <id xmlns="urn:hl7-org:v3" extension="{concat(@extension, '.1.1')}">
                <xsl:apply-templates select="@*[name() !='extension']"/>
            </id>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="translateTitle">
        <xsl:param name="path"/>
        <xsl:param name="language"/>
        <xsl:param name="context"/>

        <xsl:for-each select="$context">
            <xsl:variable name="transdoc" select="concat('../translation/',$language, 'to', $tolanguage, '.xml')"/>
            <xsl:variable name="translations" select="document($transdoc)/tbx:translations"/>
            <xsl:variable name="src" select="."/>
            <xsl:choose>
             <xsl:when test="$translations/tbx:entry[tbx:source=$src]">
                 <title xmlns="urn:hl7-org:v3">
                    <xsl:value-of select="$translations/tbx:entry[tbx:source=$src]/tbx:target"/>
                 </title>
             </xsl:when>
             <xsl:otherwise>
                 <xsl:copy-of select="."/>
             </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:copy/>
    </xsl:template>

    <xsl:template match="//ClinicalDocument">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()">
                <xsl:with-param name="path" select="'/ClinicalDocument'"/>
                <xsl:with-param name="language" select="languageCode/@code"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="node()" xmlns="urn:hl7-org:v3">
        <xsl:param name="path"/>
        <xsl:param name="language"/>
        
        <xsl:variable name="loc" select="concat($path, '/', name())"/>
        <xsl:variable name="context" select="current()"/>

        <xsl:choose>
            <xsl:when test="$maps/tbx:map/tbx:entry[@from=$from and @to=$to and tbx:frompath=$loc]">
                <xsl:for-each
                    select="$maps/tbx:map/tbx:entry[@from=$from and @to=$to and tbx:frompath=$loc]/tbx:transformation">
                    <xsl:choose>
                        <xsl:when test="@name='changeTemplateRoots'">
                            <xsl:call-template name="changeTemplateRoots">
                                <xsl:with-param name="path" select="$loc"/>
                                <xsl:with-param name="language" select="$language"/>
                                <xsl:with-param name="context" select="$context"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="@name='translateTitle'">
                            <xsl:call-template name="translateTitle">
                                <xsl:with-param name="path" select="$loc"/>
                                <xsl:with-param name="language" select="$language"/>
                                <xsl:with-param name="context" select="$context"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="@name='newid'">
                            <xsl:call-template name="newid">
                                <xsl:with-param name="path" select="$loc"/>
                                <xsl:with-param name="language" select="$language"/>
                                <xsl:with-param name="context" select="$context"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="@name='mapValueSet'">
                            <xsl:call-template name="mapValueSet">
                                <xsl:with-param name="path" select="$loc"/>
                                <xsl:with-param name="language" select="$language"/>
                                <xsl:with-param name="context" select="$context"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="@name='replaceCode'">
                            <xsl:call-template name="replaceCode">
                                <xsl:with-param name="path" select="$loc"/>
                                <xsl:with-param name="language" select="$language"/>
                                <xsl:with-param name="context" select="$context"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:comment>UNMAPPED FUNCTION: <xsl:value-of select="@name"/></xsl:comment>
                            <xsl:call-template name="cr"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="name()='languageCode'">
                <languageCode code="{$tolanguage}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()">
                        <xsl:with-param name="path" select="$loc"/>
                        <xsl:with-param name="language" select="$language"/>
                    </xsl:apply-templates>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="cr">
        <xsl:value-of select="'&#xa;'"/>
    </xsl:template>


</xsl:stylesheet>
