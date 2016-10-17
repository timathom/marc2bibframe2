<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Utility templates -->

  <!--
      generate a recordid base from user config
  -->
  <xsl:template match="marc:record" mode="recordid">
    <xsl:param name="baseuri" select="'http://example.org/'"/>
    <xsl:param name="idfield" select="'001'"/>
    <xsl:param name="recordno"/>
    <xsl:variable name="tag" select="substring($idfield,1,3)"/>
    <xsl:variable name="subfield">
      <xsl:choose>
        <xsl:when test="substring($idfield,4,1)">
          <xsl:value-of select="substring($idfield,4,1)"/>
        </xsl:when>
        <xsl:otherwise>a</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="recordid">
      <xsl:choose>
        <xsl:when test="$tag &lt; 10">
          <xsl:if test="count(marc:controlfield[@tag=$tag]) = 1">
            <xsl:value-of select="marc:controlfield[@tag=$tag]"/>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="count(marc:datafield[@tag=$tag]/marc:subfield[@code=$subfield]) = 1">
            <xsl:value-of select="normalize-space(marc:datafield[@tag=$tag]/marc:subfield[@code=$subfield])"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$recordid != ''">
        <xsl:value-of select="$baseuri"/><xsl:value-of select="$recordid"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="no">
          <xsl:text>WARNING: Unable to determine record ID for record </xsl:text><xsl:value-of select="$recordno"/><xsl:text>. Using generated ID.</xsl:text>
        </xsl:message>
        <xsl:value-of select="$baseuri"/><xsl:value-of select="generate-id(.)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
      create a space delimited label
      need to trim off the trailing space to use
  -->
  <xsl:template match="*" mode="concat-nodes-space">
    <xsl:value-of select="."/><xsl:text> </xsl:text>
  </xsl:template>

</xsl:stylesheet>