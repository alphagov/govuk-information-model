<?xml version="1.0" encoding="UTF-8"?>

<!-- ========================================================================== -->	
<!-- This script is used to validate the details of all ontology.rdf files in a source list                                     -->	
<!-- ========================================================================== -->	

<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:f="urn:functions">
  
	<!-- ========================================================================== -->	
	<xsl:template name="check-missing-en-gb">
		<xsl:variable name="errors"  select="//*[@xml:lang and not(contains(@xml:lang, 'en-gb'))]"/>
		<result>
			<count>
				<xsl:value-of select="count($errors)"/>
			</count>
			<messages>
				<xsl:for-each select="$errors">
					<xsl:text>❌ Missing en-gb: **</xsl:text><xsl:value-of select="."/><xsl:text>**</xsl:text>
				</xsl:for-each>
			</messages>
		</result>
	</xsl:template>

	<!-- ========================================================================== -->	
	<xsl:template name="check-pascal-case">
		<xsl:variable name="errors" select="//owl:Class[not(matches(substring-after(@rdf:about, '#'),'^[A-Z][a-zA-Z0-9]*$'))]"/>
		<result>
			<count>
				<xsl:value-of select="count($errors)"/>
			</count>
			<messages>
				<xsl:for-each select="$errors">
					<xsl:text>❌ Not Pascal Case: **</xsl:text><xsl:value-of select="substring-after(@rdf:about, '#')"/><xsl:text>**</xsl:text>
				</xsl:for-each>
			</messages>
		</result>
	</xsl:template>   

	<!-- ========================================================================== -->	
	<xsl:template name="check-IRI">
		<xsl:variable name="errors1" select="//@*[contains(., 'https://gov.uk') and not(contains(., 'https://gov.uk/ontology'))]"/>
		<xsl:variable name="errors2" select="//@*[contains(., '://www.gov.uk')]"/>
		<xsl:variable name="errors3" select="//@*[contains(., 'http://gov.uk')]"/>
		<xsl:variable name="errors4" select="//@rdf:about[starts-with(., 'https://gov.uk/') and (string-length(.) - string-length(replace(., '/', '')) > 4)] | //@rdf:resource[starts-with(., 'https://gov.uk/') and (string-length(.) - string-length(replace(., '/', '')) > 4)]"/>
		<result>
			<count>
				<xsl:value-of select="count($errors1) + count($errors2) + count($errors3) + count($errors4)"/>
			</count>
			<messages>
				<xsl:for-each select="$errors1">
					<xsl:text>❌ Incorrect IRI: **</xsl:text><xsl:value-of select="."/><xsl:text>**</xsl:text>
				</xsl:for-each>
				<xsl:for-each select="$errors2">
					<xsl:text>❌ Incorrect IRI: **</xsl:text><xsl:value-of select="."/><xsl:text>**</xsl:text>
				</xsl:for-each>
				<xsl:for-each select="$errors3">
					<xsl:text>❌ Incorrect IRI: **</xsl:text><xsl:value-of select="."/><xsl:text>**</xsl:text>
				</xsl:for-each>
				<xsl:for-each select="$errors4">
					<xsl:text>❌ Incorrect IRI: **</xsl:text><xsl:value-of select="."/><xsl:text>**</xsl:text>
				</xsl:for-each>
			</messages>
		</result>
	</xsl:template>	
   
	<!-- ========================================================================== -->	
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:template match="/">
		<xsl:result-document href="Validate.md" method="text" encoding="UTF-8">
		<xsl:text># GOV.UK Ontology Validation</xsl:text><xsl:text>&#10;</xsl:text>
		<xsl:text>Validated at </xsl:text><xsl:value-of select="format-dateTime(current-dateTime(),'[H01]:[m01]:[s01], [D01] [MNn] [Y0001]')"/><xsl:text> [UTC]&#10;&#10;</xsl:text>
			<xsl:for-each select="//file">
				<xsl:variable name="filename" select="resolve-uri(@href, base-uri(.))"/>
				<xsl:variable name="document" select="document($filename)"/>
				<xsl:text>Validating: </xsl:text><xsl:value-of select="@href"/>
				<xsl:for-each select="$document">
					<!-- Validation steps =========================================================== -->
					<xsl:variable name="result"><xsl:call-template name="check-missing-en-gb"/></xsl:variable>
					<xsl:text> (errors: </xsl:text><xsl:value-of select="$result/result/count"/><xsl:value-of select="$result/result/messages"/><xsl:text>) </xsl:text>
					
					<xsl:variable name="result"><xsl:call-template name="check-pascal-case"/></xsl:variable><xsl:text></xsl:text>
					<xsl:text> (errors: </xsl:text><xsl:value-of select="$result/result/count"/><xsl:value-of select="$result/result/messages"/><xsl:text>) </xsl:text>
					
					<xsl:variable name="result"><xsl:call-template name="check-IRI"/></xsl:variable>
					<xsl:text> (errors: </xsl:text><xsl:value-of select="$result/result/count"/><xsl:value-of select="$result/result/messages"/><xsl:text>)  </xsl:text>
				<!-- ======================================================================= -->
				<xsl:text>&#10;</xsl:text>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:result-document>
	</xsl:template>
</xsl:stylesheet>