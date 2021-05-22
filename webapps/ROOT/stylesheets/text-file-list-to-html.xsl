<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="response" mode="text-index">
    <table class="tablesorter">
      <thead>
        <tr>
          <!-- Let us assume that all texts have a filename, ID, and
               title. -->
          <!--<th>Filename</th>-->
          <th style="width:7em">N. PPRET</th>
          <th style="width:18.5em">Inscription</th>
          <!--<xsl:if test="result/doc/arr[@name='edition']/str">
            <th>Editions</th>
          </xsl:if>-->
          <xsl:if test="result/doc/arr[@name='prefect_name']/str">
            <th style="width:10.5em">Praetorian prefect</th>
          </xsl:if>
          <xsl:if test="result/doc/str[@name='PLRE']!=''">
            <th style="width:5em">PLRE</th>
          </xsl:if>
          <xsl:if test="result/doc/str[@name='emperors_and_their_prefects']">
            <th style="width:22em">Emperors and their prefects</th>
          </xsl:if>
          <xsl:if test="result/doc/str[@name='date']">
            <th style="width:7em">Date</th>
          </xsl:if>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates mode="text-index" select="result" />
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="result[not(doc)]" mode="text-index">
    <p>There are no files indexed from
    webapps/ROOT/content/xml/<xsl:value-of select="$document_type" />!
    Put some there, index them from the admin page, and this page will
    become much more interesting.</p>
  </xsl:template>

  <xsl:template match="result/doc" mode="text-index">
    <tr>
      <!--<xsl:apply-templates mode="text-index" select="str[@name='file_path']" />-->
      <xsl:apply-templates mode="text-index" select="str[@name='document_id']" />
      <xsl:apply-templates mode="text-index" select="arr[@name='document_title']" />
      <!--<xsl:apply-templates mode="text-index" select="arr[@name='edition']" />-->
      <xsl:apply-templates mode="text-index" select="arr[@name='prefect_name']" />
      <xsl:if test="str[@name='PLRE']!=''"><xsl:apply-templates mode="text-index" select="str[@name='PLRE']" /></xsl:if>
      <xsl:apply-templates mode="text-index" select="str[@name='emperors_and_their_prefects']" />
      <xsl:apply-templates mode="text-index" select="str[@name='date']" />
    </tr>
  </xsl:template>

  <!--<xsl:template match="str[@name='file_path']" mode="text-index">
    <xsl:variable name="filename" select="substring-after(., '/')" />
    <td>
      <a href="{kiln:url-for-match($match_id, ($language, $filename), 0)}">
        <xsl:value-of select="$filename" />
      </a>
    </td>
  </xsl:template>-->

  <xsl:template match="str[@name='document_id']" mode="text-index">
    <xsl:variable name="filename" select="substring-after(../str[@name='file_path'], '/')" />
    <td><a href="{kiln:url-for-match($match_id, ($language, $filename), 0)}"><xsl:value-of select="." /></a></td>
  </xsl:template>
  

  <xsl:template match="arr[@name='document_title']" mode="text-index">
    <td><xsl:value-of select="string-join(str, '; ')" /></td>
  </xsl:template>
  
  <!--<xsl:template match="arr[@name='edition']" mode="text-index">
    <td><xsl:value-of select="string-join(str, '; ')" /></td>
  </xsl:template>-->
  
  <xsl:template match="arr[@name='prefect_name']" mode="text-index">
    <td><xsl:value-of select="string-join(str, '; ')" /></td>
  </xsl:template>
  
  <xsl:template match="str[@name='PLRE']" mode="text-index">
    <td><xsl:value-of select="." /></td>
  </xsl:template>
  
  <xsl:template match="str[@name='emperors_and_their_prefects']" mode="text-index">
    <td><xsl:value-of select="." /></td>
  </xsl:template>
  
  <xsl:template match="str[@name='date']" mode="text-index">
    <td><xsl:value-of select="." /></td>
  </xsl:template>

</xsl:stylesheet>
