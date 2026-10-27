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
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:f="urn:functions"
    exclude-result-prefixes="xs owl rdf rdfs skos f">

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
    <xsl:function name="f:format-title" as="xs:string">
        <xsl:param name="value" as="xs:string"/>
        <xsl:sequence select="replace(replace(replace($value, '^Taxonomy', 'Taxonomy: '),'^Domain','Domain: '),'^ContentSchema','Content Schema:')"/>
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

<!-- ============================================================================================ -->
    <xsl:template name="outputontology">
		<xsl:param name="document"/>
        <xsl:text>     node [shape=box, width=1.7, height=0.3, fixedsize=true, fontname="Arial", fontsize=10, style="rounded,filled", fontcolor=white, margin="0.08,0.04", penwidth=0.3];&#10;</xsl:text>
		<!-- Generate nodes from this RDF file only -->
        <xsl:for-each-group select="$document//owl:Class[@rdf:about]" group-by="string(@rdf:about)">
			<xsl:sort select="current-grouping-key()"/>            
            <xsl:variable name="iri" select="string(@rdf:about)"/>
            <xsl:variable name="id" select="f:node-id($iri)"/>
            <xsl:variable name="label" select="if (normalize-space(rdfs:label[1])) then normalize-space(rdfs:label[1]) else f:local-name-from-iri($iri)"/>
            <xsl:text>    "</xsl:text>
            <xsl:value-of select="$id"/>
            <xsl:text>" [label="</xsl:text>
            <xsl:value-of select="f:dot-escape($label)"/>
            <xsl:text>\l", fillcolor="</xsl:text><xsl:value-of select="f:get-colour($iri)"/><xsl:text>"];&#10;</xsl:text>
        </xsl:for-each-group>
        <!-- Generate subclass relationships from this RDF file only -->
        <xsl:for-each-group select="$document//owl:Class[@rdf:about] [rdfs:subClassOf[@rdf:resource] or rdfs:subClassOf/owl:Class[@rdf:about]]" group-by="concat(string(@rdf:about), '|', string((rdfs:subClassOf/@rdf:resource,rdfs:subClassOf/owl:Class/@rdf:about) [normalize-space()][1]))">
			<xsl:sort select="lower-case(string((rdfs:subClassOf/@rdf:resource,rdfs:subClassOf/owl:Class/@rdf:about)[normalize-space()][1]))"/> <!-- Sort by parent IRI -->
			<xsl:sort select="lower-case(string(@rdf:about))"/>  <!-- Then by child IRI -->              
            <xsl:variable name="child" select="string(@rdf:about)"/>
            <xsl:variable name="parenttype1" select="string(rdfs:subClassOf/@rdf:resource)"/>
            <xsl:variable name="parenttype2" select="string(rdfs:subClassOf/owl:Class/@rdf:about)"/>
            <xsl:variable name="parent" select="($parenttype1[normalize-space()], $parenttype2[normalize-space()])[1]"/>
            <xsl:text>    "</xsl:text>
            <xsl:value-of select="f:node-id($parent)"/>
            <xsl:text>" -&gt; "</xsl:text>
            <xsl:value-of select="f:node-id($child)"/>
            <xsl:text>";&#10;</xsl:text>
        </xsl:for-each-group>
	</xsl:template>

<!-- ============================================================================================ -->
    <xsl:template name="outputtaxonomy">
		<xsl:param name="document"/>
        <xsl:text>     node [shape=box, width=3.7, height=0.3, fixedsize=true, fontname="Arial", fontsize=10, style="rounded,filled", fontcolor=white, margin="0.08,0.04", penwidth=0.3];&#10;</xsl:text>
		<!-- SKOS taxonomy: concept scheme, concepts and broader relationships -->
        <xsl:for-each-group select="$document//skos:ConceptScheme[@rdf:about]" group-by="string(@rdf:about)">
			<xsl:sort select="lower-case(string((current-group()/skos:prefLabel)[1]))"/>
            <xsl:variable name="iri" select="current-grouping-key()"/>
            <xsl:variable name="label" select="if (normalize-space((current-group()/skos:prefLabel)[1])) then normalize-space((current-group()/skos:prefLabel)[1]) else f:local-name-from-iri($iri)"/>
            <xsl:text>    "</xsl:text><xsl:value-of select="f:node-id($iri)"/>
            <xsl:text>" [label="</xsl:text><xsl:value-of select="f:dot-escape($label)"/>
            <xsl:text>\l", fillcolor="</xsl:text><xsl:value-of select="f:get-colour($iri)"/><xsl:text>"];&#10;</xsl:text>
        </xsl:for-each-group>
        <xsl:for-each-group select="$document//skos:Concept[@rdf:about]" group-by="string(@rdf:about)">
			<xsl:sort select="lower-case(string((current-group()/skos:prefLabel)[1]))"/>
            <xsl:variable name="iri" select="current-grouping-key()"/>
            <xsl:variable name="label" select="if (normalize-space((current-group()/skos:prefLabel)[1])) then normalize-space((current-group()/skos:prefLabel)[1]) else f:local-name-from-iri($iri)"/>
            <xsl:text>    "</xsl:text><xsl:value-of select="f:node-id($iri)"/>
            <xsl:text>" [label="</xsl:text><xsl:value-of select="f:dot-escape($label)"/>
            <xsl:text>\l", fillcolor="</xsl:text><xsl:value-of select="f:get-colour($iri)"/><xsl:text>"];&#10;</xsl:text>
        </xsl:for-each-group>
        <!-- Broader -> narrower; handle multiple broader relationships -->
        <xsl:for-each-group select="$document//skos:Concept[@rdf:about]/skos:broader[@rdf:resource]" group-by="concat(string(../@rdf:about), '|', string(@rdf:resource))">
			<xsl:sort select="lower-case(string(@rdf:resource))"/>
            <xsl:sort select="lower-case(string(../skos:prefLabel[1]))"/>
            <xsl:text>    "</xsl:text><xsl:value-of select="f:node-id(string(@rdf:resource))"/>
            <xsl:text>" -&gt; "</xsl:text><xsl:value-of select="f:node-id(string(../@rdf:about))"/>
            <xsl:text>";&#10;</xsl:text>
         </xsl:for-each-group>
        <!-- Scheme -> top concept, whether expressed as topConceptOf or hasTopConcept -->
       <xsl:for-each-group select="$document//skos:Concept[@rdf:about][skos:topConceptOf/@rdf:resource or parent::skos:hasTopConcept]" group-by="string(@rdf:about)">
			<xsl:sort select="lower-case(string(skos:prefLabel[1]))"/>
            <xsl:variable name="scheme" select="string((skos:topConceptOf/@rdf:resource, parent::skos:hasTopConcept/parent::skos:ConceptScheme/@rdf:about)[1])"/>
            <xsl:if test="$scheme != ''">
				<xsl:text>    "</xsl:text><xsl:value-of select="f:node-id($scheme)"/>
                <xsl:text>" -&gt; "</xsl:text><xsl:value-of select="f:node-id(string(@rdf:about))"/>
                <xsl:text>";&#10;</xsl:text>
            </xsl:if>
        </xsl:for-each-group>
    </xsl:template>

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
                <xsl:text>digraph Diagram {&#10;</xsl:text>
                <xsl:text>     rankdir=LR; ordering=out; concentrate=true; splines=polyline; nodesep=0.1; ranksep=0.5;&#10;</xsl:text>
                <xsl:text>     graph [label=&lt;&lt;table border="0" cellborder="0" cellspacing="0">&lt;tr>&lt;td align="left">&lt;font point-size="14">&lt;b></xsl:text>
                <xsl:value-of select="f:format-title($rdf-name)"/>
                <xsl:text>&lt;/b&gt;&lt;/font&gt;&lt;/td&gt;&lt;/tr&gt;&lt;tr&gt;&lt;td align="left"&gt;&lt;font point-size="10"></xsl:text>
                <xsl:text>Generated at: </xsl:text>
                <xsl:value-of select="format-dateTime(current-dateTime(), '[H01]:[m01]:[s01], [D01] [MNn] [Y0001]')"/>
                <xsl:text>&lt;/font&gt;&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&gt;</xsl:text>
                <xsl:text>, labelloc=t, labeljust=l, fontname="Arial", fontsize=14, fontcolor="#333333", pad=0.3];&#10;</xsl:text>
                <xsl:text>     edge [color="#666666", penwidth=0.3, arrowsize=0.7,  tailport=e,  headport=w];&#10;</xsl:text>
                <xsl:if test="count($document//skos:ConceptScheme)=0"> <!-- An ontology -->
					<xsl:call-template name="outputontology"><xsl:with-param name="document" select="$document"/></xsl:call-template>
                </xsl:if>
                <xsl:if test="count($document//skos:ConceptScheme)>0"> <!-- A taxonomy -->
					<xsl:call-template name="outputtaxonomy"><xsl:with-param name="document" select="$document"/></xsl:call-template>
                </xsl:if>
                <xsl:text>}</xsl:text>
             </xsl:result-document> 
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>