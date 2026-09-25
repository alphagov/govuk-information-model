<?xml version="1.0" encoding="UTF-8"?>

<!-- ===============================================================================================
    Generates core metrics for the Information Model as contained in a set of .rdf files in a single RDF folder.
	Outputs the metrics in a single Markdown file.

	Command Line:
	java -jar "tools/saxon-he-10.9.jar" -xsl:"XSLT/InformationModelMetrics.xslt" -it:main -o:"Outputs/InformationModelMetrics.md"
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
        <xsl:text># GOV.UK Information Model Metrics</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>Metrics generated at </xsl:text>
        <xsl:value-of select="format-dateTime(current-dateTime(), '[H01]:[m01]:[s01], [D01] [MNn] [Y0001]')"/><xsl:text>&#10;&#10;</xsl:text>
        <xsl:text>| # | Primary Object | Total Classes | Total Sub-classes | Total Unique Datatypes | &#10;</xsl:text>
        <xsl:text>|---:|:-----------------------|----------------------|----------------------------|------------------------------------| &#10;</xsl:text>
    </xsl:template>

    <!-- =========================================================================================== -->
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
            <xsl:text>| </xsl:text><xsl:value-of select="position()"/>
            <xsl:text>| </xsl:text><xsl:value-of select="$document//owl:Ontology/@rdf:about"/>
            <xsl:text>| </xsl:text><xsl:value-of select="count($document//owl:Class)"/>
            <xsl:text>| </xsl:text><xsl:value-of select="count($document//rdfs:subClassOf)"/>
            <xsl:text>| </xsl:text><xsl:value-of select="count(distinct-values($document//*/@rdf:datatype))"/>
            <xsl:text> | &#10;</xsl:text>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>