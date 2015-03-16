<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tbx="http://trilliumbridge.org/xform"
    exclude-result-prefixes="xs v3 mapVersion core mapServices codeSystem tbx" version="2.0" xmlns:mapVersion="http://www.omg.org/spec/CTS2/1.1/MapVersion"
    xmlns:mapServices="http://www.omg.org/spec/CTS2/1.1/MapEntryServices" xmlns:codeSystem="http://schema.omg.org/spec/CTS2/1.0/CodeSystem"
    xmlns:core="http://www.omg.org/spec/CTS2/1.1/Core" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xpath-default-namespace="urn:hl7-org:v3"
    xmlns:v3="urn:hl7-org:v3">
    <xsl:include href="CTS2Access.xsl"/>
    <xsl:include href="TBTranslator.xsl"/>

    <!-- If true, we are being invoked in a XSPEC scenario -->
    <xsl:param name="debug" select="false()"/>

    <xsl:variable name="valuesets" as="element(tbx:valuesetmap)">
        <xsl:copy-of select="document('../tbxform/ValueSetMaps.xml')/tbx:valuesetmap"/>
    </xsl:variable>


    <!-- ============================= mapLanguage ==========================
        Map a language code.  Parameters:
        $language - the language of the document itself
        $toLanguage - the target transformation language
        $context - the elements to be mapped
        ====================================================================== -->
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
        
        NOTE: $args is a parameter to allow testing.  It is a variable in a runtime environment.
        ====================================================================== -->
    <xsl:template name="mapValueSet">
        <xsl:param name="language" tunnel="yes"/>
        <xsl:param name="context" tunnel="yes"/>

        <xsl:param name="args" select="."/>
        <xsl:for-each select="$context">
            <xsl:choose>
                <xsl:when test="$valuesets/tbx:entry[@name=$args/@map]">
                    <xsl:call-template name="getMapEntry">
                        <xsl:with-param name="code" select="@code"/>
                        <xsl:with-param name="codeSystem" select="@codeSystemName"/>
                        <xsl:with-param name="displayName" select="@displayName"/>
                        <xsl:with-param name="vsmapentry" select="$valuesets/tbx:entry[@name=$args/@map]"/>
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
        $args/@fromid - a template identifier to remove
        $args/@toid - a template identifier to add
        ====================================================================== -->
    <xsl:template name="changeTemplateRoots">
        <xsl:param name="context" tunnel="yes"/>

        <xsl:variable name="args" select="."/>
        <xsl:for-each select="$context">
            <xsl:choose>
                <xsl:when test="$args/tbx:arg[@fromid=current()/@root]"> </xsl:when>
                <xsl:otherwise>
                    <xsl:copy>
                        <xsl:apply-templates select="@* | *" mode="inside"/>
                    </xsl:copy>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:if test="$context/../*[name()=$context/name()][position()=last()] is $context">
            <xsl:for-each select="$args/tbx:arg/@toid">
                <xsl:element name="templateId" namespace="urn:hl7-org:v3">
                    <xsl:attribute name="root" select="."/>
                </xsl:element>
            </xsl:for-each>
        </xsl:if>
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
                <xsl:when test="$args/tbx:arg[tbx:fromcode/code=current()]">
                    <xsl:if test="$args/tbx:arg[tbx:fromcode/code=current()]/tbx:tocode">
                        <xsl:copy-of select="$args/tbx:arg[tbx:fromcode/code=current()]/tbx:tocode/code"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="not($args/tbx:arg/tbx:fromcode)">
                    <xsl:copy-of select="$args/tbx:arg/tbx:tocode/code"/>
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
                <xsl:when test="$args/tbx:arg[tbx:fromValue/value=current()] and not($debug)">
                    <xsl:if test="$args/tbx:arg[tbx:fromValue/value=current()]/tbx:toValue">
                        <xsl:copy-of select="$args/tbx:arg[tbx:fromValue/value=current()]/tbx:toValue/value"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="not($args/tbx:arg/tbx:fromValue) or $debug">
                    <xsl:copy-of select="$args/tbx:arg/tbx:toValue/value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy>
                        <xsl:apply-templates select="node() | @*" mode="inside"/>
                    </xsl:copy>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>


    <!-- ============================= addNode  ==========================
        Add the supplied node in at the current context
        $context - the elements to be mapped
        @outside - if present, the nodes are added before (outside) the path.  If absent
                   the nodes are added inside
        @ifnot   - if present the node is only added if the templateId as the ifnot value is not
                   already present in the resource.  (Used for adding default nodes).  @ifnot
                   is ignored if the addDefaults parameter is false
        $arg/@before=true - block to add before content
        $arg/@after=true - block to add after content
        ====================================================================== -->
    <xsl:template name="addNode" xmlns="urn:hl7-org:v3">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:param name="args" select="." as="element()"/>
        <xsl:param name="xformnumber" as="xs:integer" tunnel="yes"/>

        <xsl:variable name="last" select="$context/../*[position()=last()] is $context" as="xs:boolean"/>
        <xsl:variable name="doInsert" as="xs:boolean">
            <xsl:value-of select="boolean(not(@ifnot) or ($addDefaults='true' and not($context//templateId[@root=$args/@ifnot])))"/>
        </xsl:variable>

        <xsl:if test="$args/@outside and $doInsert">
            <xsl:for-each select="$args/tbx:arg[@before]/*">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" mode="substitute"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:if>

        <xsl:for-each select="$context">
            <xsl:if test="$xformnumber = 1">
                <xsl:copy>
                    <xsl:if test="$doInsert">
                        <xsl:for-each select="$args[not(@outside)]/tbx:arg[@before]">
                            <xsl:copy-of select="*"/>
                        </xsl:for-each>
                    </xsl:if>

                    <xsl:apply-templates select="@* | node()" mode="inside"/>

                    <xsl:if test="$doInsert">
                        <xsl:for-each select="$args[not(@outside)]/tbx:arg[@after]">
                            <xsl:copy-of select="*"/>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:copy>
            </xsl:if>
        </xsl:for-each>

        <xsl:if test="exists($args/@outside) and $last and $doInsert">
            <xsl:for-each select="$args/tbx:arg[@after]/*">
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()" mode="substitute"/>
                </xsl:copy>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <!-- addNode with attribute value substitution -->
    <xsl:template match="@*" mode="substitute">
        <xsl:param name="id" tunnel="yes"/>
        <xsl:attribute name="{name()}"
            select="replace(replace(., '\{id/@extension\}', if($id) then ($id/@extension) else 'NONE'), '\{id/@root\}', if($id) then ($id/@root) else 'NONE')"/>
    </xsl:template>

    <!-- addNode with text value substitution -->
    <xsl:template match="text()" mode="substitute">
        <xsl:param name="id" tunnel="yes"/>
        <xsl:value-of select="replace(., '\{id\}', if($id) then $id/@extension else 'NONE')"/>
    </xsl:template>

    <!-- addNode recursive element copy -->
    <xsl:template match="*" mode="substitute">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="substitute"/>
        </xsl:copy>
    </xsl:template>

    <!-- ============================= replaceNode  ==========================
        Replace the from node with the to node
        $context - the elements to be mapped
        $arg/frompath - node to remove
        $arg/frompath/@insert - add 
        $arg/topath   - node to add.
        ====================================================================== -->
    <xsl:template name="replaceNode" xmlns="urn:hl7-org:v3">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:variable name="args" select="."/>
        <xsl:for-each select="$context">
            <!-- If we are adding content, copy the original -->
            <xsl:if test="boolean($args/tbx:arg/@add)">
                <xsl:copy-of select="."/>
            </xsl:if>
            <xsl:choose>
                <xsl:when
                    test="(not(boolean($args/tbx:arg/@add) or boolean($args/tbx:arg/@insert)) and $args/tbx:arg[tbx:fromValue/.=current()]) and not($debug)">
                    <xsl:if test="$args/tbx:arg[tbx:fromValue/.=current()]/tbx:toValue">
                        <xsl:copy-of select="$args/tbx:arg[tbx:fromValue/.=current()]/tbx:toValue/*"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="((boolean($args/tbx:arg/@add) or boolean($args/tbx:arg/@insert)) and not($args/tbx:arg/tbx:fromValue)) or $debug">
                    <xsl:copy-of select="$args/tbx:arg/tbx:toValue/*"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy>
                        <xsl:apply-templates select="node() | @*" mode="inside"/>
                    </xsl:copy>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="boolean($args/tbx:arg/@insert)">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- ============================= translateText  ==========================
        Translate a text node
        $context - the elements to be mapped
        $language - the source language of the translation
        ====================================================================== -->
    <xsl:template name="translateText" xmlns="urn:hl7-org:v3">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:param name="language" tunnel="yes"/>

        <xsl:variable name="args" select="."/>

        <xsl:choose>
            <xsl:when test="substring($language, 1, 2) != substring($tolanguage, 1, 2)">
                <xsl:for-each select="$context">
                    <text>
                        <paragraph>Original Text</paragraph>
                        <br/>
                        <xsl:copy-of select="."/>
                        <paragraph>Warning: this translation has been generated by a software component</paragraph>
                        <br/>
                        <xsl:variable name="transdoc" select="concat('../translation/', substring($language, 1, 2), 'to', substring($tolanguage, 1, 2), '.xml')"/>
                        <xsl:variable name="translations" select="if(doc-available($transdoc)) then document($transdoc)/tbx:translations else ''"/>
                        <xsl:apply-templates mode="translatetext">
                            <xsl:with-param name="translations" select="$translations" tunnel="yes"/>
                        </xsl:apply-templates>
                        <br/>
                    </text>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <!-- Don't translate if the to and from language are the same -->
                <xsl:copy-of select="$context"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="text()" priority="2" mode="translatetext">
        <xsl:param name="translations" tunnel="yes"/>
        <xsl:param name="language" tunnel="yes"/>

        <xsl:variable name="src" select="normalize-space(.)"/>
        <xsl:choose>
            <xsl:when test="$translations and $translations/tbx:entry[tbx:source=$src]">
                <xsl:value-of select="$translations/tbx:entry[tbx:source=$src]/tbx:target"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="tbx:translate(., $language, $tolanguage)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="node()" mode="translatetext" xmlns="urn:hl7-org:v3" priority="1">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="inside"/>
            <xsl:apply-templates select="node()" mode="translatetext"/>
        </xsl:copy>
    </xsl:template>

    <!-- ============================= newid  ================================
        Generate a new identifier for the supplied node by concatenating ".1" 
        on to the extension identifier.  Parameters:
        $context - id elements to be replaced
        ====================================================================== -->
    <xsl:template name="newid">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:for-each select="$context">
            <id xmlns="urn:hl7-org:v3" extension="{if (@extension) then concat(@extension, '.1') else '1'}">
                <xsl:apply-templates select="@* except @extension" mode="inside"/>
            </id>
        </xsl:for-each>
    </xsl:template>

    <!-- ============================= translateTitle  ================================
        Translate a title node.  First try the translation document and, if unavailable 
        and the text translator is available, give it a try. Parameters
        $context - id elements to be replaced
        $language - from language
        ====================================================================== -->
    <xsl:template name="translateTitle">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:param name="language" tunnel="yes"/>

        <xsl:for-each select="$context">
            <xsl:variable name="transdoc" select="concat('../translation/', substring($language, 1, 2), 'to', substring($tolanguage, 1, 2), '.xml')"/>
            <xsl:variable name="translations" select="if(doc-available($transdoc)) then document($transdoc)/tbx:translations else ''"/>
            <xsl:variable name="src" select="."/>
            <xsl:choose>
                <xsl:when test="$translations and $translations/tbx:entry[tbx:source=$src]">
                    <title xmlns="urn:hl7-org:v3">
                        <xsl:value-of select="$translations/tbx:entry[tbx:source=$src]/tbx:target"/>
                    </title>
                </xsl:when>
                <xsl:when test="$usebing">
                    <title xmlns="urn:hl7-org:v3">
                        <xsl:value-of select="tbx:translate($src, $language, $tolanguage)"/>
                    </title>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- ============================= mapValueSetAndMove  ===================
        Map the code referenced by the arg/source parameter and create a code at 
        the current reference point.  The context for the transformation is the parent node of the 
        item to be replaced.  As an example:
        
        <transform>
            <path>/manufacturedMaterial/code</path>
            <transformation name="mapValueSetAndMove" map="ATC_RxNorm_epSOSActiveIngredient_VS">
               <arg>
                 <source>/manufacturedMaterial/epsos:ingredient[@classCode="ACTI"]/epsos:ingredient[@classCode="MMAT"]/epsos:code</source>
               </arg>
            </transformation>
        </transform>
           
        Applies a mapValueSet transformation to "/manufacturedMaterial/epsos:ingredient..." and places the result *after* the /manufacturedMaterial/code.
        
        $context - point to insert the map
        $args/arg/source - path to element to be mapped.
        ====================================================================== -->
    <xsl:template name="mapValueSetAndMove">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:variable name="args" select="."/>

        <xsl:variable name="innercontext" as="element()">
            <context xmlns="http://trilliumbridge.org/xform">
                <root>/</root>
                <transform>
                    <documentation>Embedded context for mapValueSetAndMove</documentation>
                    <path>
                        <xsl:value-of select="$args/tbx:arg/tbx:source"/>
                    </path>
                    <transformation name="mapValueSet" map="{$args/@map}"/>
                </transform>
            </context>
        </xsl:variable>

        <xsl:apply-templates select="$context/.." mode="inside">
            <xsl:with-param name="relbase" select="''" tunnel="yes"/>
            <xsl:with-param name="mapcontext" select="$innercontext" tunnel="yes"/>
            <xsl:with-param name="matchonly" select="true()" tunnel="yes" as="xs:boolean"/>
        </xsl:apply-templates>

    </xsl:template>

    <!-- ============================= mapValueSetAndAdd  ===================
        Map the value set referenced by the current context into the "code" node in the node to add

        ====================================================================== -->
    <xsl:template name="mapValueSetAndAdd">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:variable name="args" select="."/>

        <xsl:variable name="mappedCode" as="element()">
            <xsl:call-template name="mapValueSet"/>
        </xsl:variable>

        <xsl:call-template name="addNode">
            <xsl:with-param name="args" as="element()">
                <transformation xmlns="http://trilliumbridge.org/xform">
                    <xsl:apply-templates select="$args/@*" mode="replaceCode"/>
                    <arg>
                        <xsl:apply-templates select="$args/tbx:arg[@name='target']/@*" mode="replaceCode"/>
                        <xsl:apply-templates select="$args/tbx:arg[@name='target']/*" mode="replaceCode">
                            <xsl:with-param name="replacement" select="$mappedCode" tunnel="yes"/>
                        </xsl:apply-templates>
                    </arg>
                </transformation>
            </xsl:with-param>
        </xsl:call-template>

    </xsl:template>

    <xsl:template match="*" mode="replaceCode">
        <xsl:param name="replacement" as="element()" tunnel="yes"/>

        <xsl:copy>
            <xsl:choose>
                <xsl:when test="local-name()='code'">
                    <xsl:copy-of select="$replacement/@*"/>
                    <xsl:copy-of select="$replacement/node()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="@* | node()" mode="replaceCode"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" mode="replaceCode">
        <xsl:copy-of select="."/>
    </xsl:template>

    <!-- ============= adjustEffectiveTime ===================
        Tweak effectivetime to have a low value
        ====================================================== -->
    <xsl:template name="adjustEffectiveTime">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:for-each select="$context">
            <effectiveTime xmlns="urn:hl7-org:v3">
                <xsl:apply-templates select="@* except @value" mode="inside"/>
                <xsl:choose>
                    <xsl:when test="low">
                        <xsl:copy-of select="low"/>
                    </xsl:when>
                    <xsl:when test="@value">
                        <low value="{@value}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <low nullFlavor="NA"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="high">
                        <xsl:copy-of select="high"/>
                    </xsl:when>
                    <xsl:when test="@xsi:type='IVL_TS'">
                        <xsl:choose>
                            <xsl:when test="@value">
                                <high value="{@value}"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <high nullFlavor="NA"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <high value="{if(@value) then @value else low/@value}"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:apply-templates select="node() except (low, high)" mode="inside"/>
            </effectiveTime>
        </xsl:for-each>
    </xsl:template>

    <!-- ============= changeAttribute ===================
        Change an attribute value
        ====================================================== -->
    <xsl:template name="changeAttribute">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:variable name="args" select="."/>
        <xsl:for-each select="$context">
            <xsl:copy>
                <xsl:apply-templates select="@*[not(name()= $args/@attribute)]" mode="inside"/>
                <xsl:attribute name="{$args/@attribute}" select="$args/tbx:arg"/>
                <xsl:apply-templates select="node() except low" mode="inside"/>
            </xsl:copy>
        </xsl:for-each>
    </xsl:template>


    <!-- ============= adjustDoseQuantity ===================
        Change doseQuantity from a single entry to a nested entry
        ====================================================== -->
    <xsl:template name="adjustDoseQuantity">
        <xsl:param name="context" tunnel="yes"/>
        <xsl:variable name="args" select="."/>
        <xsl:for-each select="$context">
            <doseQuantity xmlns="urn:hl7-org:v3">
                <xsl:apply-templates select="@* except (@value, @unit)" mode="inside"/>
                <low value="{@value}" unit="{@unit}"/>
                <high value="{@value}" unit="{@unit}"/>
            </doseQuantity>
        </xsl:for-each>
    </xsl:template>

    <!-- ============= Main Function Dispatcher =============== -->
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
            <xsl:when test="@name='mapValueSetAndMove'">
                <xsl:call-template name="mapValueSetAndMove"/>
            </xsl:when>
            <xsl:when test="@name='addNode'">
                <xsl:call-template name="addNode"/>
            </xsl:when>
            <xsl:when test="@name='adjustEffectiveTime'">
                <xsl:call-template name="adjustEffectiveTime"/>
            </xsl:when>
            <xsl:when test="@name='changeAttribute'">
                <xsl:call-template name="changeAttribute"/>
            </xsl:when>
            <xsl:when test="@name='adjustDoseQuantity'">
                <xsl:call-template name="adjustDoseQuantity"/>
            </xsl:when>
            <xsl:when test="@name='mapValueSetAndAdd'">
                <xsl:call-template name="mapValueSetAndAdd"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>UNMAPPED FUNCTION: <xsl:value-of select="@name"/></xsl:comment>
                <xsl:call-template name="cr"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>
