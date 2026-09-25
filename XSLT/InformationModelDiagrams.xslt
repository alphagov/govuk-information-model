<?xml version="1.0" encoding="UTF-8"?>

<!-- ===============================================================================================
    Generates a .dot diagram file for each .rdf file in the RDF Information Model folder.
	Each .dot file is convereted to .svg for display in Markdown files.

	Command Line:
	java -jar "tools/saxon-he-10.9.jar" -xsl:"XSLT/InformationModelDiagrams.xslt" -it:main
	Get-ChildItem .\Outputs\*.dot | ForEach-Object {Write-Host "Processing: $($_.Name)"; dot -Tsvg $_.FullName -o (Join-Path $_.DirectoryName ($_.BaseName + ".svg"))}
     ============================================================================================== -->

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:f="urn:functions"
    exclude-result-prefixes="xs owl rdf rdfs f">

    <xsl:param name="rdf-folder" as="xs:string" select="'../RDF'"/>

    <xsl:output method="text" encoding="UTF-8"/>
    
    <!-- ========================================================= -->
    <xsl:function name="f:local-name-from-iri" as="xs:string">
        <xsl:param name="iri" as="xs:string"/>
        <xsl:sequence select="tokenize($iri, '[#/]' )[last()]"/>
    </xsl:function>

    <!-- ========================================================= -->
    <xsl:function name="f:dot-escape" as="xs:string">
        <xsl:param name="value" as="xs:string"/>
        <xsl:sequence select="replace(replace($value, '\\', '\\\\'), '&quot;', '\\&quot;')"/>
    </xsl:function>

    <!-- ========================================================= -->
    <xsl:function name="f:get-colour" as="xs:string">
        <xsl:param name="iri" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="contains(lower-case($iri), 'taxonomy')">
                <xsl:sequence select="'#0070C0'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case($iri), 'contentschema')">
                <xsl:sequence select="'#7030A0'"/>
            </xsl:when>
            <xsl:when test="contains(lower-case($iri), 'domain')">
                <xsl:sequence select="'#C00000'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="'#666666'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- ========================================================= -->
    <xsl:function name="f:node-id" as="xs:string">
        <xsl:param name="iri" as="xs:string"/>
        <xsl:sequence select="replace(replace(replace($iri, '[^A-Za-z0-9_]', '_'), '^([0-9])', '_$1'), '_+', '_')"/>
    </xsl:function>

    <!-- ========================================================= -->
    <xsl:template name="main">
		<xsl:variable name="rdf-uri" select="resolve-uri($rdf-folder || '/', static-base-uri())"/>
        <xsl:variable name="rdf-files" select="uri-collection($rdf-uri)[ends-with(lower-case(string(.)), '.rdf')]"/>
        <xsl:message select="'RDF files: ', count($rdf-files)"/>

        <!-- Generate one .dot file for each RDF file -->
        <xsl:for-each select="$rdf-files">
            <xsl:variable name="rdf-file" select="."/>
			<xsl:variable name="rdf-name" select="replace(tokenize(string($rdf-file), '/')[last()], '\.[Rr][Dd][Ff]$', '')"/>            
            <xsl:variable name="output-file" select="resolve-uri('../Outputs/' || $rdf-name || '.dot', static-base-uri())"/>
            <xsl:variable name="document" select="doc($rdf-file)"/>
            <xsl:message select="'Processing: ', tokenize(string($rdf-file), '/')[last()]"/>
			<xsl:result-document href="{$output-file}" method="text" encoding="UTF-8">            
                <xsl:text>digraph Ontology {&#10;</xsl:text>
                <xsl:text>  rankdir=LR;&#10;</xsl:text>
                <xsl:text>  ordering=out;&#10;</xsl:text>
                <xsl:text>  concentrate=true;&#10;</xsl:text>
                <xsl:text>  splines=ortho;&#10;</xsl:text>
                <xsl:text>  nodesep=0.25;&#10;</xsl:text>
                <xsl:text>  ranksep=0.8;&#10;</xsl:text>
                <xsl:text>  node [shape=box, width=1.7, height=0.3, fixedsize=false, fontname="Arial", fontsize=10, style="rounded,filled", fontcolor=white, margin="0.08,0.04", penwidth=0.8];&#10;</xsl:text>
                <xsl:text>  edge [color="#666666", penwidth=0.8, arrowsize=0.7];&#10;</xsl:text>
                <xsl:text>&#10;</xsl:text>

                <!-- Generate nodes from this RDF file only -->
                <xsl:for-each-group select="$document//owl:Class[@rdf:about]" group-by="string(@rdf:about)">
                    <xsl:sort select="current-grouping-key()"/>
                    <xsl:variable name="iri" select="string(@rdf:about)"/>
                    <xsl:variable name="id" select="f:node-id($iri)"/>
                    <xsl:variable name="label" select="if (normalize-space(rdfs:label[1])) then normalize-space(rdfs:label[1]) else f:local-name-from-iri($iri)"/>
                    <xsl:text>  "</xsl:text>
                    <xsl:value-of select="$id"/>
                    <xsl:text>" [label="</xsl:text>
                    <xsl:value-of select="f:dot-escape($label)"/>
                    <xsl:text>", fillcolor="</xsl:text>
                    <xsl:value-of select="f:get-colour($iri)"/>
                    <xsl:text>"];&#10;</xsl:text>
                </xsl:for-each-group>
                <xsl:text>&#10;</xsl:text>

                <!-- Generate subclass relationships from this RDF file only -->
                <xsl:for-each-group select="$document//owl:Class[@rdf:about] [rdfs:subClassOf[@rdf:resource] or rdfs:subClassOf/owl:Class[@rdf:about]]" group-by="concat(string(@rdf:about), '|', string((rdfs:subClassOf/@rdf:resource,rdfs:subClassOf/owl:Class/@rdf:about) [normalize-space()][1]))">
                    <xsl:variable name="child" select="string(@rdf:about)"/>
                    <xsl:variable name="parenttype1" select="string(rdfs:subClassOf/@rdf:resource)"/>
                    <xsl:variable name="parenttype2" select="string(rdfs:subClassOf/owl:Class/@rdf:about)"/>
                    <xsl:variable name="parent" select="($parenttype1[normalize-space()], $parenttype2[normalize-space()])[1]"/>
                    <xsl:text>  "</xsl:text>
                    <xsl:value-of select="f:node-id($parent)"/>
                    <xsl:text>" -&gt; "</xsl:text>
                    <xsl:value-of select="f:node-id($child)"/>
                    <xsl:text>";&#10;</xsl:text>
                </xsl:for-each-group>
                <xsl:text>}&#10;</xsl:text>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>