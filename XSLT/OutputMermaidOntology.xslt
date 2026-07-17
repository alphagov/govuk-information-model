<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    exclude-result-prefixes="rdf rdfs owl">

    <xsl:output method="text" encoding="UTF-8"/>

    <!-- Extract local name after # or final / -->
    <xsl:template name="local-name-from-uri">
        <xsl:param name="uri"/>
        <xsl:choose>
            <xsl:when test="contains($uri, '#')">
                <xsl:value-of select="substring-after($uri, '#')"/>
            </xsl:when>
            <xsl:when test="contains($uri, '/')">
                <xsl:call-template name="last-token">
                    <xsl:with-param name="text" select="$uri"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$uri"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Recursive helper to get last token after / -->
    <xsl:template name="last-token">
        <xsl:param name="text"/>
        <xsl:choose>
            <xsl:when test="contains($text, '/')">
                <xsl:call-template name="last-token">
                    <xsl:with-param name="text" select="substring-after($text, '/')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Make safe Mermaid node IDs -->
    <xsl:template name="safe-id">
        <xsl:param name="text"/>
        <xsl:value-of select="translate($text, ' -.:/()[]{}&amp;#', '_____________')"/>
    </xsl:template>

    <xsl:template match="/"> 
        <xsl:text>flowchart TD&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>

        <!-- Declare class nodes -->
        <xsl:for-each select="//owl:Class[@rdf:about]">
			<xsl:if test="//owl:Class[contains(@rdf:about, 'Taxonomy')]"> <!-- Add if to not expand Taxonomy class -->
 				<xsl:variable name="uri" select="@rdf:about"/>
				<xsl:variable name="label">
					<xsl:call-template name="local-name-from-uri">
						<xsl:with-param name="uri" select="$uri"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="id">
					<xsl:call-template name="safe-id">
						<xsl:with-param name="text" select="$label"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:text>    </xsl:text>
				<xsl:value-of select="$id"/>
				<xsl:text>["</xsl:text>
				<xsl:value-of select="$label"/>
				<xsl:text>"]&#10;</xsl:text>
			</xsl:if><!-- Add if to not expand Taxonomy class -->
        </xsl:for-each>

        <xsl:text>&#10;</xsl:text>

        <!-- subclass relationships -->
        <xsl:for-each select="//owl:Class[@rdf:about]/rdfs:subClassOf[@rdf:resource]">
            <xsl:variable name="childUri" select="../@rdf:about"/>]
            <xsl:variable name="parentUri" select="@rdf:resource"/>

            <xsl:variable name="childLabel">
                <xsl:call-template name="local-name-from-uri">
                    <xsl:with-param name="uri" select="$childUri"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="parentLabel">
                <xsl:call-template name="local-name-from-uri">
                    <xsl:with-param name="uri" select="$parentUri"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="childId">
                <xsl:call-template name="safe-id">
                    <xsl:with-param name="text" select="$childLabel"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="parentId">
                <xsl:call-template name="safe-id">
                    <xsl:with-param name="text" select="$parentLabel"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:text>    </xsl:text>
            <xsl:value-of select="$parentId"/>
            <xsl:text> --> </xsl:text>
            <xsl:value-of select="$childId"/>
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>

        <xsl:text>&#10;</xsl:text>

        <!-- object properties -->
        <xsl:for-each select="//owl:ObjectProperty[@rdf:about]">
            <xsl:variable name="propUri" select="@rdf:about"/>
            <xsl:variable name="propLabel">
                <xsl:call-template name="local-name-from-uri">
                    <xsl:with-param name="uri" select="$propUri"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="domainUri" select="rdfs:domain/@rdf:resource"/>
            <xsl:variable name="rangeUri" select="rdfs:range/@rdf:resource"/>

            <xsl:if test="$domainUri and $rangeUri">
                <xsl:variable name="domainLabel">
                    <xsl:call-template name="local-name-from-uri">
                        <xsl:with-param name="uri" select="$domainUri"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="rangeLabel">
                    <xsl:call-template name="local-name-from-uri">
                        <xsl:with-param name="uri" select="$rangeUri"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="domainId">
                    <xsl:call-template name="safe-id">
                        <xsl:with-param name="text" select="$domainLabel"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="rangeId">
                    <xsl:call-template name="safe-id">
                        <xsl:with-param name="text" select="$rangeLabel"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:text>    </xsl:text>
                <xsl:value-of select="$domainId"/>
                <xsl:text> -->|</xsl:text>
                <xsl:value-of select="$propLabel"/>
                <xsl:text>| </xsl:text>
                <xsl:value-of select="$rangeId"/>
                <xsl:text>&#10;</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>