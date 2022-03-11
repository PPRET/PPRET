<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of TEI documents into a Solr index document. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:persName[ancestor::tei:div/@type='edition']" group-by=".">
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:variable name="pers-id" select="substring-after(@ref,'#')"/>
            <xsl:variable name="person-id" select="document('../../content/xml/authority/listPerson.xml')//tei:person[@xml:id=$pers-id]/tei:persName"/>
            <xsl:choose>
              <xsl:when test="@ref ">
                <xsl:choose>
                  <xsl:when test="$person-id"><xsl:value-of select="$person-id" /></xsl:when>
                  <xsl:otherwise><xsl:value-of select="$pers-id" /></xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:when test="@key and not(@ref)"><xsl:value-of select="@key" /></xsl:when>
              <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
            </xsl:choose>
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:persName">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
