<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tbx="http://trilliumbridge.org/xform"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- ===================================================================
         tolanguage - target transformation language
         =================================================================== -->
    <xsl:param name="tolanguage">en-EN</xsl:param>
    
    <!-- ===================================================================
         transform - the URI of the transformation rules document
         =================================================================== -->
    <xsl:param name="transform" as="element(tbx:map)"/>
    
    <!-- ===================================================================
         schemalocation - the URI the target schemalocation "/" means none
         =================================================================== -->
    <xsl:param name="schemaLocation" as="xs:anyURI">/</xsl:param> 
    
    <!-- =================================================================
         copycomments - copy the comments from the source to the target document
         =================================================================== -->
    <xsl:param name="copycomments" select="'true'"/>
    
    <!-- ===================================================================
         translationbase - the base URI of the Bing translator gateway
         =================================================================== -->
    <xsl:param name="translationbase">http://informatics.mayo.edu/trillium-bridge/translator</xsl:param>
    
    <!-- ===================================================================
         usebing - true means use the bing translation gateway
         =================================================================== -->
    <xsl:param name="usebing" select="'true'"/>
    
    <!-- ===================================================================
         transform - URI base for redirects
         =================================================================== -->
    <xsl:param name="base" as="xs:string">trillium-bridge</xsl:param>

    <!-- ===================================================================
         copypi - copy the processing instructions from the source to the target document
         If 'false', the stylesheet processing instruction will not be copied
         =================================================================== -->
    <xsl:param name="copypi" select="'true'"/>
    
    <!-- ===================================================================
         addDefaults - If true, addNodes with ifnot are processed.  If false
          they are ignored (for testing)
         =================================================================== -->   
    <xsl:param name="addDefaults" select="'true'"/>
    
    <!-- ===================================================================
         showpaths - Show the relative and absolute paths of all statements as comments
         Used for debugging
         =================================================================== -->   
    <xsl:param name="showpaths" select="'false'"/>

    <!-- ===================================================================
         debugging - Show the transformations that are invoked and other useful information 
         =================================================================== --> 
    <xsl:param name="debugging" select="'false'"/>

</xsl:stylesheet>
