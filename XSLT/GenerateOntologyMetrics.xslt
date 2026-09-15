<?xml version="1.0" encoding="UTF-8"?>

<!-- ========================================================================== -->	
<!-- This script is used to generate core metrics for all ontology.rdf files in a source list                               -->	
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
	<xsl:function name="f:local-name-from-iri" as="xs:string">
		<xsl:param name="iri" as="xs:string"/>
		<xsl:sequence select="tokenize($iri, '[#/]')[last()]"/>
	</xsl:function>    

	<!-- ========================================================================== -->	
	<xsl:template name="html">
	<xsl:text># GOV.UK Ontology Metrics</xsl:text><xsl:text>&#10;</xsl:text>
	<xsl:text>Metrics generated at </xsl:text><xsl:value-of select="format-dateTime(current-dateTime(),'[H01]:[m01]:[s01], [D01] [MNn] [Y0001]')"/><xsl:text> [UTC]&#10;&#10;</xsl:text>
	<xsl:text>| Ontology | Total Classes | Total Sub-classes | Total Unique Datatypes | &#10;</xsl:text>
	<xsl:text>|:--------------|----------------------|----------------------------|-----------------------------------| &#10;</xsl:text>
	</xsl:template>    
  
	<!-- ========================================================================== -->	
	<xsl:output method="text" encoding="UTF-8"/>
	<xsl:template match="/">
		<xsl:call-template name="html"/>
		<xsl:for-each select="//file">
			<xsl:variable name="filename" select="resolve-uri(@href, base-uri(.))"/>
			<xsl:variable name="document" select="doc($filename)"/>				
			<xsl:for-each select="$document">
				<xsl:variable name="rootclassname" select="//owl:Class[not(rdfs:subClassOf)]/@rdf:about"/>
				<xsl:variable name="immediatesubclassname" select="(//rdfs:subClassOf[@rdf:resource=$rootclassname])/../@rdf:about"/>
				<xsl:text>| </xsl:text><xsl:value-of select="//owl:Ontology/@rdf:about"/>
				<xsl:text>| </xsl:text><xsl:value-of select="count(//owl:Class)"/>
				<xsl:text>| </xsl:text><xsl:value-of select="count(//rdfs:subClassOf)"/>
				<xsl:text>| </xsl:text><xsl:value-of select="count(distinct-values(//*/@rdf:datatype))"/><xsl:text> | &#10;</xsl:text>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>