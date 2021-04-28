<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t"
  version="2.0">
  <!-- Contains named templates for PPRET file structure (aka "metadata" aka "supporting data") -->
  <!-- Called from htm-tpl-structure.xsl -->

  <xsl:template name="ppret-body-structure">
    <xsl:call-template name="navigation"/>
    <div id="inscription_full_edition">
      <div id="identification" class="edition_part">
      <div>
        <h2><b><xsl:apply-templates select="//t:publicationStmt/t:idno[@type='filename']//text()"/>
          <xsl:text>. </xsl:text>
          <xsl:apply-templates select="//t:titleStmt/t:title"/></b></h2>
        <p style="text-align:right"><a href="/en/texts/team.html"><xsl:apply-templates select="//t:editor[@role='edition']"/></a></p>
        <p><b>
          <xsl:if test="//t:publicationStmt/t:idno[@n='new']"><xsl:text>NEW</xsl:text></xsl:if>
          <xsl:if test="//t:publicationStmt/t:idno[@n='plre']"><xsl:text>In the PLRE I</xsl:text></xsl:if>
          <xsl:if test="//t:publicationStmt/t:idno[@n='rev']"><xsl:text>REV</xsl:text></xsl:if></b>
          <xsl:if test="//t:publicationStmt/t:idno[@corresp]"><xsl:text> (</xsl:text><xsl:if test="//t:publicationStmt/t:idno[@n='rev']"><xsl:text>PLRE I, </xsl:text></xsl:if><xsl:value-of select="//t:publicationStmt/t:idno/@corresp"/><xsl:text>)</xsl:text></xsl:if>
        </p>
      </div>

      <div id="editions" class="edition_subpart">
        <h3><i18n:text i18n:key="ppret-editions">Editions</i18n:text></h3>
        <p><xsl:for-each select="//t:div[@type='bibliography'][@subtype='editions']/t:p/t:bibl">
          <xsl:apply-templates select="."/><xsl:if test="position()!=last()"><br/></xsl:if></xsl:for-each>
          <br/><br/></p>

        <xsl:if test="//t:div[@type='bibliography'][@subtype='images']/t:p//text()">
          <h3><i18n:text i18n:key="ppret-editions-images">Photos</i18n:text></h3>
          <p><xsl:for-each select="//t:div[@type='bibliography'][@subtype='images']/t:p/t:bibl">
            <xsl:apply-templates select="."/><br/></xsl:for-each>
            <br/></p>
        </xsl:if>

        <xsl:if test="//t:div[@type='bibliography'][@subtype='links']/t:p//text()">
          <h3><i18n:text i18n:key="ppret-editions-links">Links</i18n:text></h3>
          <p><xsl:for-each select="//t:div[@type='bibliography'][@subtype='links']/t:p/t:bibl">
            <xsl:apply-templates select="."/><br/></xsl:for-each>
          </p>
        </xsl:if>
      </div>

      <div id="prefects" class="edition_subpart">
        <h3><i18n:text i18n:key="ppret-prefects">Praetorian prefects</i18n:text></h3>
        <p>
          <xsl:for-each select="//t:sourceDesc/t:listPerson/t:person">
            <xsl:variable name="pers-id" select="substring-after(t:persName/@ref,'#')"/>
            <xsl:variable name="person-id" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/authority/listPerson.xml'))//t:person[@xml:id=$pers-id]/t:persName"/>
            <xsl:choose>
              <xsl:when test="t:persName[@ref]"><xsl:value-of select="$person-id"/></xsl:when>
              <xsl:when test="t:persName[@key][not(@ref)]"><xsl:value-of select="t:persName/@key"/></xsl:when>
              <xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
            </xsl:choose>
            <xsl:if test="position()!=last()"><br/></xsl:if></xsl:for-each>
        </p>
      </div>

      <div id="date" class="edition_subpart">
        <h3><i18n:text i18n:key="ppret-date">Date of the inscription</i18n:text></h3>
        <p>
          <xsl:if test="//t:origin/t:origDate//text()">
            <xsl:apply-templates select="//t:origin/t:origDate"/>
          </xsl:if>
        </p>
      </div>
    </div>



    <div id="provenance-location" class="edition_part">
      <h2><i18n:text i18n:key="ppret-provenance-location">Provenance and location</i18n:text></h2>
      <p>
        <b><i18n:text i18n:key="ppret-ancient-city">Ancient city</i18n:text>: </b>
        <xsl:apply-templates select="//t:origin/t:origPlace/t:placeName[@type='ancient_city']"/><br/>
        <b><i18n:text i18n:key="ppret-modern-city">Modern city</i18n:text>: </b>
        <xsl:apply-templates select="//t:origin/t:origPlace/t:placeName[@type='modern_city']"/><br/>
        <b><i18n:text i18n:key="ppret-province">Province</i18n:text>: </b>
        <xsl:apply-templates select="//t:origin/t:origPlace/t:placeName[@type='province']"/><br/>
        <b><i18n:text i18n:key="ppret-diocese">Diocese</i18n:text>: </b>
        <xsl:apply-templates select="//t:origin/t:origPlace/t:placeName[@type='diocese']"/><br/>
        <b><i18n:text i18n:key="ppret-prefecture">Regional prefecture</i18n:text>: </b>
        <xsl:apply-templates select="//t:origin/t:origPlace/t:placeName[@type='prefecture']"/><br/>
        <b><i18n:text i18n:key="ppret-findspot">Provenance</i18n:text>: </b>
        <xsl:apply-templates select="//t:provenance[@type='found']"/><br/>

        <b><i18n:text i18n:key="ppret-current-location">Current location</i18n:text><xsl:if test="//t:msIdentifier/t:repository[@corresp]"> (<xsl:value-of select="//t:msIdentifier/t:repository/@corresp"/>)</xsl:if>: </b>
        <xsl:apply-templates select="//t:msIdentifier/t:repository"/>
        <xsl:if test="//t:msIdentifier/t:idno[@type='invNo']//text()">
          <xsl:text>, </xsl:text>
          <xsl:apply-templates select="//t:msIdentifier/t:idno[@type='invNo']"/></xsl:if><br/>

        <xsl:if test="//t:msIdentifier/t:altIdentifier">
          <b><i18n:text i18n:key="ppret-current-location">Current location</i18n:text><xsl:if test="//t:msIdentifier/t:altIdentifier/t:repository[@corresp]"> (<xsl:value-of select="//t:msIdentifier/t:altIdentifier/t:repository/@corresp"/>)</xsl:if>: </b>
          <xsl:apply-templates select="//t:msIdentifier/t:altIdentifier/t:repository"/>
          <xsl:if test="//t:msIdentifier/t:altIdentifier/t:idno[@type='invNo']//text()">
            <xsl:text>, </xsl:text>
            <xsl:apply-templates select="//t:msIdentifier/t:altIdentifier/t:idno[@type='invNo']"/></xsl:if><br/>
        </xsl:if>

        <b><i18n:text i18n:key="ppret-ancient-location">Ancient location</i18n:text>: </b>
        <xsl:apply-templates select="//t:origin/t:origPlace/t:placeName[@type='ancient_location']"/>
      </p>
    </div>

    <div id="object-layout" class="edition_part">
      <h2><i18n:text i18n:key="ppret-object-layout">Type and material of the support and text layout</i18n:text></h2>
      <div>
        <p><b><i18n:text i18n:key="ppret-object">Type of support</i18n:text>: </b>
          <xsl:apply-templates select="//t:support/t:objectType"/></p>

        <p><b><i18n:text i18n:key="ppret-material">Material</i18n:text>: </b>
          <xsl:apply-templates select="//t:support/t:material"/></p>

        <p><b><i18n:text i18n:key="ppret-reuse">Reuse</i18n:text>: </b></p>
        <ul>
          <li class="n"><b><i18n:text i18n:key="ppret-reuse-inscribed-field">Reuse of the inscribed field</i18n:text>: </b> <xsl:apply-templates select="//t:support/t:rs[@type='inscribed_field_reuse']"/></li>
          <li class="n"><b><i18n:text i18n:key="ppret-reuse-monument">Reuse of the monument</i18n:text>: </b> <xsl:apply-templates select="//t:support/t:rs[@type='monument_reuse']"/></li>
          <li class="n"><b><i18n:text i18n:key="ppret-reuse-opistographic">Opistographic</i18n:text>: </b> <xsl:apply-templates select="//t:support/t:rs[@type='opistographic']"/></li>
        </ul>

        <xsl:if test="//t:support/t:dimensions[not(@corresp)]//text()">
          <p><b><i18n:text i18n:key="ppret-dimension">Dimensions of support</i18n:text>: </b>
            <xsl:if test="//t:support/t:dimensions/t:height//text()"><i18n:text i18n:key="ppret-height">Height</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions/t:height"/><xsl:if test="//t:support/t:dimensions/t:height!='?' and //t:support/t:dimensions/t:height!='not recorded' and //t:support/t:dimensions/t:height!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions/t:width//text()"><i18n:text i18n:key="ppret-width">Width</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions/t:width"/><xsl:if test="//t:support/t:dimensions/t:width!='?' and //t:support/t:dimensions/t:width!='not recorded' and //t:support/t:dimensions/t:width!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions/t:depth//text()"><i18n:text i18n:key="ppret-depth">Breadth</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions/t:depth"/><xsl:if test="//t:support/t:dimensions/t:depth!='?' and //t:support/t:dimensions/t:depth!='not recorded' and //t:support/t:dimensions/t:depth!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions/t:dim[@type='diameter']//text()"><i18n:text i18n:key="ppret-diameter">Diameter</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions/t:dim[@type='diameter']"/><xsl:if test="//t:support/t:dimensions/t:dim[@type='diameter']!='?' and //t:support/t:dimensions/t:dim[@type='diameter']!='not recorded' and //t:support/t:dimensions/t:dim[@type='diameter']!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions/t:dim[@type='weight']//text()"><i18n:text i18n:key="ppret-weight">Weight</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions/t:dim[@type='weight']"/><xsl:if test="//t:support/t:dimensions/t:dim[@type='weight']!='?' and //t:support/t:dimensions/t:dim[@type='weight']!='not recorded' and //t:support/t:dimensions/t:dim[@type='weight']!='unknown'"><xsl:text> gr</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
          </p>
        </xsl:if>

        <xsl:if test="//t:support/t:dimensions[@corresp][1]//text()">
          <p>
            <b><i18n:text i18n:key="ppret-dimension">Dimensions of support</i18n:text> (<xsl:value-of select="//t:support/t:dimensions[1]/@corresp"/>): </b>
            <xsl:if test="//t:support/t:dimensions[1]/t:height//text()"><i18n:text i18n:key="ppret-height">Height</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[1]/t:height"/><xsl:if test="//t:support/t:dimensions[1]/t:height!='?' and //t:support/t:dimensions[1]/t:height!='not recorded' and //t:support/t:dimensions[1]/t:height!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions[1]/t:width//text()"><i18n:text i18n:key="ppret-width">Width</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[1]/t:width"/><xsl:if test="//t:support/t:dimensions[1]/t:width!='?' and //t:support/t:dimensions[1]/t:width!='not recorded' and //t:support/t:dimensions[1]/t:width!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions[1]/t:depth//text()"><i18n:text i18n:key="ppret-depth">Breadth</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[1]/t:depth"/><xsl:if test="//t:support/t:dimensions[1]/t:depth!='?' and //t:support/t:dimensions[1]/t:depth!='not recorded' and //t:support/t:dimensions[1]/t:depth!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions[1]/t:dim[@type='diameter']//text()"><i18n:text i18n:key="ppret-diameter">Diameter</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[1]/t:dim[@type='diameter']"/><xsl:if test="//t:support/t:dimensions[1]/t:dim[@type='diameter']!='?' and //t:support/t:dimensions[1]/t:dim[@type='diameter']!='not recorded' and //t:support/t:dimensions[1]/t:dim[@type='diameter']!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions[1]/t:dim[@type='weight']//text()"><i18n:text i18n:key="ppret-weight">Weight</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[1]/t:dim[@type='weight']"/><xsl:if test="//t:support/t:dimensions[1]/t:dim[@type='weight']!='?' and //t:support/t:dimensions[1]/t:dim[@type='weight']!='not recorded' and //t:support/t:dimensions[1]/t:dim[@type='weight']!='unknown'"><xsl:text> gr</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
          </p>
        </xsl:if>


        <xsl:if test="//t:support/t:dimensions[@corresp][2]//text()">
          <p>
            <b><i18n:text i18n:key="ppret-dimension">Dimensions of support</i18n:text> (<xsl:value-of select="//t:support/t:dimensions[2]/@corresp"/>): </b>
            <xsl:if test="//t:support/t:dimensions[2]/t:height//text()"><i18n:text i18n:key="ppret-height">Height</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[2]/t:height"/><xsl:if test="//t:support/t:dimensions[2]/t:height!='?' and //t:support/t:dimensions[2]/t:height!='not recorded' and //t:support/t:dimensions[2]/t:height!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions[2]/t:width//text()"><i18n:text i18n:key="ppret-width">Width</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[2]/t:width"/><xsl:if test="//t:support/t:dimensions[2]/t:width!='?' and //t:support/t:dimensions[2]/t:width!='not recorded' and //t:support/t:dimensions[2]/t:width!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions[2]/t:depth//text()"><i18n:text i18n:key="ppret-depth">Breadth</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[2]/t:depth"/><xsl:if test="//t:support/t:dimensions[2]/t:depth!='?' and //t:support/t:dimensions[2]/t:depth!='not recorded' and //t:support/t:dimensions[2]/t:depth!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions[2]/t:dim[@type='diameter']//text()"><i18n:text i18n:key="ppret-diameter">Diameter</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[2]/t:dim[@type='diameter']"/><xsl:if test="//t:support/t:dimensions[2]/t:dim[@type='diameter']!='?' and //t:support/t:dimensions[2]/t:dim[@type='diameter']!='not recorded' and //t:support/t:dimensions[2]/t:dim[@type='diameter']!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions[2]/t:dim[@type='weight']//text()"><i18n:text i18n:key="ppret-weight">Weight</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[2]/t:dim[@type='weight']"/><xsl:if test="//t:support/t:dimensions[2]/t:dim[@type='weight']!='?' and //t:support/t:dimensions[2]/t:dim[@type='weight']!='not recorded' and //t:support/t:dimensions[2]/t:dim[@type='weight']!='unknown'"><xsl:text> gr</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
          </p>
        </xsl:if>

        <xsl:if test="//t:support/t:dimensions[@corresp][3]//text()">
          <p>
            <b><i18n:text i18n:key="ppret-dimension">Dimensions of support</i18n:text> (<xsl:value-of select="//t:support/t:dimensions[3]/@corresp"/>): </b>
            <xsl:if test="//t:support/t:dimensions[3]/t:height//text()"><i18n:text i18n:key="ppret-height">Height</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[3]/t:height"/><xsl:if test="//t:support/t:dimensions[3]/t:height!='?' and //t:support/t:dimensions[3]/t:height!='not recorded' and //t:support/t:dimensions[3]/t:height!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions[3]/t:width//text()"><i18n:text i18n:key="ppret-width">Width</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[3]/t:width"/><xsl:if test="//t:support/t:dimensions[3]/t:width!='?' and //t:support/t:dimensions[3]/t:width!='not recorded' and //t:support/t:dimensions[3]/t:width!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions[3]/t:depth//text()"><i18n:text i18n:key="ppret-depth">Breadth</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[3]/t:depth"/><xsl:if test="//t:support/t:dimensions[3]/t:depth!='?' and //t:support/t:dimensions[3]/t:depth!='not recorded' and //t:support/t:dimensions[3]/t:depth!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions[3]/t:dim[@type='diameter']//text()"><i18n:text i18n:key="ppret-diameter">Diameter</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[3]/t:dim[@type='diameter']"/><xsl:if test="//t:support/t:dimensions[3]/t:dim[@type='diameter']!='?' and //t:support/t:dimensions[3]/t:dim[@type='diameter']!='not recorded' and //t:support/t:dimensions[3]/t:dim[@type='diameter']!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions[3]/t:dim[@type='weight']//text()"><i18n:text i18n:key="ppret-weight">Weight</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[3]/t:dim[@type='weight']"/><xsl:if test="//t:support/t:dimensions[3]/t:dim[@type='weight']!='?' and //t:support/t:dimensions[3]/t:dim[@type='weight']!='not recorded' and //t:support/t:dimensions[3]/t:dim[@type='weight']!='unknown'"><xsl:text> gr</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
          </p>
        </xsl:if>

        <xsl:if test="//t:support/t:dimensions[@corresp][4]//text()">
          <p>
            <b><i18n:text i18n:key="ppret-dimension">Dimensions of support</i18n:text> (<xsl:value-of select="//t:support/t:dimensions[4]/@corresp"/>): </b>
            <xsl:if test="//t:support/t:dimensions[4]/t:height//text()"><i18n:text i18n:key="ppret-height">Height</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[4]/t:height"/><xsl:if test="//t:support/t:dimensions[4]/t:height!='?' and //t:support/t:dimensions[4]/t:height!='not recorded' and //t:support/t:dimensions[4]/t:height!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions[4]/t:width//text()"><i18n:text i18n:key="ppret-width">Width</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[4]/t:width"/><xsl:if test="//t:support/t:dimensions[4]/t:width!='?' and //t:support/t:dimensions[4]/t:width!='not recorded' and //t:support/t:dimensions[4]/t:width!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions[4]/t:depth//text()"><i18n:text i18n:key="ppret-depth">Breadth</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[4]/t:depth"/><xsl:if test="//t:support/t:dimensions[4]/t:depth!='?' and //t:support/t:dimensions[4]/t:depth!='not recorded' and //t:support/t:dimensions[4]/t:depth!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions[4]/t:dim[@type='diameter']//text()"><i18n:text i18n:key="ppret-diameter">Diameter</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[4]/t:dim[@type='diameter']"/><xsl:if test="//t:support/t:dimensions[4]/t:dim[@type='diameter']!='?' and //t:support/t:dimensions[4]/t:dim[@type='diameter']!='not recorded' and //t:support/t:dimensions[4]/t:dim[@type='diameter']!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
            <xsl:if test="//t:support/t:dimensions[4]/t:dim[@type='weight']//text()"><i18n:text i18n:key="ppret-weight">Weight</i18n:text>:
              <xsl:value-of select="//t:support/t:dimensions[4]/t:dim[@type='weight']"/><xsl:if test="//t:support/t:dimensions[4]/t:dim[@type='weight']!='?' and //t:support/t:dimensions[4]/t:dim[@type='weight']!='not recorded' and //t:support/t:dimensions[4]/t:dim[@type='weight']!='unknown'"><xsl:text> gr</xsl:text></xsl:if><xsl:text>. </xsl:text>
            </xsl:if>
          </p>
        </xsl:if>

        <xsl:if test="//t:handDesc/t:handNote/t:height//text()">
          <xsl:for-each select="//t:handDesc/t:handNote/t:height"><p><b><i18n:text i18n:key="ppret-letter-height">Dimensions of letters</i18n:text><xsl:if test="@corresp"><xsl:text> (</xsl:text><xsl:apply-templates select="@corresp"/><xsl:text>)</xsl:text></xsl:if>: </b>
            <xsl:apply-templates select="."/><xsl:if test=".!='?' and .!='not recorded' and .!='unknown'"><xsl:text> cm</xsl:text></xsl:if><xsl:text>. </xsl:text></p></xsl:for-each>
        </xsl:if>
      </div>

      <div class="edition_subpart">
        <xsl:if test="//t:layoutDesc/t:layout/t:rs[@type='preservation']//text()">
          <h3><i18n:text i18n:key="ppret-preservation">Inscribed field</i18n:text></h3>
          <p><xsl:if test="//t:layoutDesc/t:layout/t:p[not(@n)]//text()"><xsl:apply-templates select="//t:layoutDesc/t:layout/t:p[not(@n)]/node()"/><br/></xsl:if>
            <xsl:apply-templates select="//t:layoutDesc/t:layout/t:rs[@type='preservation']"/>
            <xsl:if test="//t:layoutDesc/t:layout/t:p[@n]//text()"><br/><xsl:apply-templates select="//t:layoutDesc/t:layout/t:p[@n]/node()"/></xsl:if>
          </p>
        </xsl:if>
      </div>

      <div class="edition_subpart">
        <p><br/>
          <xsl:if test="//t:layoutDesc/t:layout/t:rs[@type='execution']//text()">
            <b><i18n:text i18n:key="ppret-execution">Writing technique</i18n:text>: </b>
            <xsl:apply-templates select="//t:layoutDesc/t:layout/t:rs[@type='execution']"/>
          </xsl:if>
        </p>

        <p>
          <xsl:if test="//t:textLang//text()">
            <b><i18n:text i18n:key="ppret-language">Language</i18n:text>: </b>
            <xsl:apply-templates select="//t:textLang"/>
          </xsl:if>
        </p>

        <p>
          <xsl:if test="//t:msContents/t:summary/t:term[@type='rhythm']//text()">
            <b><i18n:text i18n:key="ppret-rhythm">Rhythm</i18n:text>: </b>
            <xsl:apply-templates select="//t:msContents/t:summary/t:term[@type='rhythm']"/>
          </xsl:if>
        </p>

        <p>
          <xsl:if test="//t:handDesc/t:handNote/t:term//text()">
            <b><i18n:text i18n:key="ppret-palaeography">Palaeography</i18n:text>: </b>
            <xsl:apply-templates select="//t:handDesc/t:handNote/t:term"/>
          </xsl:if>
        </p>
      </div>
    </div>

    <div id="textType" class="edition_part">
      <h2><i18n:text i18n:key="ppret-text-categories">Text category</i18n:text></h2>
      <p><xsl:if test="//t:msContents/t:summary/t:term[@type='textType']//text()">
        <xsl:apply-templates select="//t:msContents/t:summary/t:term[@type='textType']//text()"/><br/>
      </xsl:if>
      </p>
    </div>

    <div id="edition" class="edition_part">
      <h2><i18n:text i18n:key="ppret-edition"><xsl:choose><xsl:when test="//t:div[@type='edition'][@xml:lang='la']">Latin</xsl:when>
        <xsl:when test="//t:div[@type='edition'][@xml:lang='grc']">Greek</xsl:when>
        <xsl:otherwise>Ancient</xsl:otherwise></xsl:choose> text</i18n:text></h2>
      <xsl:variable name="edtxt">
        <xsl:apply-templates select="//t:div[@type='edition']">
          <xsl:with-param name="parm-edition-type" select="'interpretive'" tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:variable>
      <xsl:apply-templates select="$edtxt" mode="sqbrackets"/>

      <xsl:if test="//t:div[@type='apparatus']/t:p//text()">
        <h3><i18n:text i18n:key="ppret-apparatus">Critical edition</i18n:text></h3>
        <xsl:variable name="apptxt">
          <xsl:apply-templates select="//t:div[@type='apparatus']/t:p"/>
        </xsl:variable>
        <xsl:apply-templates select="$apptxt" mode="sqbrackets"/>
        <p><xsl:if test="//t:provenance[@type='observed']//text()"><xsl:apply-templates select="//t:provenance[@type='observed']"/></xsl:if></p>
      </xsl:if>
    </div>

    <xsl:if test="//t:div[@type='translation']//t:p//text()">
      <div id="translation" class="edition_part">
        <h2><i18n:text i18n:key="ppret-translation">Translations</i18n:text></h2>
        <xsl:if test="//t:div[@type='translation'][@xml:lang='en']//t:p//text()">
          <h3><i18n:text i18n:key="ppret-translation-en">English</i18n:text></h3>
          <xsl:apply-templates select="//t:div[@type='translation'][@xml:lang='en']//t:p"/>
        </xsl:if>
        <xsl:if test="//t:div[@type='translation'][@xml:lang='fr']//t:p//text()">
          <h3><i18n:text i18n:key="ppret-translation-fr">French</i18n:text></h3>
          <xsl:apply-templates select="//t:div[@type='translation'][@xml:lang='fr']//t:p"/>
        </xsl:if>
        <xsl:if test="//t:div[@type='translation'][@xml:lang='it']//t:p//text()">
          <h3><i18n:text i18n:key="ppret-translation-it">Italian</i18n:text></h3>
          <xsl:apply-templates select="//t:div[@type='translation'][@xml:lang='it']//t:p"/>
        </xsl:if>
      </div>
    </xsl:if>

    <xsl:if test="//t:div[@type='commentary'][not(@subtype)][not(@n)]//t:p//text()">
      <div id="commentary" class="edition_part">
        <h2><i18n:text i18n:key="ppret-commentary">The inscription and its prefects: critical commentary, updating, overviews</i18n:text></h2>
        <xsl:apply-templates select="//t:div[@type='commentary'][not(@subtype)][not(@n)]//t:p"/>
      </div>
    </xsl:if>

    <div id="bibliography" class="edition_part">
      <h2><i18n:text i18n:key="ppret-bibliography">Bibliography</i18n:text></h2>
      <xsl:for-each select="//t:div[@type='bibliography'][@subtype='other']/t:p/t:bibl">
        <p><xsl:apply-templates select="."/><xsl:text>.</xsl:text></p>
      </xsl:for-each>
    </div>

      <xsl:if test="//t:div[@subtype='prefects']">
        <div id="praetorian-prefects" class="edition_part">
      <h2><i18n:text i18n:key="ppret-praetorian-prefects">Praetorian prefects and epigraphic habit</i18n:text></h2>

      <xsl:if test="//t:div[@subtype='prefects']/t:div[@n='0']"><div><p><xsl:apply-templates select="//t:div[@subtype='prefects']/t:div[@n='0']/t:p[@n='0']//text()"/></p></div></xsl:if>

      <xsl:if test="//t:div[@subtype='prefects']/t:div[@n='1']">
        <div>
          <h3><i18n:text i18n:key="ppret-commentary-number">Number of praetorian prefects in this inscription</i18n:text></h3>
          <xsl:if test="//t:p[@n='1.1']">
            <p><i18n:text i18n:key="ppret-commentary-1.1">Only one praetorian prefect</i18n:text><xsl:if test="//t:p[@n='1.1']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='1.1']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='1.2']">
            <p><i18n:text i18n:key="ppret-commentary-1.2">More than one praetorian prefect</i18n:text><xsl:if test="//t:p[@n='1.2']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='1.2']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='1.3']">
            <p><i18n:text i18n:key="ppret-commentary-1.3">All the praetorian prefects in office</i18n:text><xsl:if test="//t:p[@n='1.3']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='1.3']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='1.4']">
            <p><i18n:text i18n:key="ppret-commentary-1.4">The praetorian prefect is mentioned, without being the person addressing or being addressed</i18n:text><xsl:if test="//t:p[@n='1.4']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='1.4']/node()"/></xsl:if></p>
          </xsl:if>
        </div>
      </xsl:if>

      <xsl:if test="//t:div[@subtype='prefects']/t:div[@n='2']">
        <div>
          <h3><i18n:text i18n:key="ppret-commentary-honour">Inscriptions in honour of praetorian prefects</i18n:text></h3>
          <xsl:if test="//t:p[@n='2.b']">
            <p><i18n:text i18n:key="ppret-commentary-honour-relative">Inscriptions in honour of a praetorian prefect’s relative</i18n:text><xsl:if test="//t:p[@n='2.b']//text()"><xsl:text>: </xsl:text><xsl:apply-templates select="//t:p[@n='2.b']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='2.1']">
            <p><i18n:text i18n:key="ppret-commentary-2.1">Inscriptions in honour of a praetorian prefect made during the praetorian prefecture</i18n:text><xsl:if test="//t:p[@n='2.1']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='2.1']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='2.2']">
            <p><i18n:text i18n:key="ppret-commentary-2.2">Inscriptions in honour of a praetorian prefect made after the end of the praetorian prefecture</i18n:text><xsl:if test="//t:p[@n='2.2']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='2.2']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='2.3']">
            <p><i18n:text i18n:key="ppret-commentary-2.3">Inscriptions in honour of a deceased praetorian prefect, but not funerary</i18n:text><xsl:if test="//t:p[@n='2.3']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='2.3']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='2.4']">
            <p><i18n:text i18n:key="ppret-commentary-2.4">Inscriptions in honour of a praetorian prefect struck by <i>damnatio</i></i18n:text><xsl:if test="//t:p[@n='2.4']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='2.4']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='2.5']">
            <p><i18n:text i18n:key="ppret-commentary-2.5">Inscriptions in honour of a praetorian prefect officially rehabilitated</i18n:text><xsl:if test="//t:p[@n='2.5']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='2.5']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='2.6']">
            <p><i18n:text i18n:key="ppret-commentary-2.6">Statue or portrait of the praetorian prefect preserved</i18n:text><xsl:if test="//t:p[@n='2.6']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='2.6']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='2.7']">
            <p><i18n:text i18n:key="ppret-commentary-2.7">Description of the type of statue over the base</i18n:text><xsl:if test="//t:p[@n='2.7']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='2.7']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='2.8']">
            <p><i18n:text i18n:key="ppret-commentary-2.8">Imperial permission for the statue over the base</i18n:text><xsl:if test="//t:p[@n='2.8']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='2.8']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='2.9']">
            <p><i18n:text i18n:key="ppret-commentary-2.9">Discourse justifying the honour</i18n:text><xsl:if test="//t:p[@n='2.9']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='2.9']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='2.10']">
            <p><i18n:text i18n:key="ppret-commentary-2.10">Panegyric and celebrative formulas</i18n:text><xsl:if test="//t:p[@n='2.10']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='2.10']/node()"/></xsl:if></p>
          </xsl:if>

          <xsl:if test="//t:list[@n='2.11']">
            <h3><i18n:text i18n:key="ppret-commentary-awarder">Awarder of monuments to praetorian prefects</i18n:text></h3>
            <ul>
              <xsl:if test="//t:item[@n='2.11.a']">
                <li class="n"><i18n:text i18n:key="ppret-commentary-2.11a">clients</i18n:text><xsl:if test="//t:item[@n='2.11.a']//text()"><xsl:text>: </xsl:text>
                  <xsl:apply-templates select="//t:item[@n='2.11.a']/node()"/></xsl:if></li>
              </xsl:if>
              <xsl:if test="//t:item[@n='2.11.b']">
                <li class="n"><i18n:text i18n:key="ppret-commentary-2.11b">city/-ies</i18n:text><xsl:if test="//t:item[@n='2.11.b']//text()"><xsl:text>: </xsl:text>
                  <xsl:apply-templates select="//t:item[@n='2.11.b']/node()"/></xsl:if></li>
              </xsl:if>
              <xsl:if test="//t:item[@n='2.11.c']">
                <li class="n"><i18n:text i18n:key="ppret-commentary-2.11c">City Council (<i>ordo</i> / βουλῆ)</i18n:text><xsl:if test="//t:item[@n='2.9.c']//text()"><xsl:text>: </xsl:text>
                  <xsl:apply-templates select="//t:item[@n='2.11.c']/node()"/></xsl:if></li>
              </xsl:if>
              <xsl:if test="//t:item[@n='2.11.d']">
                <li class="n"><i18n:text i18n:key="ppret-commentary-2.11d">province/-es (<i>concilia</i> / κοινά)</i18n:text><xsl:if test="//t:item[@n='2.11.d']//text()"><xsl:text>: </xsl:text>
                  <xsl:apply-templates select="//t:item[@n='2.11.d']/node()"/></xsl:if></li>
              </xsl:if>
              <xsl:if test="//t:item[@n='2.11.e']">
                <li class="n"><i18n:text i18n:key="ppret-commentary-2.11e">colleges and corporations</i18n:text><xsl:if test="//t:item[@n='2.11.e']//text()"><xsl:text>: </xsl:text>
                  <xsl:apply-templates select="//t:item[@n='2.11.e']/node()"/></xsl:if></li>
              </xsl:if>
              <xsl:if test="//t:item[@n='2.11.f']">
                <li class="n"><i18n:text i18n:key="ppret-commentary-2.11f">individuals</i18n:text><xsl:if test="//t:item[@n='2.11.f']//text()"><xsl:text>: </xsl:text>
                  <xsl:apply-templates select="//t:item[@n='2.11.f']/node()"/></xsl:if></li>
              </xsl:if>
              <xsl:if test="//t:item[@n='2.11.g']">
                <li class="n"><i18n:text i18n:key="ppret-commentary-2.11g">emperors</i18n:text><xsl:if test="//t:item[@n='2.11.g']//text()"><xsl:text>: </xsl:text>
                  <xsl:apply-templates select="//t:item[@n='2.11.g']/node()"/></xsl:if></li>
              </xsl:if>
              <xsl:if test="//t:item[@n='2.11.h']">
                <li class="n"><i18n:text i18n:key="ppret-commentary-2.11h">family members</i18n:text><xsl:if test="//t:item[@n='2.11.h']//text()"><xsl:text>: </xsl:text>
                  <xsl:apply-templates select="//t:item[@n='2.11.h']/node()"/></xsl:if></li>
              </xsl:if>
              <xsl:if test="//t:item[@n='2.11.i']">
                <li class="n"><i18n:text i18n:key="ppret-commentary-2.11i">officials</i18n:text><xsl:if test="//t:item[@n='2.11.i']//text()"><xsl:text>: </xsl:text>
                  <xsl:apply-templates select="//t:item[@n='2.11.i']/node()"/></xsl:if></li>
              </xsl:if>
            </ul>
          </xsl:if>
        </div>
      </xsl:if>

      <xsl:if test="//t:div[@subtype='prefects']/t:div[@n='3']">
        <div>
          <h3><i18n:text i18n:key="ppret-commentary-epitaph">Epitaph of praetorian prefects</i18n:text></h3>
          <xsl:if test="//t:p[@n='3.a']">
            <p><i18n:text i18n:key="ppret-commentary-epitaph-relative">Epitaph of a praetorian prefect</i18n:text><xsl:if test="//t:p[@n='3.a']//text()"><xsl:text>: </xsl:text><xsl:apply-templates select="//t:p[@n='3.a']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='3.b']">
            <p><i18n:text i18n:key="ppret-commentary-epitaph-relative">Epitaph of a praetorian prefect’s relative</i18n:text><xsl:if test="//t:p[@n='3.b']//text()"><xsl:text>: </xsl:text><xsl:apply-templates select="//t:p[@n='3.b']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='3']">
            <xsl:if test="//t:p[@n='3']//text()"><p><i18n:text i18n:key="ppret-commentary-3">Dedicant</i18n:text><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='3']/node()"/></p></xsl:if>
          </xsl:if>
        </div>
      </xsl:if>

      <xsl:if test="//t:div[@subtype='prefects']/t:div[@n='4']">
        <div>
          <h3><i18n:text i18n:key="ppret-commentary-property">Inscription identifying a property of a praetorian prefect</i18n:text></h3>
          <xsl:if test="//t:p[@n='4']//text()"><p><xsl:apply-templates select="//t:p[@n='4']/node()"/></p></xsl:if>
        </div>
      </xsl:if>

      <xsl:if test="//t:div[@subtype='prefects']/t:div[@n='5']">
        <div>
          <h3><i18n:text i18n:key="ppret-commentary-legal-to">Inscription containing legal acts sent to praetorian prefects</i18n:text></h3>
          <xsl:if test="//t:p[@n='5']//text()"><p><xsl:apply-templates select="//t:p[@n='5']/node()"/></p></xsl:if>
        </div>
      </xsl:if>

      <xsl:if test="//t:div[@subtype='prefects']/t:div[@n='6']">
        <div>
          <h3><i18n:text i18n:key="ppret-commentary-legal-by">Inscription containing legal acts issued by praetorian prefects</i18n:text></h3>
          <xsl:if test="//t:p[@n='6.a']">
            <p><i18n:text i18n:key="ppret-commentary-6a">Edicts issued by praetorian prefects</i18n:text><xsl:if test="//t:p[@n='6.a']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='6.a']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='6.b']">
            <p><i18n:text i18n:key="ppret-commentary-6b">Epistles issued by praetorian prefects</i18n:text><xsl:if test="//t:p[@n='6.b']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='6.b']/node()"/></xsl:if></p>
          </xsl:if>
        </div>
      </xsl:if>

      <xsl:if test="//t:div[@subtype='prefects']/t:div[@n='7']">
        <div>
          <h3><i18n:text i18n:key="ppret-commentary-monuments">Inscribed monuments made by praetorian prefects</i18n:text></h3>
          <xsl:if test="//t:p[@n='7.1'] or //t:p[@n='7.2']">
            <xsl:if test="//t:p[@n='7.1']">
              <p><i18n:text i18n:key="ppret-commentary-7.1">Inscriptions to Augusti/Caesars made by all the praetorian prefects</i18n:text><xsl:if test="//t:p[@n='7.1']//text()"><xsl:text>: </xsl:text>
                <xsl:apply-templates select="//t:p[@n='7.1']/node()"/></xsl:if></p>
            </xsl:if>
            <xsl:if test="//t:p[@n='7.2']">
              <p><i18n:text i18n:key="ppret-commentary-7.2">Inscriptions to Augusti/Caesars made by a single praetorian prefect</i18n:text><xsl:if test="//t:p[@n='7.2']//text()"><xsl:text>: </xsl:text>
                <xsl:apply-templates select="//t:p[@n='7.2']/node()"/></xsl:if></p>
            </xsl:if>
          </xsl:if>
          <xsl:if test="//t:p[@n='7.y'] or //t:p[@n='7.z']">
            <xsl:if test="//t:p[@n='7.y']">
              <p><i18n:text i18n:key="ppret-commentary-7.y">Praetorian prefect is the author of a monument, but is struck by <i>damnatio</i></i18n:text><xsl:if test="//t:p[@n='7.y']//text()"><xsl:text>: </xsl:text>
                <xsl:apply-templates select="//t:p[@n='7.y']/node()"/></xsl:if></p>
            </xsl:if>
            <xsl:if test="//t:p[@n='7.z']">
              <p><i18n:text i18n:key="ppret-commentary-7.z">Praetorian prefect author of a monument officially rehabilitated</i18n:text><xsl:if test="//t:p[@n='7.z']//text()"><xsl:text>: </xsl:text>
                <xsl:apply-templates select="//t:p[@n='7.z']/node()"/></xsl:if></p>
            </xsl:if>
          </xsl:if>
          <xsl:if test="//t:p[@n='7.3'] or //t:p[@n='7.4'] or //t:p[@n='7.5']">
            <xsl:if test="//t:p[@n='7.3']">
              <p><i18n:text i18n:key="ppret-commentary-7.3">Construction / restoration of a civic building</i18n:text><xsl:if test="//t:p[@n='7.3']//text()"><xsl:text>: </xsl:text>
                <xsl:apply-templates select="//t:p[@n='7.3']/node()"/></xsl:if></p>
            </xsl:if>
            <xsl:if test="//t:p[@n='7.4']">
              <p><i18n:text i18n:key="ppret-commentary-7.4">Construction / restoration of a military building</i18n:text><xsl:if test="//t:p[@n='7.4']//text()"><xsl:text>: </xsl:text>
                <xsl:apply-templates select="//t:p[@n='7.4']/node()"/></xsl:if></p>
            </xsl:if>
            <xsl:if test="//t:p[@n='7.5']">
              <p><i18n:text i18n:key="ppret-commentary-7.5">Construction / restoration of a religious building</i18n:text><xsl:if test="//t:p[@n='7.5']//text()"><xsl:text>: </xsl:text>
                <xsl:apply-templates select="//t:p[@n='7.5']/node()"/></xsl:if></p>
            </xsl:if>
          </xsl:if>
          <xsl:if test="//t:p[@n='7.6'] or //t:p[@n='7.7'] or //t:p[@n='7.8']">
            <xsl:if test="//t:p[@n='7.6']">
              <p><i18n:text i18n:key="ppret-commentary-7.6">Other categories of public inscriptions</i18n:text><xsl:if test="//t:p[@n='7.6']//text()"><xsl:text>: </xsl:text>
                <xsl:apply-templates select="//t:p[@n='7.6']/node()"/></xsl:if></p>
            </xsl:if>
            <xsl:if test="//t:p[@n='7.7']">
              <p><i18n:text i18n:key="ppret-commentary-7.7">Other categories of private inscriptions</i18n:text><xsl:if test="//t:p[@n='7.7']//text()"><xsl:text>: </xsl:text>
                <xsl:apply-templates select="//t:p[@n='7.7']/node()"/></xsl:if></p>
            </xsl:if>
            <xsl:if test="//t:p[@n='7.8']">
              <p><i18n:text i18n:key="ppret-commentary-7.8">Other categories of religious inscriptions</i18n:text><xsl:if test="//t:p[@n='7.8']//text()"><xsl:text>: </xsl:text>
                <xsl:apply-templates select="//t:p[@n='7.8']/node()"/></xsl:if></p>
            </xsl:if>
          </xsl:if>
        </div>
      </xsl:if>

      <xsl:if test="//t:div[@subtype='prefects']/t:div[@n='8']">
        <div>
          <h3><i18n:text i18n:key="ppret-commentary-praetorian-prefecture-in-inscriptions">The praetorian prefecture in inscriptions: titulature, duration and extension of the appointment</i18n:text></h3>
          <xsl:if test="//t:p[@n='8.1']">
            <p><i18n:text i18n:key="ppret-commentary-8.1">The rank of the praetorian prefects</i18n:text><xsl:if test="//t:p[@n='8.1']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='8.1']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='8.2']">
            <p><i18n:text i18n:key="ppret-commentary-8.2">Latin / Greek titulature of the office</i18n:text><xsl:if test="//t:p[@n='8.2']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='8.2']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='8.3']">
            <p><i18n:text i18n:key="ppret-commentary-8.3">Inscription posesses a full <i>cursus honorum</i> of the prefect</i18n:text><xsl:if test="//t:p[@n='8.3']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='8.3']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='8.4']">
            <p><i18n:text i18n:key="ppret-commentary-8.4">Inscription posesses a partial <i>cursus honorum</i> of the prefect</i18n:text><xsl:if test="//t:p[@n='8.4']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='8.4']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='8.5']">
            <p><i18n:text i18n:key="ppret-commentary-8.5">Inscription is without a <i>cursus honorum</i></i18n:text><xsl:if test="//t:p[@n='8.5']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='8.5']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='8.6']">
            <p><i18n:text i18n:key="ppret-commentary-8.6">Inscription records more than one appointment as praetorian prefect</i18n:text><xsl:if test="//t:p[@n='8.6']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='8.6']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='8.7']">
            <p><i18n:text i18n:key="ppret-commentary-8.7">Inscription records the total duration of a mandate as prefect</i18n:text><xsl:if test="//t:p[@n='8.7']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='8.7']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='8.8']">
            <p><i18n:text i18n:key="ppret-commentary-8.8">Inscription records the total duration of several or all mandates as prefect</i18n:text><xsl:if test="//t:p[@n='8.8']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='8.8']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='8.9']">
            <p><i18n:text i18n:key="ppret-commentary-8.9">Inscription only records the current prefecture</i18n:text><xsl:if test="//t:p[@n='8.9']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='8.9']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='8.10']">
            <p><i18n:text i18n:key="ppret-commentary-8.10">Inscription only records the prefecture just completed</i18n:text><xsl:if test="//t:p[@n='8.10']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='8.10']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='8.11']">
            <p><i18n:text i18n:key="ppret-commentary-8.11">Inscription does not record the regional area of the prefecture</i18n:text><xsl:if test="//t:p[@n='8.11']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='8.11']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='8.12']">
            <p><i18n:text i18n:key="ppret-commentary-8.12">Inscription records the regional area of the prefecture</i18n:text><xsl:if test="//t:p[@n='8.12']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='8.12']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='8.13']">
            <p><i18n:text i18n:key="ppret-commentary-8.13">Inscription records the number of prefectures attained by the dignitary without their regional areas</i18n:text><xsl:if test="//t:p[@n='8.13']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='8.13']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='8.14']">
            <p><i18n:text i18n:key="ppret-commentary-8.14">Inscription records all the prefectures attained by the dignitary with their regional areas</i18n:text><xsl:if test="//t:p[@n='8.14']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='8.14']/node()"/></xsl:if></p>
          </xsl:if>
          <xsl:if test="//t:p[@n='8.15']">
            <p><i18n:text i18n:key="ppret-commentary-8.15">Inscription records the geographical origin of the prefect</i18n:text><xsl:if test="//t:p[@n='8.15']//text()"><xsl:text>: </xsl:text>
              <xsl:apply-templates select="//t:p[@n='8.15']/node()"/></xsl:if></p>
          </xsl:if>
        </div>
      </xsl:if>
    </div>
      </xsl:if>


    <!--<div id="publication">
      <p><xsl:if test="//t:titleStmt/t:editor[@role='edition']">
      <i><i18n:text i18n:key="ppret-editor-edition">Edition</i18n:text>: </i>
      <xsl:apply-templates select="//t:titleStmt/t:editor[@role='edition']"/></xsl:if></p>
      <p><xsl:if test="//t:titleStmt/t:editor[@role='encoding']">
      <i><i18n:text i18n:key="ppret-editor-encoding">Encoding</i18n:text>: </i>
      <xsl:apply-templates select="//t:titleStmt/t:editor[@role='encoding']"/></xsl:if></p>
      <p><xsl:if test="//t:publicationStmt/t:date/@when">
      <i><i18n:text i18n:key="ppret-publication_date">Publication date</i18n:text>: </i>
      <xsl:value-of select="format-date(//t:publicationStmt/t:date/@when,'[D01].[M01].[Y0001]')" /></xsl:if></p>
      </div>-->
    </div>
  </xsl:template>

  <xsl:template name="ppret-structure">
    <xsl:variable name="title">
      <xsl:call-template name="ppret-title" />
    </xsl:variable>

    <html>
      <head>
        <title>
          <xsl:value-of select="$title"/>
        </title>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
        <!-- Found in htm-tpl-cssandscripts.xsl -->
        <xsl:call-template name="css-script"/>
      </head>
      <body>
        <h1><!--<xsl:value-of select="$title"/>--></h1>
        <xsl:call-template name="ppret-body-structure" />
      </body>
    </html>
  </xsl:template>

  <xsl:template name="ppret-title">
    <xsl:value-of select="//t:publicationStmt/t:idno[@type='filename']//text()"/>
    <xsl:text>. </xsl:text>
    <xsl:value-of select="//t:titleStmt/t:title"/>
  </xsl:template>

  <xsl:template match="//t:div//t:title">
    <i><xsl:value-of select="."/></i>
  </xsl:template>

  <xsl:template match="//t:foreign">
    <i><xsl:value-of select="."/></i>
  </xsl:template>

  <xsl:template match="//t:sic[not(ancestor::t:choice)]">
    <xsl:apply-templates/> <i><xsl:text> (sic)</xsl:text></i>
  </xsl:template>
  <xsl:template match="//t:corr[not(ancestor::t:choice)]">
    <xsl:text>⌜</xsl:text><xsl:apply-templates/><xsl:text>⌝</xsl:text>
  </xsl:template>

  <xsl:template match="//t:bibl//t:emph">
    <span class="bibl"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="//t:div[@type='commentary']//t:emph">
    <strong><xsl:apply-templates/></strong>
  </xsl:template>

  <xsl:template match="//t:div//t:ref[@target][not(@corresp)]">
    <xsl:variable name="bibl-id" select="substring-after(@target,'#')"/>
    <xsl:choose>
      <xsl:when test="$bibl-id!=''"><a><xsl:attribute name="href"><xsl:value-of select="concat('../texts/bibliography.html#',$bibl-id)"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a></xsl:when>
      <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="t:div//t:ref[@corresp]">
    <xsl:choose>
      <xsl:when test="@type='ppret'">
        <a><xsl:attribute name="href"><xsl:value-of select="concat('./',@corresp,'.html')"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a>
      </xsl:when>
      <xsl:when test="@type='ppo'">
        <a><xsl:attribute name="href"><xsl:value-of select="concat('../texts/',@corresp,'.html')"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a>
      </xsl:when>
      <xsl:otherwise>
        <a><xsl:attribute name="href"><xsl:value-of select="@corresp"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="t:div//t:space[@rend='space']">&#x2003;</xsl:template>
  
  <xsl:template name="navigation">
    <xsl:variable name="filename"><xsl:value-of select="//t:idno[@type='filename']"/></xsl:variable>
    <xsl:variable name="list" select="document(concat('file:',system-property('user.dir'),'/all_inscriptions.xml'))//t:list"/>
    <xsl:variable name="prev" select="$list/t:item[substring-before(@n,'.xml')=$filename]/preceding-sibling::t:item[1]/substring-before(@n,'.xml')"/>
    <xsl:variable name="next" select="$list/t:item[substring-before(@n,'.xml')=$filename]/following-sibling::t:item[1]/substring-before(@n,'.xml')"/>
    
    <div class="row" id="navigation">
      <div class="large-12 columns">
        <p>
        <ul class="pagination left">
          <xsl:if test="$prev">
            <li class="arrow">
              <a>
                <xsl:attribute name="href">
                  <xsl:text>./ppret</xsl:text>
                  <xsl:value-of select="$prev"/>
                  <xsl:text>.html</xsl:text>
                </xsl:attribute>
                <xsl:text>&#171;</xsl:text>
              </a>
            </li>
          </xsl:if>
          
          <xsl:if test="$next">
            <li class="arrow">
              <a>
                <xsl:attribute name="href">
                  <xsl:text>./ppret</xsl:text>
                  <xsl:value-of select="$next"/>
                  <xsl:text>.html</xsl:text>
                </xsl:attribute>
                <xsl:text>&#187;</xsl:text>
              </a>
            </li>
          </xsl:if>
        </ul>
        </p>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
