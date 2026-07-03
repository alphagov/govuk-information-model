<?xml version="1.0" encoding="UTF-8"?>

<!-- ************************************************************************************************************************ -->	
<!-- This script is used to                                                            -->	
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
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:text>digraph Ontology {&#10;</xsl:text>
        <xsl:text>graph [rankdir=LR, ordering=out, concentrate=true nodesep=0.5 ranksep=1.0];</xsl:text>
        <xsl:text>node [shape=box width=4.0 height=0.7 fixedsize=true fontname="Arial" fontsize=24 style=filled fillcolor="lightblue" color="darkgrey"];</xsl:text>
        <xsl:call-template name="subclasses">
            <xsl:with-param name="parent" select="'http://www.gov.uk/InformationArchitecture#Answer'"/>
        </xsl:call-template>
		<xsl:text>}</xsl:text>
    </xsl:template>
    
	<xsl:function name="f:local-name-from-iri" as="xs:string">
		<xsl:param name="iri" as="xs:string"/>
		<xsl:sequence select="tokenize($iri, '[#/]')[last()]"/>
	</xsl:function>    
       
    <xsl:template name="subclasses">
        <xsl:param name="parent"/>
        <xsl:for-each select="//owl:Class[rdfs:subClassOf/@rdf:resource = $parent]">
			<xsl:text>"</xsl:text>
			<xsl:value-of select="f:local-name-from-iri($parent)"/>
			<xsl:text>" -> "</xsl:text>
			<xsl:value-of select="f:local-name-from-iri(@rdf:about)"/>
			<xsl:text>";</xsl:text>

			<!-- Buttons -->
			<xsl:if test="count(.//owl:allValuesFrom[@rdf:resource='http://www.gov.uk/InformationArchitecture#Button'])">
				<xsl:value-of select="f:local-name-from-iri(@rdf:about)"/>
				<xsl:text>[fillcolor=pink];</xsl:text>
			</xsl:if>

			<!-- Taxonomies -->
			<xsl:if test="count(.//rdfs:subClassOf[@rdf:resource='http://www.gov.uk/InformationArchitecture#Taxonomy'])">
				<xsl:value-of select="f:local-name-from-iri(./@rdf:about)"/>
				<xsl:text>[fillcolor=palegreen];</xsl:text>
			</xsl:if>
			
			<!-- Taxons -->
			<!-- 
			<xsl:if test="./[contains(@rdf:about,'Format')]">
				<xsl:text>&#10;</xsl:text>
				<xsl:text>>>>></xsl:text>
				<xsl:value-of select="."/>
				<xsl:text>&#10;</xsl:text>
				<xsl:text>[fillcolor=mintgreen];</xsl:text>
			</xsl:if>		
			-->

            <xsl:text>&#10;</xsl:text>
            <xsl:call-template name="subclasses">
                <xsl:with-param name="parent" select="@rdf:about"/>
            </xsl:call-template>
        </xsl:for-each>       
    </xsl:template>

</xsl:stylesheet>