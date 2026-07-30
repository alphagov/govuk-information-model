<?xml version="1.0" encoding="UTF-8"?>

<!-- ************************************************************************************************************************ -->	
<!-- This script is used to validate the details in an ontology (.rdf file)                                                           -->	
<!-- ************************************************************************************************************************ -->	

<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:f="urn:functions">

	<!-- ************************************************************************************************************************ -->	
		<xsl:function name="f:header" as="xs:string">
		<xsl:param name="s" as="xs:string"/>
		<xsl:sequence select="concat($s,'&#xa;')"/> 
	</xsl:function>

	<!-- ************************************************************************************************************************ -->	
	<xsl:template match="/">
		<xsl:result-document href="Validate.txt" method="text">
	
			<!-- ======================================================================= -->	
			<xsl:text>MISSING LANG ATTRUBUTE&#xa;</xsl:text>
			<xsl:variable name="query" select="'//rdfs:label[not(@xml:lang)]'"/>
	
			<!-- ======================================================================= -->	
			<xsl:value-of select="f:header('MISSING EN-GB or CY')"/>
			<xsl:text></xsl:text><xsl:value-of select="count(//rdfs:label[not(@xml:lang='en-gb') and not(@xml:lang='cy')])"/><xsl:text> occurences</xsl:text>
			<xsl:for-each select="//rdfs:label[not(@xml:lang='en-gb') and not(@xml:lang='cy')]">
				<xsl:text>&#xa;</xsl:text>
				<xsl:value-of select="."/>
			</xsl:for-each>
			<xsl:text>bb&#xa;</xsl:text>

			<!-- ======================================================================= -->	
			<xsl:text>INCORRECT SOMEVALUESFROM&#xa;</xsl:text>
			<xsl:for-each select="//owl:someValuesFrom/../../../@rdf:about">
				<xsl:value-of select="."/>
				<xsl:text>&#xa;</xsl:text>
			</xsl:for-each>
		
			<!-- ======================================================================= -->	
			<xsl:text>MISSING DATATYPE&#xa;</xsl:text>
			<xsl:for-each select="//owl:Class[@rdf:about]">
				<xsl:variable name="about" select="@rdf:about"/>
				<xsl:if test="not(.//*[contains(@rdf:resource,'#hasDatatype')]) and (count(//*[@rdf:about=$about]))&lt;2 and (count(//*[@rdf:resource=$about])&lt;2)">
					<xsl:value-of select="@rdf:about"/>																																																										
					<xsl:text>=</xsl:text>
					<xsl:value-of select="count(//*[@rdf:about=$about])"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="count(.//*[contains(@rdf:resource,'#hasDatatype')])"/>
					<xsl:text>-</xsl:text>
					<xsl:value-of select="count(//*[@rdf:resource=$about])"/>
					<xsl:text>&#xa;</xsl:text>
				</xsl:if>
			</xsl:for-each>				
		
			<!-- ======================================================================= -->	
			<xsl:text>&#xa;>>> NOT PASCAL CASE&#xa;</xsl:text>
			<xsl:for-each select="//owl:Class">
				<xsl:if test="not(matches(substring-after(./@rdf:about,'#'), '^[A-Z]+[a-z0-9]+(?:[A-Z][a-z0-9]+)*$'))">
					<xsl:value-of select="substring-after(./@rdf:about,'#')"/>
					<xsl:text>&#xa;</xsl:text>
				</xsl:if>
			</xsl:for-each>		

		</xsl:result-document>
	</xsl:template>
</xsl:stylesheet>