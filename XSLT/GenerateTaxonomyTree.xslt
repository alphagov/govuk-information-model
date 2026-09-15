<?xml version="1.0" encoding="UTF-8"?>

<!-- ========================================================================== -->	
<!-- This script is used to output a hierachical taxonomy in markdown                                                       -->	
<!-- ========================================================================== -->	

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    exclude-result-prefixes="rdf skos">

    <xsl:output method="text" encoding="UTF-8"/>

	<!-- ========================================================================== -->	

    <xsl:template match="/">
   		<xsl:result-document href="Taxonomy.md" method="text" encoding="UTF-8">
			<xsl:text># </xsl:text><xsl:value-of select="//skos:ConceptScheme/skos:prefLabel"/><xsl:text>&#10;</xsl:text>
			<xsl:text>Generated at </xsl:text><xsl:value-of select="format-dateTime(current-dateTime(),'[H01]:[m01]:[s01], [D01] [MNn] [Y0001]')"/><xsl:text> [UTC]&#10;&#10;</xsl:text>
			<!-- Find top-level concepts -->
			<xsl:for-each select="//skos:Concept[not(skos:broader)]">
				<xsl:call-template name="output-concept">
					<xsl:with-param name="concept" select="."/>
					<xsl:with-param name="level" select="0"/>
				</xsl:call-template>
			</xsl:for-each>
			</xsl:result-document>
		</xsl:template>

		<!-- ========================================================================== -->	
		<xsl:template name="output-concept">
			<xsl:param name="concept"/>
			<xsl:param name="level"/>
			<xsl:for-each select="1 to $level">
				<xsl:text>    </xsl:text>
			</xsl:for-each>
			<xsl:text>- </xsl:text>
			<xsl:value-of select="$concept/skos:prefLabel"/>
			<xsl:text>&#10;</xsl:text>
			<!-- Find children -->
			<xsl:for-each select="//skos:Concept[skos:broader/@rdf:resource=$concept/@rdf:about]">
				<xsl:call-template name="output-concept">
					<xsl:with-param name="concept" select="."/>
					<xsl:with-param name="level" select="$level + 1"/>
				</xsl:call-template>
			</xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>