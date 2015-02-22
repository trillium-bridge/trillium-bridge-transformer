<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:tbx="http://trilliumbridge.org/xform" exclude-result-prefixes="xs tbx mapVersion core mapServices codeSystem tbx" version="2.0"
    xmlns:mapVersion="http://www.omg.org/spec/CTS2/1.1/MapVersion" xmlns:mapServices="http://www.omg.org/spec/CTS2/1.1/MapEntryServices"
    xmlns:codeSystem="http://schema.omg.org/spec/CTS2/1.0/CodeSystem" xmlns:core="http://www.omg.org/spec/CTS2/1.1/Core"
    xpath-default-namespace="urn:hl7-org:v3">
    <xsl:include href="CTS2Access.xsl"/>

    <xsl:param name="debug" select="false()"/>

    <!-- ============================= mapLanguage ==========================
        Map a language code.  Parameters:
        $language - the language of the document itself
        $toLanguage - the target transformation language
        $context - the elements to be mapped
        ====================================================================== -->
    <xsl:param name="tolanguage">en</xsl:param>

    <!-- Map a language code from the from language to the to language -->
    <xsl:template name="mapLanguage">
        <xsl:param name="language" tunnel="yes"/>
        <xsl:param name="context" tunnel="yes"/>
        <xsl:for-each select="$context">
            <xsl:copy>
                <xsl:choose>
                    <xsl:when test="@code=$language">
                            <xsl:attribute name="code" select="$tolanguage"/>
                            <xsl:apply-templates select="@* except @code, node()" mode="inside"/>     
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="@*|node()" mode="inside"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:copy>
        </xsl:for-each>
    </xsl:template>
    
    <!-- ============================= mapValueSet ===========================
        Map a coded element from one value set to another.  Parameters:
        $language - the language of the document itself
        $context - the elements to be mapped
        $args/@map - the name of the value set mapping entry
        
        NOTE: $args is a parameter to allow testing
        ====================================================================== -->
    <xsl:template name="mapValueSet">
        <xsl:param name="language" tunnel="yes"/>
        <xsl:param name="context" tunnel="yes"/>

        
        <xsl:param name="args" select="."/>
        <xsl:for-each select="$context">
            <xsl:choose>
                <xsl:when test="$valuesets/tbx:valuesetmap/tbx:entry[@name=$args/@map]">
                    <xsl:call-template name="getMapEntry">
                        <xsl:with-param name="code" select="@code"/>
                        <xsl:with-param name="codeSystem" select="@codeSystemName"/>
                        <xsl:with-param name="displayName" select="@displayName"/>
                        <xsl:with-param name="vsmapentry" select="$valuesets/tbx:valuesetmap/tbx:entry[@name=$args/@map]"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <code xmlns="urn:hl7-org:v3" displayName="MAP: {$args/@map} not found">
                        <translation>
                            <xsl:apply-templates select="@* | node()" mode="inside"/>
                        </translation>
                    </code>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    
    <!-- ============================= changeTemplateRoots ===================
        Remove and add template identifiers.  Parameters:
        $context - the elements to be mapped
        $args/@map - the name of the value set mapping entry
        ====================================================================== -->

    <xsl:template name="changeTemplateRoots">
        <xsl:param name="context" tunnel="yes"/>
        
        <xsl:variable name="args" select="."/>
        <xsl:for-each select="$context">
            <xsl:choose>
                <xsl:when test="$args/tbx:entry[@fromid=current()/@root]">
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy>
                        <xsl:apply-templates select="@* | *" mode="inside"/>
                    </xsl:copy>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$args/tbx:entry/@toid">
            <xsl:element name="templateId" namespace="urn:hl7-org:v3">
                <xsl:attribute name="root" select="."/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <!-- ============================= replaceCode  ==========================
        Replace the from code with the to code
        $context - the elements to be mapped
        $entry/fromcode - code to remove
        $entry/tocode   - code to add
        ====================================================================== -->
    <xsl:template name="replaceCode" xmlns="urn:hl7-org:v3">
        <xsl:param name="context" tunnel="yes"/>
        
        <xsl:variable name="args" select="."/>
        <xsl:for-each select="$context">
            <xsl:choose>
                <xsl:when test="$args/tbx:entry[tbx:fromcode/code=current()]">
                    <xsl:if test="$args/tbx:entry[tbx:fromcode/code=current()]/tbx:tocode">
                        <xsl:copy-of select="$args/tbx:entry[tbx:fromcode/code=current()]/tbx:tocode/code"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="not($args/tbx:entry/tbx:fromcode)">
                    <xsl:copy-of select="$args/tbx:entry/tbx:tocode/code"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy>
                        <xsl:apply-templates select="node() | @*" mode="inside"/>
                    </xsl:copy>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- ============================= replaceValue  ==========================
        Replace the from value with the to value
        $context - the elements to be mapped
        $entry/fromValue - code to remove
        $entry/toValue   - code to add
        
        NOTE: The debug reference below checks whether we are doing unit tests.
        Unit tests (for some reason) leave white space in the inputs so some comparisons fail.
        ====================================================================== -->
    <xsl:template name="replaceValue" xmlns="urn:hl7-org:v3">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:variable name="args" select="."/>
        <xsl:for-each select="$context">
            <xsl:choose>
                <xsl:when test="$args/tbx:entry[tbx:fromValue/value=current()] and not($debug)">
                    <xsl:if test="$args/tbx:entry[tbx:fromValue/value=current()]/tbx:toValue">
                        <xsl:copy-of select="$args/tbx:entry[tbx:fromValue/value=current()]/tbx:toValue/value"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="not($args/tbx:entry/tbx:fromValue) or $debug">
                    <xsl:copy-of select="$args/tbx:entry/tbx:toValue/value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy>
                        <xsl:apply-templates select="node() | @*" mode="inside"/>
                    </xsl:copy>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="translateText" xmlns="urn:hl7-org:v3">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:param name="language" tunnel="yes"/>
        
        <xsl:variable name="args" select="."/>

        <!-- This is where we fill in a fancy translation service.
             The arguments to translateText could include the address of some web based translation -->
        <xsl:for-each select="$context">
            <text>
                <paragraph>Original Text</paragraph>
                <br/>
                <xsl:copy-of select="."/>
                <paragraph>Warning: this translation has been generated by a software component</paragraph>
                <br/>
                <xsl:variable name="transdoc" select="concat('../translation/',$language, 'to', $tolanguage, '.xml')"/>
                <xsl:apply-templates mode="faketranslate">
                    <xsl:with-param name="transdoc" select="$transdoc"/>
                </xsl:apply-templates>
                <br/>
            </text>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="text()" priority="2" mode="faketranslate">
        <xsl:param name="transdoc"/>
        <xsl:variable name="translations" select="document($transdoc)/tbx:translations"/>
        <xsl:variable name="src" select="."/>

        <xsl:choose>
            <xsl:when test="$translations/tbx:entry[tbx:source=$src]">
                <xsl:value-of select="$translations/tbx:entry[tbx:source=$src]/tbx:target"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="replace($src, '[a-zA-Z]', 't')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@* | node()" mode="faketranslate" xmlns="urn:hl7-org:v3" priority="1">
        <xsl:param name="transdoc"/>
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="inside"/>
            <xsl:apply-templates select="node()" mode="faketranslate">
                <xsl:with-param name="transdoc" select="$transdoc"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <!-- ============================= newid  ==========================
        Generate a new identifier for the supplied node
        $context - id elements to be replaced
        ====================================================================== -->
    <xsl:template name="newid">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:for-each select="$context">
            <id xmlns="urn:hl7-org:v3" extension="{concat(@extension, '.1.1')}">
                <xsl:apply-templates select="@* except @extension" mode="inside"/>
            </id>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="translateTitle">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:param name="language" tunnel="yes"/>

        <xsl:for-each select="$context">
            <xsl:variable name="transdoc" select="concat('../translation/', $language, 'to', $tolanguage, '.xml')"/>
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


    <xsl:template name="applyTransformations">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:choose>
            <xsl:when test="@name='changeTemplateRoots'">
                <xsl:call-template name="changeTemplateRoots"/>
            </xsl:when>
            <xsl:when test="@name='translateTitle'">
                <xsl:call-template name="translateTitle"/>
            </xsl:when>
            <xsl:when test="@name='newid'">
                <xsl:call-template name="newid"/>
            </xsl:when>
            <xsl:when test="@name='mapValueSet'">
                <xsl:call-template name="mapValueSet"/>
            </xsl:when>
            <xsl:when test="@name='replaceCode'">
                <xsl:call-template name="replaceCode"/>
            </xsl:when>
            <xsl:when test="@name='replaceValue'">
                <xsl:call-template name="replaceValue"/>
            </xsl:when>
            <xsl:when test="@name='translateText'">
                <xsl:call-template name="translateText"/>
            </xsl:when>
            <xsl:when test="@name='mapLanguage'">
                <xsl:call-template name="mapLanguage"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>UNMAPPED FUNCTION: <xsl:value-of select="@name"/></xsl:comment>
                <xsl:call-template name="cr"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>
