<?xml version="1.0" encoding="UTF-8"?>

<!-- ************************************************************************************************************************ -->	
<!--  Generates Turtle from the enum nodes in an XSD file (converted from JSON)                                         -->	
<!--  Schema https://github.com/alphagov/publishing-api/tree/main/content_schemas/dist/formats                 -->	
<!-- ************************************************************************************************************************ -->	

<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions">

<!-- ************************************************************************************************************************ -->	
<xsl:template match="/">
	<xsl:result-document href="extracted.txt" method="text">
		<xsl:for-each select="//rendering_app/enum">
			<xsl:value-of select="concat('###  http://http://www.gov.uk/IA1#', .)"/>
			<xsl:text>&#xa;</xsl:text>
			<xsl:value-of select="concat(':',.,' rdf:type owl:Class ;')"/>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>rdfs:subClassOf :rendering_app ;</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>&lt;http://purl.org/dc/elements/1.1/creator&gt; "Marc Stephenson";</xsl:text>
			<xsl:text>&#xa;</xsl:text>
			<xsl:text>&lt;http://purl.org/dc/elements/1.1/date&gt;"2025-12-15T10:17:46Z"^^xsd:dateTime .</xsl:text>
			<xsl:text>&#xa;&#xa;</xsl:text>
		</xsl:for-each>
	</xsl:result-document>
</xsl:template>
</xsl:stylesheet>