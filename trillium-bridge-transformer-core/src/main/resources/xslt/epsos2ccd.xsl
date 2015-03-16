<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output media-type="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:include href="TBXform.xsl"/>
    
    <!-- ========================================================================================
        Front end for epsos to ccd transformation.  Sets parameters and invokes the main function
        ========================================================================================= -->
    
    <!-- Transformation rules -->
    <xsl:param name="transform">../tbxform/EPSOStoCCD.xml</xsl:param>
    
    <!-- Schema Location -->
    <xsl:param name="schemaLocation">../schema/CDASchema/CDA_extended.xsd</xsl:param>
    
</xsl:stylesheet>