<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
  xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../kiln/stylesheets/solr/tei-to-solr.xsl" />
  
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Oct 18, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> jvieira</xd:p>
      <xd:p>This stylesheet converts a TEI document into a Solr index document. It expects the parameter file-path,
        which is the path of the file being indexed.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:template match="/">
    <add>
      <xsl:apply-imports />
    </add>
  </xsl:template>
  
  <!-- This template is called by the Kiln tei-to-solr.xsl as part of
       the main doc for the indexed file. Put any code to generate
       additional Solr field data (such as new facets) here. -->
  
  <xsl:template match="tei:publicationStmt/tei:idno[@n]" mode="facet_PLRE">
    <field name="PLRE">
      <xsl:choose>
        <xsl:when test="@n='new'"><xsl:text>NEW</xsl:text></xsl:when>
        <xsl:when test="@n='plre'"><xsl:text>PLRE I</xsl:text></xsl:when>
        <xsl:when test="@n='rev'"><xsl:text>REV</xsl:text></xsl:when>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:textLang" mode="facet_language">
    <field name="language">
      <xsl:choose>
        <xsl:when test="@mainLang='la'">Latin</xsl:when>
        <xsl:when test="@mainLang='grc'">Greek</xsl:when>
        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:summary/tei:term[@type='textType']" mode="facet_text_category">
    <xsl:variable name="cat-id" select="substring-after(@ref,'#')"/>
    <xsl:variable name="category-id" select="document('../../content/xml/authority/texttype.xml')//tei:item[@xml:id=$cat-id]/tei:term[@xml:lang='en']"/>
    <field name="text_category">
      <xsl:choose>
        <xsl:when test="$category-id"><xsl:value-of select="$category-id" /></xsl:when>
        <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:handNote/tei:term" mode="facet_palaeography">
    <xsl:variable name="scr-id" select="substring-after(@ref,'#')"/>
    <xsl:variable name="script-id" select="document('../../content/xml/authority/script.xml')//tei:item[@xml:id=$scr-id]/tei:term[@xml:lang='en']"/>
    <field name="palaeography">
      <xsl:choose>
        <xsl:when test="$script-id"><xsl:value-of select="$script-id" /></xsl:when>
        <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:layout/tei:rs[@type='execution']" mode="facet_technique">
    <xsl:variable name="ex-id" select="substring-after(@ref,'#')"/>
    <xsl:variable name="execution-id" select="document('../../content/xml/authority/technique.xml')//tei:item[@xml:id=$ex-id]/tei:term[@xml:lang='en']"/>
    <field name="technique">
      <xsl:choose>
        <xsl:when test="$execution-id"><xsl:value-of select="$execution-id" /></xsl:when>
        <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:layout/tei:rs[@type='preservation']" mode="facet_epigraphic_field_preservation">
    <xsl:variable name="pres-id" select="substring-after(@ref,'#')"/>
    <xsl:variable name="preservation-id" select="document('../../content/xml/authority/preservation.xml')//tei:item[@xml:id=$pres-id]/tei:term[@xml:lang='en']"/>
    <field name="epigraphic_field_preservation">
      <xsl:choose>
        <xsl:when test="$preservation-id"><xsl:value-of select="$preservation-id" /></xsl:when>
        <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:summary/tei:term[@type='rhythm']" mode="facet_rhythm">
    <xsl:variable name="rhy-id" select="tokenize(replace(@ref,'#',''),' ')"/>
    <xsl:variable name="rhythm1-id" select="document('../../content/xml/authority/rhythm.xml')//tei:item[@xml:id=$rhy-id[1]]/tei:term[@xml:lang='en']"/>
    <xsl:variable name="rhythm2-id" select="document('../../content/xml/authority/rhythm.xml')//tei:item[@xml:id=$rhy-id[2]]/tei:term[@xml:lang='en']"/>
    <xsl:if test="$rhythm1-id"><field name="rhythm"><xsl:value-of select="$rhythm1-id" /></field></xsl:if>
    <xsl:if test="$rhythm2-id"><field name="rhythm"><xsl:value-of select="$rhythm2-id" /></field></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:support/tei:rs[@type='inscribed_field_reuse']" mode="facet_inscribed_field_reuse">
    <field name="inscribed_field_reuse">
      <xsl:choose>
        <xsl:when test="starts-with(lower-case(.), 'yes')">Yes</xsl:when>
        <xsl:when test="starts-with(lower-case(.), 'no')">No</xsl:when>
        <xsl:when test="starts-with(lower-case(.), 'uncertain')">Uncertain</xsl:when>
        <xsl:when test="starts-with(lower-case(.), 'unknown')">Unknown</xsl:when>
        <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:support/tei:rs[@type='monument_reuse']" mode="facet_monument_reuse">
    <field name="monument_reuse">
      <xsl:choose>
        <xsl:when test="starts-with(lower-case(.), 'yes')">Yes</xsl:when>
        <xsl:when test="starts-with(lower-case(.), 'no')">No</xsl:when>
        <xsl:when test="starts-with(lower-case(.), 'uncertain')">Uncertain</xsl:when>
        <xsl:when test="starts-with(lower-case(.), 'unknown')">Unknown</xsl:when>
        <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:support/tei:rs[@type='opistographic']" mode="facet_opistographic">
    <field name="opistographic">
      <xsl:choose>
        <xsl:when test="starts-with(lower-case(.), 'yes')">Yes</xsl:when>
        <xsl:when test="starts-with(lower-case(.), 'no')">No</xsl:when>
        <xsl:when test="starts-with(lower-case(.), 'uncertain')">Uncertain</xsl:when>
        <xsl:when test="starts-with(lower-case(.), 'unknown')">Unknown</xsl:when>
        <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:sourceDesc/tei:listPerson/tei:person" mode="facet_prefect_name">
    <xsl:variable name="pers-id" select="substring-after(tei:persName/@ref,'#')"/>
    <xsl:variable name="person-id" select="document('../../content/xml/authority/listPerson.xml')//tei:person[@xml:id=$pers-id]/tei:persName"/>
    <field name="prefect_name">
      <xsl:choose>
        <xsl:when test="tei:persName[@ref]"><xsl:value-of select="$person-id"/></xsl:when>
        <xsl:when test="tei:persName[@key][not(@ref)]"><xsl:value-of select="tei:persName/@key"/></xsl:when>
        <xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
    <xsl:if test="tei:persName/tei:name[@type='gentilicium']"><field name="prefect_gentilicium">
      <xsl:value-of select="tei:persName/tei:name[@type='gentilicium']"/>
    </field>
    </xsl:if>
    <xsl:if test="tei:persName/tei:name[@type='cognomen']">
      <field name="prefect_cognomen">
      <xsl:value-of select="tei:persName/tei:name[@type='cognomen']"/>
    </field>
    </xsl:if>
    <xsl:if test="tei:persName/tei:name[@type='signum']">
      <field name="prefect_signum">
      <xsl:value-of select="tei:persName/tei:name[@type='signum']"/>
    </field>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:origPlace/tei:placeName[@type='ancient_location']" mode="facet_ancient_location">
    <xsl:variable name="loc-id" select="substring-after(@ref,'#')"/>
    <xsl:variable name="location-id" select="document('../../content/xml/authority/listPlace.xml')//tei:place[@xml:id=$loc-id]/tei:placeName[@xml:lang='en']"/>
    <field name="ancient_location">
      <xsl:choose>
        <xsl:when test="$location-id"><xsl:value-of select="$location-id" /></xsl:when>
        <xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:origPlace/tei:placeName[@type='modern_city']" mode="facet_modern_city">
    <xsl:variable name="loc-id" select="substring-after(@ref,'#')"/>
    <xsl:variable name="location-id" select="document('../../content/xml/authority/listPlace.xml')//tei:place[@xml:id=$loc-id]/tei:placeName[@xml:lang='en']"/>
    <field name="modern_city">
      <xsl:choose>
        <xsl:when test="$location-id"><xsl:value-of select="$location-id" /></xsl:when>
        <xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:origPlace/tei:placeName[@type='province']" mode="facet_province">
    <xsl:variable name="loc-id" select="substring-after(@ref,'#')"/>
    <xsl:variable name="location-id" select="document('../../content/xml/authority/listPlace.xml')//tei:place[@xml:id=$loc-id]/tei:placeName[@xml:lang='en']"/>
    <field name="province">
      <xsl:choose>
        <xsl:when test="$location-id"><xsl:value-of select="$location-id" /></xsl:when>
        <xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:origPlace/tei:placeName[@type='diocese']" mode="facet_diocese">
    <xsl:variable name="loc-id" select="substring-after(@ref,'#')"/>
    <xsl:variable name="location-id" select="document('../../content/xml/authority/listPlace.xml')//tei:place[@xml:id=$loc-id]/tei:placeName[@xml:lang='en']"/>
    <field name="diocese">
      <xsl:choose>
        <xsl:when test="$location-id"><xsl:value-of select="$location-id" /></xsl:when>
        <xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:origPlace/tei:placeName[@type='prefecture']" mode="facet_regional_prefecture">
    <xsl:variable name="loc-id" select="substring-after(@ref,'#')"/>
    <xsl:variable name="location-id" select="document('../../content/xml/authority/listPlace.xml')//tei:place[@xml:id=$loc-id]/tei:placeName[@xml:lang='en']"/>
    <field name="regional_prefecture">
      <xsl:choose>
        <xsl:when test="$location-id"><xsl:value-of select="$location-id" /></xsl:when>
        <xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:bibl[ancestor::tei:div[@subtype='editions' or @subtype='images' or @subtype='links']]" mode="facet_editions">
    <field name="editions">
      <xsl:apply-templates select="."/>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:bibl[ancestor::tei:div[@subtype='editions']]//tei:ref" mode="facet_edition">
    <field name="edition">
      <xsl:apply-templates select="."/>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:origDate[@precision='high']" mode="facet_dated_inscriptions">
    <field name="dated_inscriptions">
      <xsl:variable name="when-parts" select="tokenize(@when, '-')"/>
      <xsl:variable name="notBefore-parts" select="tokenize(@notBefore, '-')"/>
      <xsl:variable name="notAfter-parts" select="tokenize(@notAfter, '-')"/>
      <xsl:choose>
        <xsl:when test="count($when-parts)=3 or count($when-parts)=2"><xsl:value-of select="concat(number(substring-before(@when,'-')),' AD')" /></xsl:when>
        <xsl:when test="count($when-parts)=1"><xsl:value-of select="concat(number(@when),' AD')" /></xsl:when>
        <xsl:when test="count($notBefore-parts)=3 or count($notBefore-parts)=2">
          <xsl:choose>
            <xsl:when test="count($notAfter-parts)=3 or count($notAfter-parts)=2"><xsl:value-of select="concat(number(substring-before(@notBefore,'-')),'/',number(substring-before(@notAfter,'-')),' AD')" /></xsl:when>
            <xsl:when test="count($notAfter-parts)=1"><xsl:value-of select="concat(number(substring-before(@notBefore,'-')),'/',number(@notAfter),' AD')" /></xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="count($notBefore-parts)=1">
          <xsl:choose>
            <xsl:when test="count($notAfter-parts)=3 or count($notAfter-parts)=2"><xsl:value-of select="concat(number(@notBefore),'/',number(substring-before(@notAfter,'-')),' AD')" /></xsl:when>
            <xsl:when test="count($notAfter-parts)=1"><xsl:value-of select="concat(number(@notBefore),'/',number(@notAfter),' AD')" /></xsl:when>
          </xsl:choose>
        </xsl:when>
       <xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:origDate" mode="facet_date">
    <field name="date">
      <xsl:variable name="when-parts" select="tokenize(@when, '-')"/>
      <xsl:variable name="notBefore-parts" select="tokenize(@notBefore, '-')"/>
      <xsl:variable name="notAfter-parts" select="tokenize(@notAfter, '-')"/>
      <xsl:choose>
        <xsl:when test="count($when-parts)=3 or count($when-parts)=2"><xsl:value-of select="concat(number(substring-before(@when,'-')),' AD')" /></xsl:when>
        <xsl:when test="count($when-parts)=1"><xsl:value-of select="concat(number(@when),' AD')" /></xsl:when>
        <xsl:when test="count($notBefore-parts)=3 or count($notBefore-parts)=2">
          <xsl:choose>
            <xsl:when test="count($notAfter-parts)=3 or count($notAfter-parts)=2"><xsl:value-of select="concat(number(substring-before(@notBefore,'-')),'/',number(substring-before(@notAfter,'-')),' AD')" /></xsl:when>
            <xsl:when test="count($notAfter-parts)=1"><xsl:value-of select="concat(number(substring-before(@notBefore,'-')),'/',number(@notAfter),' AD')" /></xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="count($notBefore-parts)=1">
          <xsl:choose>
            <xsl:when test="count($notAfter-parts)=3 or count($notAfter-parts)=2"><xsl:value-of select="concat(number(@notBefore),'/',number(substring-before(@notAfter,'-')),' AD')" /></xsl:when>
            <xsl:when test="count($notAfter-parts)=1"><xsl:value-of select="concat(number(@notBefore),'/',number(@notAfter),' AD')" /></xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:div[@subtype='prefects']//tei:p[@n]" mode="facet_number_of_praetorian_prefects">
    <xsl:if test="@n='1.1'"><field name="number_of_praetorian_prefects"><xsl:text>Only one praetorian prefect</xsl:text></field></xsl:if>
    <xsl:if test="@n='1.2'"><field name="number_of_praetorian_prefects"><xsl:text>More than one praetorian prefect</xsl:text></field></xsl:if>
    <xsl:if test="@n='1.3'"><field name="number_of_praetorian_prefects"><xsl:text>All the praetorian prefects in office</xsl:text></field></xsl:if>
    <xsl:if test="@n='1.4'"><field name="number_of_praetorian_prefects"><xsl:text>The mentioned praetorian prefect is not the person addressing or being addressed</xsl:text></field></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:div[@subtype='prefects']//tei:p[@n]|tei:div[@subtype='prefects']//tei:list[@n]" mode="facet_inscriptions_in_honour_of_praetorian_prefects">
    <xsl:if test="@n='2.a'"><field name="inscriptions_in_honour_of_praetorian_prefects"><xsl:text>- Inscriptions in honour of a praetorian prefect</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.b'"><field name="inscriptions_in_honour_of_praetorian_prefects"><xsl:text>- Inscriptions in honour of a praetorian prefect’s relative</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.1'"><field name="inscriptions_in_honour_of_praetorian_prefects"><xsl:text>Made during the praetorian prefecture</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.2'"><field name="inscriptions_in_honour_of_praetorian_prefects"><xsl:text>Made after the end of the praetorian prefecture</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.3'"><field name="inscriptions_in_honour_of_praetorian_prefects"><xsl:text>Made after the praetorian prefect’s death (not epitaphs)</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.4'"><field name="inscriptions_in_honour_of_praetorian_prefects"><xsl:text>Praetorian prefect struck by damnatio</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.5'"><field name="inscriptions_in_honour_of_praetorian_prefects"><xsl:text>Praetorian prefect officially rehabilitated</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.6'"><field name="inscriptions_in_honour_of_praetorian_prefects"><xsl:text>Statue or portrait of the praetorian prefect preserved</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.7'"><field name="inscriptions_in_honour_of_praetorian_prefects"><xsl:text>Description of the type of statue over the base</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.8'"><field name="inscriptions_in_honour_of_praetorian_prefects"><xsl:text>Imperial permission for the statue over the base</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.9'"><field name="inscriptions_in_honour_of_praetorian_prefects"><xsl:text>Discourse justifying the honour</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.10'"><field name="inscriptions_in_honour_of_praetorian_prefects"><xsl:text>Panegyric and celebrative formulas</xsl:text></field></xsl:if>
    <!--<xsl:if test="@n='2.11'"><field name="inscriptions_in_honour_of_praetorian_prefects"><xsl:text>Awarder of the monument</xsl:text></field></xsl:if>-->
  </xsl:template>
  
  <xsl:template match="tei:div[@subtype='prefects']//tei:p[@n]" mode="facet_panegyric_and_celebrative_formulas_for_the_praetorian_prefect">
    <xsl:if test="@n='2.10'"><field name="panegyric_and_celebrative_formulas_for_the_praetorian_prefect"><xsl:apply-templates select="." /></field></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:div[@subtype='prefects']//tei:item[@n]" mode="facet_awarder_of_monuments_to_praetorian_prefects">
    <xsl:if test="@n='2.11.a'"><field name="awarder_of_monuments_to_praetorian_prefects"><xsl:text>Clients</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.11.b'"><field name="awarder_of_monuments_to_praetorian_prefects"><xsl:text>City or cities</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.11.c'"><field name="awarder_of_monuments_to_praetorian_prefects"><xsl:text>City Council (ordo or βουλῆ)</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.11.d'"><field name="awarder_of_monuments_to_praetorian_prefects"><xsl:text>Province or provinces (concilia or κοινά)</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.11.e'"><field name="awarder_of_monuments_to_praetorian_prefects"><xsl:text>Colleges and corporations</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.11.f'"><field name="awarder_of_monuments_to_praetorian_prefects"><xsl:text>Individuals</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.11.g'"><field name="awarder_of_monuments_to_praetorian_prefects"><xsl:text>Emperors</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.11.h'"><field name="awarder_of_monuments_to_praetorian_prefects"><xsl:text>Family members</xsl:text></field></xsl:if>
    <xsl:if test="@n='2.11.i'"><field name="awarder_of_monuments_to_praetorian_prefects"><xsl:text>Officials</xsl:text></field></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:div[@subtype='prefects']//tei:p[@n]" mode="facet_epitaph_of_a_praetorian_prefect">
    <xsl:if test="@n='3.a'"><field name="epitaph_of_a_praetorian_prefect"><xsl:text>Epitaph of a praetorian prefect</xsl:text></field></xsl:if>
    <xsl:if test="@n='3.b'"><field name="epitaph_of_a_praetorian_prefect"><xsl:text>Epitaph of a praetorian prefect’s relative</xsl:text></field></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:div[@subtype='prefects']//tei:p[@n]" mode="facet_inscriptions_identifying_a_property_of_a_praetorian_prefect">
    <xsl:if test="@n='4'"><field name="inscriptions_identifying_a_property_of_a_praetorian_prefect"><xsl:text>Inscriptions identifying a property of a praetorian prefect</xsl:text></field></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:div[@subtype='prefects']//tei:p[@n]" mode="facet_inscriptions_containing_legal_acts_sent_to_praetorian_prefects">
    <xsl:if test="@n='5'"><field name="inscriptions_containing_legal_acts_sent_to_praetorian_prefects"><xsl:text>Legal acts sent to praetorian prefects</xsl:text></field></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:div[@subtype='prefects']//tei:p[@n]" mode="facet_inscriptions_containing_legal_acts_issued_by_praetorian_prefects">
    <xsl:if test="@n='6.a'"><field name="inscriptions_containing_legal_acts_issued_by_praetorian_prefects"><xsl:text>Edicts issued by praetorian prefects</xsl:text></field></xsl:if>
    <xsl:if test="@n='6.b'"><field name="inscriptions_containing_legal_acts_issued_by_praetorian_prefects"><xsl:text>Epistles issued by praetorian prefects</xsl:text></field></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:div[@subtype='prefects']//tei:p[@n]" mode="facet_inscribed_monuments_made_by_praetorian_prefects">
    <xsl:if test="@n='7.1'"><field name="inscribed_monuments_made_by_praetorian_prefects"><xsl:text>To Augusti or Caesars, made by all the praetorian prefects</xsl:text></field></xsl:if>
    <xsl:if test="@n='7.2'"><field name="inscribed_monuments_made_by_praetorian_prefects"><xsl:text>To Augusti or Caesars, made by one praetorian prefect</xsl:text></field></xsl:if>
    <xsl:if test="@n='7.y'"><field name="inscribed_monuments_made_by_praetorian_prefects"><xsl:text>Made by a praetorian prefect struck by damnatio</xsl:text></field></xsl:if>
    <xsl:if test="@n='7.z'"><field name="inscribed_monuments_made_by_praetorian_prefects"><xsl:text>Made by a praetorian prefect officially rehabilitated</xsl:text></field></xsl:if>
    <xsl:if test="@n='7.3'"><field name="inscribed_monuments_made_by_praetorian_prefects"><xsl:text>Construction or restoration of a civic building</xsl:text></field></xsl:if>
    <xsl:if test="@n='7.4'"><field name="inscribed_monuments_made_by_praetorian_prefects"><xsl:text>Construction or restoration of a military building</xsl:text></field></xsl:if>
    <xsl:if test="@n='7.5'"><field name="inscribed_monuments_made_by_praetorian_prefects"><xsl:text>Construction or restoration of a religious building</xsl:text></field></xsl:if>
    <xsl:if test="@n='7.6'"><field name="inscribed_monuments_made_by_praetorian_prefects"><xsl:text>Other categories of public inscriptions</xsl:text></field></xsl:if>
    <xsl:if test="@n='7.7'"><field name="inscribed_monuments_made_by_praetorian_prefects"><xsl:text>Other categories of private inscriptions</xsl:text></field></xsl:if>
    <xsl:if test="@n='7.8'"><field name="inscribed_monuments_made_by_praetorian_prefects"><xsl:text>Other categories of religious inscriptions</xsl:text></field></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:div[@subtype='prefects']//tei:p[@n]" mode="facet_the_praetorian_prefecture_in_inscriptions">
    <!--<xsl:if test="@n='8.1'"><field name="the_praetorian_prefecture_in_inscriptions"><xsl:text>The rank of the praetorian prefects</xsl:text></field></xsl:if>
    <xsl:if test="@n='8.2'"><field name="the_praetorian_prefecture_in_inscriptions"><xsl:text>Latin / Greek titulature of the office</xsl:text></field></xsl:if>-->
    <xsl:if test="@n='8.3'"><field name="the_praetorian_prefecture_in_inscriptions"><xsl:text>Inscription with full cursus honorum of the prefect</xsl:text></field></xsl:if>
    <xsl:if test="@n='8.4'"><field name="the_praetorian_prefecture_in_inscriptions"><xsl:text>Inscription with partial cursus honorum of the prefect</xsl:text></field></xsl:if>
    <xsl:if test="@n='8.5'"><field name="the_praetorian_prefecture_in_inscriptions"><xsl:text>Inscription without cursus honorum</xsl:text></field></xsl:if>
    <xsl:if test="@n='8.6'"><field name="the_praetorian_prefecture_in_inscriptions"><xsl:text>Inscription recording more than one appointment as praetorian prefect</xsl:text></field></xsl:if>
    <xsl:if test="@n='8.7'"><field name="the_praetorian_prefecture_in_inscriptions"><xsl:text>Inscription recording the total duration of a mandate as prefect</xsl:text></field></xsl:if>
    <xsl:if test="@n='8.8'"><field name="the_praetorian_prefecture_in_inscriptions"><xsl:text>Inscription recording the total duration of several or all mandates as prefect</xsl:text></field></xsl:if>
    <xsl:if test="@n='8.9'"><field name="the_praetorian_prefecture_in_inscriptions"><xsl:text>Inscription recording only the current prefecture</xsl:text></field></xsl:if>
    <xsl:if test="@n='8.10'"><field name="the_praetorian_prefecture_in_inscriptions"><xsl:text>Inscription recording only the prefecture just completed</xsl:text></field></xsl:if>
    <xsl:if test="@n='8.11'"><field name="the_praetorian_prefecture_in_inscriptions"><xsl:text>Inscription not mentioning the regional area of the prefecture</xsl:text></field></xsl:if>
    <xsl:if test="@n='8.12'"><field name="the_praetorian_prefecture_in_inscriptions"><xsl:text>Inscription mentioning the regional area of the prefecture</xsl:text></field></xsl:if>
    <xsl:if test="@n='8.13'"><field name="the_praetorian_prefecture_in_inscriptions"><xsl:text>Inscription recording the number of prefectures attained by the dignitary without their regional areas</xsl:text></field></xsl:if>
    <xsl:if test="@n='8.14'"><field name="the_praetorian_prefecture_in_inscriptions"><xsl:text>Inscription recording all prefectures attained by the dignitary with their regional areas</xsl:text></field></xsl:if>
    <xsl:if test="@n='8.15'"><field name="the_praetorian_prefecture_in_inscriptions"><xsl:text>Inscription recording the geographical origin of the prefect</xsl:text></field></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:div[@subtype='prefects']//tei:p[@n]" mode="facet_the_rank_of_the_praetorian_prefects">
    <xsl:if test="@n='8.1'"><field name="the_rank_of_the_praetorian_prefects"><xsl:apply-templates select="." /></field></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:div[@subtype='prefects']//tei:p[@n]" mode="facet_Latin_or_Greek_titulature_of_the_office">
    <xsl:if test="@n='8.2'"><field name="Latin_or_Greek_titulature_of_the_office"><xsl:apply-templates select="." /></field></xsl:if>
  </xsl:template>
  
  <xsl:template match="//tei:origDate[@period]" mode="facet_emperors_and_their_prefects">
    <xsl:variable name="per-id" select="substring-after(@period,'#')"/>
    <xsl:variable name="period-id" select="document('../../content/xml/authority/period.xml')//tei:item[@xml:id=$per-id]/tei:term[@xml:lang='en']"/>
    <field name="emperors_and_their_prefects">
      <xsl:value-of select="$period-id" />
    </field>
  </xsl:template>
  
  <xsl:template match="tei:publicationStmt/tei:idno[@type='filename']" mode="facet_number_PPRET">
    <field name="number_PPRET">
      <xsl:value-of select="." />
    </field>
  </xsl:template>
  
  <xsl:template match="tei:titleStmt/tei:title" mode="facet_inscription_name">
    <field name="inscription_name">
      <xsl:apply-templates select="." />
    </field>
  </xsl:template>
  
  <xsl:template match="tei:ref[@type='source']" mode="facet_literary_source_mentioned_in_the_commentary">
    <field name="literary_source_mentioned_in_the_commentary">
      <xsl:value-of select="normalize-space(translate(translate(., '/', '／'), '?', ''))" />
    </field>
  </xsl:template>
  
  <xsl:template match="tei:ref[@type='inscription']" mode="facet_epigraphic_source_mentioned_in_the_commentary">
    <field name="epigraphic_source_mentioned_in_the_commentary">
      <xsl:value-of select="normalize-space(translate(translate(., '/', '／'), '?', ''))" />
    </field>
  </xsl:template>
  
  <xsl:template match="tei:ref[@type='papyrus']" mode="facet_papyrological_source_mentioned_in_the_commentary">
    <field name="papyrological_source_mentioned_in_the_commentary">
      <xsl:value-of select="normalize-space(translate(translate(., '/', '／'), '?', ''))" />
    </field>
  </xsl:template>
  
  <xsl:template match="tei:div[@type='edition']" mode="facet_ancient_text">
    <field name="ancient_text"> 
      <xsl:apply-templates select="." /> <!-- translate(normalize-unicode(lower-case(.),'NFD'), '&#x0300;&#x0301;&#x0308;&#x0303;&#x0304;&#x0313;&#x0314;&#x0345;&#x0342;' ,'') -->
    </field>
  </xsl:template>
  
  <xsl:template name="extra_fields" >
    <xsl:call-template name="field_PLRE"/>  
    <xsl:call-template name="field_language"/>
    <xsl:call-template name="field_text_category"/>
    <xsl:call-template name="field_palaeography"/>
    <xsl:call-template name="field_technique"/>
    <xsl:call-template name="field_epigraphic_field_preservation"/>
    <xsl:call-template name="field_rhythm"/>
    <xsl:call-template name="field_inscribed_field_reuse"/>
    <xsl:call-template name="field_monument_reuse"/>
    <xsl:call-template name="field_opistographic"/>
    <xsl:call-template name="field_prefect_name"/>
    <xsl:call-template name="field_ancient_location"/>
    <xsl:call-template name="field_modern_city"/>
    <xsl:call-template name="field_province"/>
    <xsl:call-template name="field_diocese"/>
    <xsl:call-template name="field_regional_prefecture"/>
    <xsl:call-template name="field_editions"/>
    <xsl:call-template name="field_edition"/>
    <xsl:call-template name="field_dated_inscriptions"/>
    <xsl:call-template name="field_date"/>
    <xsl:call-template name="field_number_of_praetorian_prefects"/>
    <xsl:call-template name="field_inscriptions_in_honour_of_praetorian_prefects"/>
    <xsl:call-template name="field_panegyric_and_celebrative_formulas_for_the_praetorian_prefect"/>
    <xsl:call-template name="field_awarder_of_monuments_to_praetorian_prefects"/>
    <xsl:call-template name="field_epitaph_of_a_praetorian_prefect"/>
    <xsl:call-template name="field_inscriptions_identifying_a_property_of_a_praetorian_prefect"/>
    <xsl:call-template name="field_inscriptions_containing_legal_acts_sent_to_praetorian_prefects"/>
    <xsl:call-template name="field_inscriptions_containing_legal_acts_issued_by_praetorian_prefects"/>
    <xsl:call-template name="field_inscribed_monuments_made_by_praetorian_prefects"/>
    <xsl:call-template name="field_the_praetorian_prefecture_in_inscriptions"/>
    <xsl:call-template name="field_the_rank_of_the_praetorian_prefects"/>
    <xsl:call-template name="field_Latin_or_Greek_titulature_of_the_office"/>
    <xsl:call-template name="field_emperors_and_their_prefects"/>
    <xsl:call-template name="field_number_PPRET"/>
    <xsl:call-template name="field_inscription_name"/>
    <xsl:call-template name="field_literary_source_mentioned_in_the_commentary"/>
    <xsl:call-template name="field_epigraphic_source_mentioned_in_the_commentary"/>
    <xsl:call-template name="field_papyrological_source_mentioned_in_the_commentary"/>
    <xsl:call-template name="field_ancient_text"/>
  </xsl:template>
  
  <xsl:template name="field_PLRE">
    <xsl:apply-templates mode="facet_PLRE" select="//tei:publicationStmt/tei:idno" />
  </xsl:template>
  
  <xsl:template name="field_language">
    <xsl:apply-templates mode="facet_language" select="//tei:textLang" />
  </xsl:template>
  
  <xsl:template name="field_text_category">
    <xsl:apply-templates mode="facet_text_category" select="//tei:summary/tei:term[@type='textType']" />
  </xsl:template>
  
  <xsl:template name="field_palaeography">
    <xsl:apply-templates mode="facet_palaeography" select="//tei:handNote/tei:term" />
  </xsl:template>
  
  <xsl:template name="field_technique">
    <xsl:apply-templates mode="facet_technique" select="//tei:layout/tei:rs[@type='execution']" />
  </xsl:template>
  
  <xsl:template name="field_epigraphic_field_preservation">
    <xsl:apply-templates mode="facet_epigraphic_field_preservation" select="//tei:layout/tei:rs[@type='preservation']" />
  </xsl:template>
  
  <xsl:template name="field_rhythm">
    <xsl:apply-templates mode="facet_rhythm" select="//tei:summary/tei:term[@type='rhythm']" />
  </xsl:template>
  
  <xsl:template name="field_inscribed_field_reuse">
    <xsl:apply-templates mode="facet_inscribed_field_reuse" select="//tei:support/tei:rs[@type='inscribed_field_reuse']"/>
  </xsl:template>
  
  <xsl:template name="field_monument_reuse">
    <xsl:apply-templates mode="facet_monument_reuse" select="//tei:support/tei:rs[@type='monument_reuse']"/>
  </xsl:template>
  
  <xsl:template name="field_opistographic">
    <xsl:apply-templates mode="facet_opistographic" select="//tei:support/tei:rs[@type='opistographic']"/>
  </xsl:template>
  
  <xsl:template name="field_prefect_name">
    <xsl:apply-templates mode="facet_prefect_name" select="//tei:sourceDesc/tei:listPerson"/>
  </xsl:template>
  
  <xsl:template name="field_ancient_location">
    <xsl:apply-templates mode="facet_ancient_location" select="//tei:origin/tei:origPlace//tei:placeName[@type='ancient_location']" />
  </xsl:template>
  
  <xsl:template name="field_modern_city">
    <xsl:apply-templates mode="facet_modern_city" select="//tei:origin/tei:origPlace//tei:placeName[@type='modern_city']" />
  </xsl:template>
  
  <xsl:template name="field_province">
    <xsl:apply-templates mode="facet_province" select="//tei:origin/tei:origPlace//tei:placeName[@type='province']" />
  </xsl:template>
  
  <xsl:template name="field_diocese">
    <xsl:apply-templates mode="facet_diocese" select="//tei:origin/tei:origPlace//tei:placeName[@type='diocese']" />
  </xsl:template>
  
  <xsl:template name="field_regional_prefecture">
    <xsl:apply-templates mode="facet_regional_prefecture" select="//tei:origin/tei:origPlace//tei:placeName[@type='prefecture']" />
  </xsl:template>
  
  <xsl:template name="field_editions">
    <xsl:apply-templates mode="facet_editions" select="//tei:bibl[ancestor::tei:div[@subtype='editions' or @subtype='images' or @subtype='links']]" />
  </xsl:template>
  
  <xsl:template name="field_edition">
    <xsl:apply-templates mode="facet_edition" select="//tei:bibl[ancestor::tei:div[@subtype='editions']]//tei:ref" />
  </xsl:template>
  
  <xsl:template name="field_dated_inscriptions">
    <xsl:apply-templates mode="facet_dated_inscriptions" select="//tei:origDate[@precision='high']" />
  </xsl:template>
  
  <xsl:template name="field_date">
    <xsl:apply-templates mode="facet_date" select="//tei:origDate" />
  </xsl:template>
  
  <xsl:template name="field_number_of_praetorian_prefects">
    <xsl:apply-templates mode="facet_number_of_praetorian_prefects" select="//tei:div[@subtype='prefects']" />
  </xsl:template>
  
  <xsl:template name="field_inscriptions_in_honour_of_praetorian_prefects">
    <xsl:apply-templates mode="facet_inscriptions_in_honour_of_praetorian_prefects" select="//tei:div[@subtype='prefects']" />
  </xsl:template>
  
  <xsl:template name="field_panegyric_and_celebrative_formulas_for_the_praetorian_prefect">
    <xsl:apply-templates mode="facet_panegyric_and_celebrative_formulas_for_the_praetorian_prefect" select="//tei:div[@subtype='prefects']" />
  </xsl:template>
  
  <xsl:template name="field_awarder_of_monuments_to_praetorian_prefects">
    <xsl:apply-templates mode="facet_awarder_of_monuments_to_praetorian_prefects" select="//tei:div[@subtype='prefects']" />
  </xsl:template>
  
  <xsl:template name="field_epitaph_of_a_praetorian_prefect">
    <xsl:apply-templates mode="facet_epitaph_of_a_praetorian_prefect" select="//tei:div[@subtype='prefects']" />
  </xsl:template>
  
  <xsl:template name="field_inscriptions_identifying_a_property_of_a_praetorian_prefect">
    <xsl:apply-templates mode="facet_inscriptions_identifying_a_property_of_a_praetorian_prefect" select="//tei:div[@subtype='prefects']" />
  </xsl:template>
  
  <xsl:template name="field_inscriptions_containing_legal_acts_sent_to_praetorian_prefects">
    <xsl:apply-templates mode="facet_inscriptions_containing_legal_acts_sent_to_praetorian_prefects" select="//tei:div[@subtype='prefects']" />
  </xsl:template>
  
  <xsl:template name="field_inscriptions_containing_legal_acts_issued_by_praetorian_prefects">
    <xsl:apply-templates mode="facet_inscriptions_containing_legal_acts_issued_by_praetorian_prefects" select="//tei:div[@subtype='prefects']" />
  </xsl:template>
  
  <xsl:template name="field_inscribed_monuments_made_by_praetorian_prefects">
    <xsl:apply-templates mode="facet_inscribed_monuments_made_by_praetorian_prefects" select="//tei:div[@subtype='prefects']" />
  </xsl:template>
  
  <xsl:template name="field_the_praetorian_prefecture_in_inscriptions">
    <xsl:apply-templates mode="facet_the_praetorian_prefecture_in_inscriptions" select="//tei:div[@subtype='prefects']" />
  </xsl:template>
  
  <xsl:template name="field_Latin_or_Greek_titulature_of_the_office">
    <xsl:apply-templates mode="facet_Latin_or_Greek_titulature_of_the_office" select="//tei:div[@subtype='prefects']" />
  </xsl:template>
  
  <xsl:template name="field_the_rank_of_the_praetorian_prefects">
    <xsl:apply-templates mode="facet_the_rank_of_the_praetorian_prefects" select="//tei:div[@subtype='prefects']" />
  </xsl:template>
  
  <xsl:template name="field_emperors_and_their_prefects">
    <xsl:apply-templates mode="facet_emperors_and_their_prefects" select="//tei:origDate" />
  </xsl:template>
  
  <xsl:template name="field_number_PPRET">
    <xsl:apply-templates mode="facet_number_PPRET" select="//tei:publicationStmt/tei:idno[@type='filename']" />
  </xsl:template>
  
  <xsl:template name="field_inscription_name">
    <xsl:apply-templates mode="facet_inscription_name" select="//tei:titleStmt/tei:title" />
  </xsl:template>
  
  <xsl:template name="field_literary_source_mentioned_in_the_commentary">
    <xsl:apply-templates mode="facet_literary_source_mentioned_in_the_commentary" select="//tei:ref[@type='source']" />
  </xsl:template>
  
  <xsl:template name="field_epigraphic_source_mentioned_in_the_commentary">
    <xsl:apply-templates mode="facet_epigraphic_source_mentioned_in_the_commentary" select="//tei:ref[@type='inscription']" />
  </xsl:template>
  
  <xsl:template name="field_papyrological_source_mentioned_in_the_commentary">
    <xsl:apply-templates mode="facet_papyrological_source_mentioned_in_the_commentary" select="//tei:ref[@type='papyrus']" />
  </xsl:template>
  
  <xsl:template name="field_ancient_text">
    <xsl:apply-templates mode="facet_ancient_text" select="//tei:text/tei:body/tei:div[@type='edition']" />
  </xsl:template>
</xsl:stylesheet>
