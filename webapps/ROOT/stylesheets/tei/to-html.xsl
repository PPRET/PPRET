<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Project-specific XSLT for transforming TEI to
       HTML. Customisations here override those in the core
       to-html.xsl (which should not be changed). -->

  <xsl:import href="../../kiln/stylesheets/tei/to-html.xsl" />
  
  <xsl:template match="//tei:foreign">
    <i><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="//tei:head[not(@type)]">
    <h2><xsl:apply-templates/></h2>
  </xsl:template>
  
  <xsl:template match="//tei:head[@type='subheading']">
    <h3><xsl:apply-templates/></h3>
  </xsl:template>
  
  <xsl:template match="//tei:div//tei:title">
    <i><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="//tei:listBibl/tei:bibl">
    <p><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="//tei:p/tei:bibl">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="//tei:p//tei:ref[not(@corresp)]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="//tei:listPerson">
    <div><xsl:apply-templates/></div>
  </xsl:template>
  
  <xsl:template match="//tei:person[ancestor::tei:listPerson]">
    <div><xsl:apply-templates/></div>
  </xsl:template>
  
  <xsl:template match="//tei:idno[not(@type='PPO')][ancestor::tei:person]">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="//tei:idno[@type='PPO'][ancestor::tei:person]">
    <p><strong><xsl:apply-templates/></strong></p>
  </xsl:template>
  
  <xsl:template match="//tei:persName[ancestor::tei:listPerson]">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="//tei:floruit[ancestor::tei:person]">
    <p>Floruit: <xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="//tei:occupation[ancestor::tei:person]">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="//tei:birth[ancestor::tei:person]">
    <p>Birth: <xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="//tei:death[ancestor::tei:person]">
    <p>Death: <xsl:apply-templates/></p>
  </xsl:template>
  
  <!--<xsl:template match="//tei:emph">
    <span class="bibl"><xsl:apply-templates/></span>
  </xsl:template>-->
  
  <xsl:template match="//tei:emph">
    <strong><xsl:apply-templates/></strong>
  </xsl:template>
  
  <xsl:template match="//tei:item[ancestor::tei:list]">
    <ul><xsl:attribute name="class"><xsl:value-of select="'info'"/></xsl:attribute><xsl:apply-templates/></ul>
  </xsl:template>
  
  <xsl:template match="//tei:ptr[@target]">
    <a target="_blank"><xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute><xsl:value-of select="@target"/></a>
  </xsl:template>
  
  <xsl:template match="//tei:div//tei:ref[@target][not(@corresp)]">
    <xsl:variable name="bibl-id" select="substring-after(@target,'#')"/>
    <xsl:choose>
      <xsl:when test="$bibl-id!=''"><a><xsl:attribute name="href"><xsl:value-of select="concat('./bibliography.html#',$bibl-id)"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a></xsl:when>
      <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:div//tei:ref[@corresp]">
    <xsl:choose>
      <xsl:when test="@type='ppret'">
        <a><xsl:attribute name="href"><xsl:value-of select="concat('../inscriptions/',@corresp,'.html')"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a>
      </xsl:when>
      <xsl:when test="@type='ppo'">
        <a><xsl:attribute name="href"><xsl:value-of select="concat('./',@corresp,'.html')"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a>
      </xsl:when>
      <xsl:otherwise>
        <a><xsl:attribute name="href"><xsl:value-of select="@corresp"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
