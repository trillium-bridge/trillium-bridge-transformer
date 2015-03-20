<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:epsos="urn:epsos-org:ep:medication">
    <xsl:import href="TBXform.xsl"/>
    <xsl:output media-type="xml" indent="yes"/> 
    <xsl:strip-space elements="*"/>

    
    <!-- ========================================================================================
        Front end for epsos to ccd transformation.  Sets parameters and invokes the main function
        ========================================================================================= -->
    
    <!-- Transformation rules -->
    <xsl:param name="transform">../tbxform/CCDtoEPSOS.xml</xsl:param>
    
    <!-- Target schemaa location -->
    <xsl:param name="schemaLocation">../schema/CDASchema/POCD_MT000040_extended.xsd</xsl:param>
    
</xsl:stylesheet>