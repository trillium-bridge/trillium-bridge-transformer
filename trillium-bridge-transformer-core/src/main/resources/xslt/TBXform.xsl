<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tbx="http://trilliumbridge.org/xform"
    exclude-result-prefixes="xs tbx" version="2.0" xpath-default-namespace="urn:hl7-org:v3">
    <xsl:output media-type="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:include href="TBTransformations.xsl"/>

    <xsl:param name="showpaths" select="'false'"/>
    <xsl:param name="copycomments" select="'true'"/>
    <xsl:param name="debugging" select="'false'"/>
    <xsl:param name="copypi" select="'true'"/>

    <xsl:variable name="cr" select="'&#xa;'"/>
    <xsl:variable name="tab" select="'&#x9;'"/>
    <xsl:variable name="quot">"</xsl:variable>

    <!-- ================= Entry Point =========================
        Match a clinical document.  Parameters:
        
        $from   - the source document type
        $to     - the target document type
        $showpaths - True embeds the path of each element in the output
        $copycomments - True copies comments from source to target.  False removes them
        $maps   - the set of mappings to apply to the clinical document.
        
        This template exists to catch the comments and processing instructions that preceed the first document node.
        Note that this node doesn't get called in an xspec scenario, as the document is intercepted by the 
        xspec package itself.  Anything that is done here must also be repeated in the clinical document map
        ======================================================== -->
    <xsl:template match="/" xml:space="default">
        <xsl:apply-templates>
            <xsl:with-param name="mapcontext" select="tbx:opendoc($transform)/tbx:map" tunnel="yes"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- ==================== Clinical Document ====================
        Beginning of the actual processing.  Pick up the document identifier and language
        and begin the actual transformation
        ============================================================= -->
    <xsl:template match="//ClinicalDocument">
        <xsl:apply-templates select="." mode="inside">
            <xsl:with-param name="mapcontext" select="tbx:opendoc($transform)/tbx:map" tunnel="yes"/>
            <xsl:with-param name="absbase" select="''" tunnel="yes"/>
            <xsl:with-param name="relbase" select="''" tunnel="yes"/>
            <xsl:with-param name="language" select="languageCode/@code" tunnel="yes"/>
            <xsl:with-param name="id" select="id" tunnel="yes"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- ================= Element Processor =========================
        Match a clinical document element. Parameters:
        
        $absbas     - the surrounding path to this point in TBPath format
        $relbase    - the relative path to this point within the surrounding context
        $language   - the language of the incoming document
        $mapcontext - the tbx:map context for transformation
        $globals    - if present the map context to apply to every instance
        $matchonly  - true means that we're doing a move and non matches shouldn't be copied
        =============================================================== -->
    <xsl:template match="*" xmlns="urn:hl7-org:v3" mode="inside">
        <xsl:param name="absbase" as="xs:string" tunnel="yes"/>
        <xsl:param name="relbase" as="xs:string" tunnel="yes"/>
        <xsl:param name="mapcontext" as="element()" tunnel="yes"/>
        <xsl:param name="globals" as="element()*" tunnel="yes"/>
        <xsl:param name="matchonly" tunnel="yes" select="false()"/>

        <xsl:variable name="abspath" select="tbx:refmark($absbase, .)"/>
        <xsl:variable name="relpath" select="tbx:refmark($relbase, .)"/>
        <xsl:variable name="context" select="current()"/>

        <!-- Debugging -->
        <xsl:if test="$showpaths = 'true'">
            <xsl:value-of select="$cr"/>
            <xsl:comment><xsl:value-of select="concat($tab, 'FULL PATH:  ', $abspath, $cr, $tab, $tab, 'LOCAL PATH: ', $relpath, '  ')"/></xsl:comment>
            <xsl:value-of select="$cr"/>
        </xsl:if>

        <!-- Error checks -->
        <xsl:if test="not(ends-with(replace($relpath, '\[[^\]]*\]', ''), $context/name()))">
            <xsl:message terminate="yes">
                <xsl:text>PATH Alignment error:</xsl:text>
                <xsl:value-of select="concat($cr, $tab, 'relpath:', $relpath)"/>
                <xsl:value-of select="concat($cr, $tab, 'node:', $context/name())"/>
            </xsl:message>
        </xsl:if>
        
        <!-- Look for a matching context or transformation match -->
       <xsl:variable name="contextmatch"
            select="$mapcontext/tbx:context[(not(exists(@from)) or @from=$from) and (not(exists(@to)) or @to=$to) and tbx:root=$relpath]"/>
        <xsl:variable name="transformmatch" 
            select="$mapcontext/tbx:transform[tbx:path=$relpath and not(@global=true())]"/>
        
        <!-- Global match rules are saved and carried across levels. -->
        <xsl:variable name="allglobals" select="$globals union $mapcontext/tbx:transform[@global=true()]"/>
        <xsl:variable name="globalmatch" select="$allglobals[ends-with($relpath, tbx:path)]"/>
            
        
        <!-- Error checks -->
       <!-- <xsl:if test="boolean($contextmatch) and boolean($transformmatch)">
            <xsl:message terminate="yes">
                <xsl:text>Same path specified for both a transform and a context</xsl:text>
                <xsl:copy-of select="$transformmatch"/>
                <xsl:copy-of select="$contextmatch"/>
            </xsl:message>
        </xsl:if>-->
        <xsl:if test="boolean($globalmatch) and boolean($transformmatch)">
            <xsl:message terminate="yes">
                <xsl:text>Same path specified for both a norma transform and a global transform</xsl:text>
                <xsl:copy-of select="$transformmatch"/>
                <xsl:copy-of select="$globalmatch"/>
            </xsl:message>
        </xsl:if>
        

            <xsl:if test="$globalmatch">
                <xsl:for-each select="$globalmatch/tbx:transformation">
                    <xsl:value-of select="tbx:debugging(concat('GLOBAL TRANSFORM: ', @name))"/>
                    <xsl:call-template name="applyTransformations">
                        <xsl:with-param name="context" select="$context" tunnel="yes" />
                        <xsl:with-param name="globals" select="$allglobals" tunnel="yes"/>
                        <xsl:with-param name="mapcontext" select="." tunnel="yes"/>
                        <xsl:with-param name="matchonly" select="false()" tunnel="yes"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:if>
            
            <xsl:if test="$transformmatch">
                <!-- transformation node(s).  Apply the transformation rule -->
                <xsl:choose>
                    <!-- If this isn't the first match, ignore it completely -->
                    <xsl:when test="boolean(preceding-sibling::*[name()=$context/name()]) and $context/name() = 'templateId'">
                        <xsl:value-of select="tbx:debugging('TRANSFORM (successor node)')"/>
                    </xsl:when>
                    
                    <!-- Otherwise apply the transformations -->
                    <xsl:otherwise>
                        <xsl:variable name="contexts" select="../*[name()=$context/name()]"/>
                        
                        <xsl:for-each select="$transformmatch/tbx:transformation">
                            <xsl:value-of select="tbx:debugging(concat('TRANSFORM: ', @name))"/>
                            <xsl:call-template name="applyTransformations">
                                <xsl:with-param name="absbase" select="$abspath" tunnel="yes"/>
                                <xsl:with-param name="context" tunnel="yes" select="$context"/>
                                <xsl:with-param name="relbase" select="$relpath" tunnel="yes"/>
                                <xsl:with-param name="globals" select="$allglobals" tunnel="yes"/>
                                <xsl:with-param name="mapcontext" select="$mapcontext" tunnel="yes"/>
                                <xsl:with-param name="matchonly" select="false()" tunnel="yes"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            
            <xsl:if test="$contextmatch">
                <!-- Context node.  Set a new base context and descend -->
                <xsl:value-of select="tbx:debugging('CONTEXT')"/>
                <xsl:choose>
                    <xsl:when test="boolean($contextmatch/@global)">
                        <xsl:for-each select="$contextmatch/tbx:transformation">
                            <xsl:call-template name="applyTransformations">
                                <xsl:with-param name="context" select="$context" tunnel="yes"/>
                                <xsl:with-param name="globals" select="$allglobals" tunnel="yes"/>
                                <xsl:with-param name="mapcontext" select="." tunnel="yes"/>
                                <xsl:with-param name="matchonly" select="false()" tunnel="yes"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy>
                            <xsl:apply-templates select="@* | node()" mode="inside">
                                <xsl:with-param name="absbase" select="$abspath" tunnel="yes"/>
                                <xsl:with-param name="context" tunnel="yes" select="$context"/>
                                <xsl:with-param name="relbase" select="''" tunnel="yes"/>
                                <xsl:with-param name="globals" select="$allglobals" tunnel="yes"/>
                                <xsl:with-param name="mapcontext" select="$contextmatch" tunnel="yes"/>
                                <xsl:with-param name="matchonly" select="$matchonly" tunnel="yes"/>
                            </xsl:apply-templates>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            
            <xsl:if test="not($globalmatch or $contextmatch or $transformmatch)">
                <!-- No context or transformation entry. Copy the node if $matchonly is false and proceed -->
                <xsl:choose>
                    <xsl:when test="$matchonly">
                        <xsl:value-of select="tbx:debugging('IGNORE')"/>
                        <xsl:apply-templates select="@* | node()" mode="inside">
                            <xsl:with-param name="absbase" select="$abspath" tunnel="yes"/>
                            <xsl:with-param name="globals" select="$allglobals" tunnel="yes"/>
                            <xsl:with-param name="relbase" select="$relpath" tunnel="yes"/>
                            <xsl:with-param name="matchonly" tunnel="yes" select="$matchonly"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="tbx:debugging('COPY')"/>
                        <xsl:copy>
                            <xsl:apply-templates select="@* | node()" mode="inside">
                                <xsl:with-param name="absbase" select="$abspath" tunnel="yes"/>
                                <xsl:with-param name="globals" select="$allglobals" tunnel="yes"/>
                                <xsl:with-param name="relbase" select="$relpath" tunnel="yes"/>
                                <xsl:with-param name="matchonly" tunnel="yes" select="$matchonly"/>
                            </xsl:apply-templates>
                        </xsl:copy>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        
        
    </xsl:template>

    <!-- ================================= refmark ================================
        Function to append the current context name plus any differentiating identifers
        
        $root    - relative or absolute base path
        $context - current position
        
        return: updated path
        ============================================================================ -->
    <xsl:function name="tbx:refmark" as="xs:string">
        <xsl:param name="root"/>
        <xsl:param name="context"/>
        <xsl:variable name="base" select="concat($root, '/', $context/name())"/>
        <xsl:choose>
            <xsl:when test="$context/templateId">
                <xsl:value-of select="concat($base, '[templateId/@root=', $quot, $context/templateId[1]/@root, $quot, ']')"/>
            </xsl:when>
            <xsl:when test="$context/@typeCode">
                <xsl:value-of select="concat($base,'[@typeCode=', $quot, $context/@typeCode, $quot, ']')"/>
            </xsl:when>
            <xsl:when test="$context/@classCode">
                <xsl:value-of select="concat($base,'[@classCode=', $quot, $context/@classCode, $quot, ']')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$base"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>


    <!-- ============================== default attribute processor ===========
         Attributes never require direct transformation. They are always 
         handled in the element context 
         ====================================================================== -->
    <xsl:template match="@*" mode="inside">
        <xsl:param name="matchonly" tunnel="yes"/>
        <xsl:if test="not($matchonly)">
            <xsl:copy/>
        </xsl:if>
    </xsl:template>

    <!-- ============================== default comment processor =============
         Comments can be transferred verbatim or removed depending on preferences 
         ====================================================================== -->
    <xsl:template match="comment()" mode="#all">
        <xsl:param name="matchonly" tunnel="yes" select="false()"/>
        <xsl:if test="$copycomments = 'true' and not($matchonly)">
            <xsl:copy/>
        </xsl:if>
    </xsl:template>

    <!-- ============================== processing instruction processor ======
         Processing instructions can be transformed.
         ====================================================================== -->
    <xsl:template match="processing-instruction()" mode="#all">
        <xsl:param name="mapcontext" tunnel="yes" select="tbx:opendoc($transform)/tbx:map"/>
        <xsl:param name="matchonly" tunnel="yes" select="false()"/>
        <xsl:if test="not($matchonly) and $copypi">
            <xsl:variable name="relpath" select="concat('processing-instruction/', name())"/>
            <xsl:variable name="mapmatch"
                select="$mapcontext/tbx:context[@from=$from and @to=$to]/tbx:transform[tbx:path=$relpath]/node()"/>
            <xsl:choose>
                <xsl:when test="$mapmatch">
                    <xsl:variable name="mapentry" select="$mapmatch/tbx:arg"/>
                    <xsl:variable name="value" select="concat(tbx:subPIvariables($mapentry/@value), '.xsl')"/>
                    <xsl:variable name="default" select="concat(tbx:subPIvariables($mapentry/@default), '.xsl')"/>
                    <xsl:choose>
                        <xsl:when test="doc-available($value)">
                            <xsl:processing-instruction name="{name()}">
                            <xsl:text>type="text/xsl" href="</xsl:text><xsl:value-of select="concat('resources/', $value, $quot)"/>
                        </xsl:processing-instruction>
                        </xsl:when>
                        <xsl:when test="doc-available($default)">
                            <xsl:processing-instruction name="{name()}">
                            <xsl:text>type="text/xsl" href="</xsl:text><xsl:value-of select="concat('resources/', $default, $quot)"/>
                        </xsl:processing-instruction>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:comment select="concat('&lt;?', name(), ' ', ., '?>')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="$copycomments = 'true'">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:function name="tbx:subPIvariables" as="xs:string">
        <xsl:param name="arg" as="xs:string"/>
        <xsl:value-of select="replace(replace(replace($arg, '\{to\}', $to), '\{from\}', $from), '\{language\}', $tolanguage)"/>
    </xsl:function>


    <!-- ============================= default text processor =================
         Default is to copy
         ====================================================================== -->
    <xsl:template match="text()" mode="inside">
        <xsl:param name="matchonly" tunnel="yes"/>
        <xsl:if test="not($matchonly)">
            <xsl:value-of select="if (normalize-space(.)) then string(.) else ()"/>
        </xsl:if>
    </xsl:template>

    <!-- ============================== Document open utility =================
         Open the supplied document or create an error if not found
         ====================================================================== -->
    <xsl:function name="tbx:opendoc" as="document-node()">
        <xsl:param name="docname" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="doc-available($docname)">
                <xsl:copy-of select="doc($docname)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    <xsl:text>Unable to open </xsl:text>
                    <xsl:value-of select="$docname"/>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="tbx:debugging">
        <xsl:param name="msg" as="xs:string"/>
        <xsl:if test="$debugging = 'true'">
            <xsl:value-of select="concat($cr,$tab, $tab, $msg, $cr)"/>
        </xsl:if>
    </xsl:function>

</xsl:stylesheet>
