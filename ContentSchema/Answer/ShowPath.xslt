<?xml version="1.0" encoding="UTF-8"?>

<!-- ************************************************************************************************************************ -->	
<!--                                                                                                                                                        -->	
<!-- ************************************************************************************************************************ -->	

<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:f="urn:functions">

	<!-- ************************************************************************************************************************ -->	
		<xsl:function name="f:make-pascal-case" as="xs:string">
		<xsl:param name="s" as="xs:string"/>
		<xsl:sequence select="string-join(for $part in tokenize($s, '[/_]')	return concat(upper-case(substring($part, 1, 1)), lower-case(substring($part, 2))),'')"/> 
	</xsl:function>
	
	<!-- ============================================================================ -->	
	<xsl:function name="f:output-node-annotation" as="xs:string">
		<xsl:param name="parent" as="element()"/>
		<xsl:param name="tag" as="xs:string"/>
		<xsl:param name="tagname" as="xs:string"/>
		<xsl:variable name="value" select="string(($parent/*[local-name() = $tag])[1])"/>
		<xsl:sequence select="if (string-length($value) gt 0) then concat('&lt;',$tagname,'&gt;',f:remove-escape-characters($value),'&lt;/',$tagname,'&gt;','&#10;') else ''"/>
	</xsl:function>
	
	<!-- ============================================================================ -->	
	<xsl:function name="f:output-node-list-annotation" as="xs:string">
		<xsl:param name="parent" as="element()"/>
		<xsl:param name="tag" as="xs:string"/>
		<xsl:param name="tagname" as="xs:string"/>
		<xsl:variable name="value">
			<xsl:for-each select="$parent/*[local-name() = $tag]">
				<xsl:value-of select="."/>;
			</xsl:for-each>		
		</xsl:variable>
		<xsl:sequence select="if (string-length($value) gt 0) then concat('&lt;',$tagname,'&gt;',f:remove-escape-characters($value),'&lt;/',$tagname,'&gt;','&#10;')	else ''"/>
	</xsl:function>

	<!-- ============================================================================ -->	
	<xsl:function name="f:output-subnode-list-annotation" as="xs:string">
		<xsl:param name="parent" as="element()"/>
		<xsl:param name="tag" as="xs:string"/>
		<xsl:param name="tagname" as="xs:string"/>
		<xsl:variable name="value">
			<xsl:for-each select="($parent/*[local-name() = $tag])/*">
				<xsl:value-of select="local-name()"/>=<xsl:value-of select="."/>;
			</xsl:for-each>		
		</xsl:variable>
		<xsl:sequence select="if (string-length($value) gt 0) then concat('&lt;',$tagname,'&gt;',f:remove-escape-characters($value),'&lt;/',$tagname,'&gt;','&#10;') else ''"/>
	</xsl:function>
	
	<!-- ============================================================================ -->	
	<xsl:function name="f:remove-escape-characters" as="xs:string">
		<xsl:param name="s" as="xs:string?"/>
		<xsl:if test="contains($s,':')">
			<xsl:sequence select="concat(replace(replace($s, '&amp;', '&amp;amp;'),':',''),' [Note: colons removed to fix Protege bug]')"/>
		</xsl:if>
		<xsl:if test="not(contains($s,':'))">
			<xsl:sequence select="replace($s, '&amp;', '&amp;amp;')"/>
		</xsl:if>
	</xsl:function>
	
	<!-- ************************************************************************************************************************ -->	
	
	<xsl:output method="text" encoding="UTF-8"/>
		<xsl:template match="/files">
		<xsl:result-document href="C:\Users\marcs\OneDrive\Desktop\Work\GDS\Ontologies\GithubJSON\ContentTypes\Answer\all-schemas.rdf" method="text" encoding="UTF-8">
		
			<!-- Ontology Header -->	
			<xsl:text>&lt;?xml version="1.0"?>&#10;</xsl:text>			
			<xsl:text>&lt;rdf:RDF xmlns="http://www.gov.uk/IA/Ontology/ContentType#"&#10;</xsl:text>
			<xsl:text>xml:base="http://www.gov.uk/IA/Ontology/ContentType"&#10;</xsl:text>
			<xsl:text>xmlns:gds="http://www.gov.uk/IA/Ontology#"&#10;</xsl:text>
			<xsl:text>xmlns:dc="http://purl.org/dc/elements/1.1/"&#10;</xsl:text>
			<xsl:text>xmlns:owl="http://www.w3.org/2002/07/owl#"&#10;</xsl:text>
			<xsl:text>xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"&#10;</xsl:text>
			<xsl:text>xmlns:xml="http://www.w3.org/XML/1998/namespace"&#10;</xsl:text>
			<xsl:text>xmlns:xsd="http://www.w3.org/2001/XMLSchema#"&#10;</xsl:text>
			<xsl:text>xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">&#10;&#10;</xsl:text>
			<xsl:text>&lt;owl:Ontology rdf:about="http://www.gov.uk/IA/Ontology/ContentType">&#10;</xsl:text>
			<xsl:text>&#9;&lt;owl:versionIRI rdf:resource="http://www.gov.uk/IA/Ontology/ContentType"/>&#10;</xsl:text>
			<xsl:text>&lt;/owl:Ontology>&#10;&#10;</xsl:text>
			<!-- Annotations -->	
			<xsl:text>&lt;owl:AnnotationProperty rdf:about="http://www.gov.uk/IA/Ontology#pattern"/>&#10;&#10;</xsl:text>  <!-- ********* -->  
			<xsl:for-each select="file">
				<xsl:apply-templates select="doc(@href)" mode="process-file">
					<xsl:with-param name="object" select="@object"/>
				</xsl:apply-templates>
			</xsl:for-each>
			<xsl:text>&lt;/rdf:RDF>&#10;</xsl:text>
		</xsl:result-document>
	</xsl:template>	

	<xsl:template match="/" mode="process-file">
		<xsl:param name="object" as="xs:string?"/>
		<!-- Root Class -->	
		<xsl:text>&lt;owl:Class rdf:about="http://www.gov.uk/IA/Ontology/ContentType/</xsl:text><xsl:value-of select="$object"/><xsl:text>">&#10;</xsl:text>
        <xsl:text>&#9;&lt;gds:inputfile xml:lang="en-gb"></xsl:text><xsl:value-of select="tokenize(document-uri(.), '/')[last()]"/><xsl:text>&lt;/gds:inputfile>&#10;</xsl:text>
        <xsl:text>&#9;&lt;rdfs:subClassOf rdf:resource="http://www.gov.uk/IA/Ontology#ContentType"/>&#10;</xsl:text>
        <xsl:text>&#9;&lt;dc:creator>Marc Stephenson&lt;/dc:creator>&#10;</xsl:text>
        <xsl:text>&#9;&lt;dc:date rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">2025-12-15T10:16:57Z&lt;/dc:date>&#10;</xsl:text>
        <xsl:text>&#9;&lt;rdfs:label xml:lang="en-gb"></xsl:text><xsl:value-of select="$object"/><xsl:text>&lt;/rdfs:label>&#10;</xsl:text>
        <xsl:text>&#9;&lt;gds:schema xml:lang="en-gb"></xsl:text><xsl:value-of select="//json/schema"/><xsl:text>&lt;/gds:schema>&#10;</xsl:text>
		<xsl:text>&lt;/owl:Class>&#10;&#10;</xsl:text>

		<!-- Simple subclasses -->	
		<xsl:for-each select="(/json/properties/*/ref)/.. | (/json/properties/*/type[contains(.,'string')])/.. | (/json/definitions/*/type[contains(.,'string')])/..">
			<xsl:variable name="path" select="replace(f:make-pascal-case(string-join(ancestor-or-self::*/name(), '/')),'Json','')"/>
			<xsl:text>&lt;owl:Class rdf:about="http://www.gov.uk/IA/Ontology/ContentType/</xsl:text><xsl:value-of select="$object"/><xsl:text>#</xsl:text><xsl:value-of select="$path"/>	<xsl:text>">&#10;</xsl:text>
			<xsl:text>&#9;&lt;dc:creator>Marc Stephenson via script&lt;/dc:creator>&#10;</xsl:text>
			<xsl:text>&#9;&lt;gds:sourcenode></xsl:text><xsl:value-of select="string-join(ancestor-or-self::*/name(), '/')"/><xsl:text>&lt;/gds:sourcenode>&#10;</xsl:text>
			<xsl:text>&#9;</xsl:text><xsl:value-of select="f:output-node-annotation(.,'description', 'gds:description')"/>
			<xsl:text>&#9;</xsl:text><xsl:value-of select="f:output-node-annotation(.,'pattern', 'gds:pattern')"/>
			<xsl:text>&#9;</xsl:text><xsl:value-of select="f:output-node-annotation(.,'type', 'gds:type')"/>
			<xsl:text>&#9;</xsl:text><xsl:value-of select="f:output-node-annotation(.,'ref', 'gds:ref')"/>
			<xsl:text>&#9;</xsl:text><xsl:value-of select="f:output-node-annotation(.,'format', 'gds:format')"/>
			<xsl:text>&#9;</xsl:text><xsl:value-of select="f:output-node-annotation(.,'maxitems', 'gds:maxitems')"/>
			<xsl:text>&#9;</xsl:text><xsl:value-of select="f:output-node-list-annotation(.,'enum', 'gds:enum')"/>
			<xsl:text>&lt;rdfs:subClassOf rdf:resource="http://www.gov.uk/IA/Ontology/ContentType/</xsl:text><xsl:value-of select="$object"/><xsl:text>"/>&#10;</xsl:text>
			<xsl:text>&lt;/owl:Class>&#10;&#10;</xsl:text>
		</xsl:for-each>		

		<!-- Complex subclasses -->	
		<xsl:for-each select="(/json/properties/*/anyOf[1])/.. | (/json/definitions/*/anyOf[1])/.. | (/json/properties/*/oneOf[1])/.. | (/json/definitions/*/oneOf[1])/..">
			<xsl:variable name="path" select="replace(f:make-pascal-case(string-join(ancestor-or-self::*/name(), '/')),'Json','')"/>
			<xsl:text>&lt;owl:Class rdf:about="http://www.gov.uk/IA/Ontology/ContentType/</xsl:text><xsl:value-of select="$object"/><xsl:text>#</xsl:text><xsl:value-of select="$path"/><xsl:text>">&#10;</xsl:text>
			<xsl:text>&#9;&lt;dc:creator>Marc Stephenson via script&lt;/dc:creator>&#10;</xsl:text>
			<xsl:text>&#9;&lt;gds:sourcenode></xsl:text><xsl:value-of select="string-join(ancestor-or-self::*/name(), '/')"/><xsl:text>&lt;/gds:sourcenode>&#10;</xsl:text>
			<xsl:value-of select="f:output-subnode-list-annotation(.,'anyOf', 'gds:anyof')"/>
			<xsl:value-of select="f:output-subnode-list-annotation(.,'oneOf', 'gds:oneof')"/>
			<xsl:text>&lt;rdfs:subClassOf rdf:resource="http://www.gov.uk/IA/Ontology/ContentType/</xsl:text><xsl:value-of select="$object"/><xsl:text>"/>&#10;</xsl:text>
			<xsl:text>&lt;/owl:Class>&#10;&#10;</xsl:text>
		</xsl:for-each>		
		
		<!-- Attach (sub-class) definitions to properties -->	
		<xsl:for-each select="(/json/properties/*/ref)/.. | (/json/properties/*/type[contains(.,'string')])/..">
			<xsl:variable name="path" select="replace(f:make-pascal-case(string-join(ancestor-or-self::*/name(), '/')),'Json','')"/>
			<xsl:variable name="refdef" select="tokenize(., '/')[last()]"/>
			<xsl:variable name="defnode" select="concat('definitions/',$refdef)"/>
			<xsl:text>&lt;owl:Class rdf:about="http://www.gov.uk/IA/Ontology/ContentType/</xsl:text><xsl:value-of select="$object"/><xsl:text>#</xsl:text><xsl:value-of select="$path"/><xsl:text>">&#10;</xsl:text>
			<xsl:text>&lt;rdfs:subClassOf rdf:resource="http://www.gov.uk/IA/Ontology/ContentType/</xsl:text><xsl:value-of select="$object"/><xsl:text>#</xsl:text><xsl:value-of select="f:make-pascal-case($defnode)"/><xsl:text>"/></xsl:text><xsl:text>&#10;</xsl:text>
			<xsl:text>&lt;/owl:Class>&#10;&#10;</xsl:text>
		</xsl:for-each>		
		
    </xsl:template>
</xsl:stylesheet>