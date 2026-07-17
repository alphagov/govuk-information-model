<?xml version="1.0" encoding="UTF-8"?>

<!-- ************************************************************************************************************************ -->	
<!-- This script is used to validate the details in an ontology (.rdf file)                                                           -->	
<!-- The script ensures ....                                                                                                                       -->
<!-- ************************************************************************************************************************ -->	

<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">

<!-- ************************************************************************************************************************ -->	
<xsl:template match="/">
	<xsl:result-document href="Output.html" method="html">

	<html>
	<head>
	<title></title>
	<link rel="stylesheet" href="file:///C:/Users/marcs/OneDrive/Desktop/Work/GDS/Ontologies/stylesheet.css"/>
	</head>
	<body>
	<div class="govuk-width-container">
	<main class="govuk-main-wrapper">
	
	<xsl:variable name="class">
		<xsl:value-of select="'http://www.gov.uk/IA1#Tax'"/>	
	</xsl:variable>

	<h1 class="govuk-heading-xl">Ontology Documentation</h1>
	<hr class="govuk-section-break govuk-section-break--visible"/>
	
	<h2 class="govuk-heading-l">Object: <xsl:value-of select="substring-after($class, '#')"/></h2>
	<xsl:for-each select="//rdfs:subClassOf[@rdf:resource=$class]/../@rdf:about">	
		<h3 class="govuk-heading-s"><xsl:value-of select="substring-after(.,'#')"/></h3>
	</xsl:for-each>

	<hr class="govuk-section-break govuk-section-break--visible"/>
	Ontology as of <xsl:value-of select="format-dateTime(current-dateTime(),'[D01]/[M01]/[YY] ')"/><xsl:value-of select="format-dateTime(current-dateTime(),'at [H01]:[m01]')"/>
	</main>
	</div>
	</body>
	</html>
		
	</xsl:result-document>
</xsl:template>
</xsl:stylesheet>