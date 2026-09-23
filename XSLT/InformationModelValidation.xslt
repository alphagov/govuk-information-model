<?xml version="1.0" encoding="UTF-8"?>

<!-- ===============================================================================================
    Validates the Information Model as contained in a set of .rdf files in a single RDF folder.
	Outputs the validation results in a single Markdown file.

	Command Line:
	java -jar "tools/saxon-he-10.9.jar" -xsl:"XSLT/InformationModelValidation.xslt" -it:main -o:"Outputs/InformationModelValidation.md"
     ============================================================================================== -->

<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
    
    <xsl:param name="rdf-folder" as="xs:string" select="'../RDF'"/>
    
    <!-- ============================================================================================ -->
    <xsl:template name="markdown">
        <xsl:text># GOV.UK Information Model Validation</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>Validation run at </xsl:text>
        <xsl:value-of select="format-dateTime(current-dateTime(), '[H01]:[m01]:[s01], [D01] [MNn] [Y0001]')"/><xsl:text>&#10;&#10;</xsl:text>
        <xsl:text>| # | Primary Object | Validation Errors | &#10;</xsl:text>
        <xsl:text>|---:|:-----------------------|:------------------------| &#10;</xsl:text>
    </xsl:template>
   
	<!-- ========================================================================== -->	
	<xsl:template name="check-missing-en-gb">
		<xsl:variable name="errors" select="//*[@xml:lang and lower-case(@xml:lang) != 'en-gb']"/>
		<result>
			<errorcount><xsl:value-of select="count($errors)"/></errorcount>
			<errormessage>
				<xsl:for-each select="$errors">
					<xsl:text>Missing en-gb: **</xsl:text><xsl:value-of select="."/><xsl:text>**; </xsl:text>
				</xsl:for-each>
			</errormessage>
		</result>
	</xsl:template>

	<!-- ========================================================================== -->	
	<xsl:template name="check-pascal-case">
		<xsl:variable name="errors" select="//owl:Class[not(matches(substring-after(@rdf:about, '#'), '^[A-Z][a-z0-9]*([A-Z][a-z0-9]*)*$'))]"/>
		<result>
			<errorcount><xsl:value-of select="count($errors)"/></errorcount>
			<errormessage>
				<xsl:for-each select="$errors">
					<xsl:text> Not Pascal Case: **</xsl:text><xsl:value-of select="substring-after(@rdf:about, '#')"/><xsl:text>**; </xsl:text>
				</xsl:for-each>
			</errormessage>
		</result>
	</xsl:template>	
   
	<!-- ========================================================================== -->	
	<xsl:template name="check-IRI">
		<xsl:variable name="errors1" select="//@*[contains(.,'http://gov.uk')]"/>
		<result>
			<errorcount1><xsl:value-of select="count($errors1)"/></errorcount1>
			<errormessage1>
				<xsl:for-each select="$errors1">
					<xsl:text>Incorrect IRI: `</xsl:text><xsl:value-of select="."/><xsl:text>`; </xsl:text>
				</xsl:for-each>	
			</errormessage1>
			<xsl:variable name="errors2" select="//@*[contains(.,'//www.gov.uk')]"/>
			<errorcount2><xsl:value-of select="count($errors2)"/></errorcount2>
			<errormessage2>
				<xsl:for-each select="$errors2">
					<xsl:text>Incorrect IRI: `</xsl:text><xsl:value-of select="."/><xsl:text>`; </xsl:text>
				</xsl:for-each>	
			</errormessage2>
		</result>
	</xsl:template>    
   
	<!-- ========================================================================== -->	
	<xsl:output method="text" encoding="UTF-8"/>
    <xsl:template name="main" >
        <xsl:call-template name="markdown"/>
        <xsl:variable name="rdf-uri" select="resolve-uri($rdf-folder, static-base-uri())"/>
        <xsl:variable name="rdf-files" select="uri-collection($rdf-uri || '?select=*.rdf')"/>
        <xsl:message select="'RDF files: ', count($rdf-files)"/>
        <xsl:for-each select="$rdf-files">
            <xsl:sort select="."/>
            <xsl:variable name="filename" select="."/>
            <xsl:message select="'Processing: ', $filename"/>
            <xsl:variable name="document" select="doc($filename)"/>
            <xsl:text>|</xsl:text><xsl:value-of select="position()"/>
            <xsl:text>|</xsl:text><xsl:value-of select="$document//owl:Ontology/@rdf:about"/>
            <xsl:for-each select="$document">
				<xsl:text>|</xsl:text>
				<xsl:variable name="result1"><xsl:call-template name="check-missing-en-gb"/></xsl:variable>
				<xsl:value-of select="if ($result1/result/errorcount > 0) then $result1/result/errormessage else ''"/>     
				           
				<xsl:variable name="result2"><xsl:call-template name="check-pascal-case"/></xsl:variable>
				<xsl:value-of select="if ($result2/result/errorcount > 0) then $result2/result/errormessage else ''"/>      
				          
				<xsl:variable name="result3"><xsl:call-template name="check-IRI"/></xsl:variable>
				<xsl:value-of select="if ($result3/result/errorcount1 > 0) then $result3/result/errormessage1 else ''"/>    
				<xsl:value-of select="if ($result3/result/errorcount2 > 0) then $result3/result/errormessage2 else ''"/>    
				            
				<xsl:if test="($result1/result/errorcount+$result2/result/errorcount+$result3/result/errorcount) &lt; 1">0</xsl:if>
                <xsl:text>| &#10;</xsl:text>
            </xsl:for-each>
        </xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>