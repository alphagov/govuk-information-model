<?xml version="1.0" encoding="UTF-8"?>

<!-- ************************************************************************************************************************ -->	
<!-- This script is used to validate the details in an ontology (.rdf file)                                                           -->	
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
		<html>
			<head>
			<style>
			body {margin: 0; font-family: Arial, sans-serif; font-size: 10px; line-height: 1.5; color: #0b0c0c; background: #ffffff; }
			.govuk-width-container {max-width: 960px; margin: 0 auto; padding: 0 30px; }
			.govuk-header {background: #0b0c0c; color: white; padding: 10px 0; border-bottom: 10px solid #1d70b8;}
			.govuk-header a {color: white; text-decoration: none; font-weight: bold; font-size: 30px;}
			.govuk-main-wrapper {padding: 40px 0;}
			h1 {font-size: 24px;line-height: 1.0;margin: 0px 0px 10px 0px;}
			h2 { font-size: 18px; line-height: 1.0; margin: 10px 0px 0px 0px;}
			h3 { font-size: 14px; line-height: 1.0; margin: 1px 0 1px 0;}
			p { margin: 0 0 0px 0; font-size: 12px;}
			a { color: #1d70b8; text-decoration: underline;}
			a:hover { color: #003078;}
			hr { border: 0; height: 1px; background: #b1b4b6; margin: 5px 0;}
			.govuk-button { display: inline-block; background: #00703c; color: white; padding: 8px 15px 7px; border: 0; box-shadow: 0 2px 0 #002d18; font-size: 19px; line-height: 1.5; text-decoration: none; cursor: pointer;}
			.govuk-button:hover { background: #005a30;}
			.govuk-table { width: 100%; border-collapse: collapse; margin-bottom: 30px;}
			.govuk-table th,.govuk-table td { border-bottom: 1px solid #b1b4b6; padding: 10px 20px 10px 0; text-align: left;}
			.govuk-inset-text { border-left: 10px solid #b1b4b6; padding: 15px; margin: 30px 0;}
			.govuk-panel { background: #1d70b8; color: white; padding: 35px;  text-align: center;}			
			.govuk-body { font-family: Arial, sans-serif;  font-size: 19px; line-height: 1.5; color: #0b0c0c; margin-top: 0; margin-bottom: 20px;}			
	</style>
			<title></title>
			</head>
			<body>
				
			<h1>Ontology Validation Report</h1>
			<p>
				Report generated <xsl:value-of select="format-dateTime(current-dateTime(),'[D01]/[M01]/[Y0001] ')"/><xsl:value-of select="format-dateTime(current-dateTime(),'at [H01]:[m01]')"/>
			</p>
			<hr class="flat-hr"/>
	
			<!-- ======================================================================= -->	
			<h2>Missing xml:lang attribute</h2>
			<p>
			<xsl:value-of select="count(//rdfs:label[not(@xml:lang)])"/> occurences<br/>
			<xsl:for-each select="//rdfs:label[not(@xml:lang)]">
				<xsl:value-of select="."/>
				<br/>
			</xsl:for-each>
			</p>
	
			<!-- ======================================================================= -->	
			<h2>Missing en-gb or cy from xml:lang</h2>
			<p>
				<xsl:value-of select="count(//rdfs:label[not(@xml:lang='en-gb') and not(@xml:lang='cy')])"/> occurences<br/>
				<xsl:for-each select="//rdfs:label[not(@xml:lang='en-gb') and not(@xml:lang='cy')]">
					<xsl:value-of select="."/>
					<br/>
				</xsl:for-each>
			</p>
			
			<!-- ======================================================================= -->	
			<h2>Incorrect owl:someValuesFrom</h2>
			<p>
				<xsl:value-of select="count(//owl:someValuesFrom/../../../@rdf:about)"/> occurences<br/>
				<xsl:for-each select="//owl:someValuesFrom/../../../@rdf:about">
					<xsl:value-of select="."/>
					<br/>
				</xsl:for-each>
			</p>	

			<!-- ======================================================================= -->	
			<h2>Missing data type</h2>
			<p>
			<xsl:value-of select="count(//owl:Class[@rdf:about and not(.//*[contains(@rdf:resource, '#hasDatatype')]) and count(//*[@rdf:about = current()/@rdf:about]) lt 2 and count(//*[@rdf:resource = current()/@rdf:about]) lt 2])"/> occurences<br/>
			<xsl:for-each select="//owl:Class[@rdf:about and not(.//*[contains(@rdf:resource, '#hasDatatype')]) and count(//*[@rdf:about = current()/@rdf:about]) lt 2 and count(//*[@rdf:resource = current()/@rdf:about]) lt 2]">
				<xsl:value-of select="@rdf:about"/>
				<br/>
			</xsl:for-each>
			</p>				
		
			<!-- ======================================================================= -->	
			<h2>Object not Pascal Case</h2>
			<p>
				<xsl:value-of select="count(//owl:Class[@rdf:about and not(matches(substring-after(@rdf:about, '#'), '^[A-Z][A-Za-z0-9]*$'))])"/> occurences<br/>
				<xsl:for-each select="//owl:Class[@rdf:about and not(matches(substring-after(@rdf:about, '#'), '^[A-Z][A-Za-z0-9]*$'))]">
						<xsl:value-of select="."/>
					<br/>
				</xsl:for-each>		
			</p>	

			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>