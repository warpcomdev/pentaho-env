<xsl:stylesheet version="1.0"
  xmlns:pom="http://maven.apache.org/POM/4.0.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="no" />

  <!--
    Usage: xsltproc -stringparam dependency mondrian -stringparam path lib/mondrian-3.0.jar -stringparam version 3.0 pentaho-dsp.xsl pom.xml 
  -->

  <!-- Artifact ID -->
  <xsl:param name="dependency"/>
  <!-- Path to mondrian .jar file -->
  <xsl:param name="path"/>
  <!-- Dependency version -->
  <xsl:param name="version"/>

  <!-- Replace dependency path -->
  <!-- We cannot replace parameter inside XPath strings,
       that's why we cannot simply do:
       pom:configuration[../pom:id/text()=$dependency]/pom:file -->
  <xsl:template match="pom:execution/pom:configuration/pom:file">
    <xsl:choose>
      <!-- If this file is inside the dependency context, replace it -->
      <xsl:when test="../../pom:id/text() = $dependency">
        <xsl:copy>
          <xsl:value-of select="$path"/>
        </xsl:copy>
      </xsl:when>
      <!-- Otherwise, leave as is -->
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Replace dependency version -->
  <xsl:template match="pom:execution/pom:configuration/pom:version">
    <xsl:choose>
      <!-- If this file is inside the dependency context, replace it -->
      <xsl:when test="../../pom:id/text() = $dependency">
        <xsl:copy>
          <xsl:value-of select="$version"/>
        </xsl:copy>
      </xsl:when>
      <!-- Otherwise, leave as is -->
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Replace artifact version -->
  <xsl:template match="pom:dependency/pom:version">
    <xsl:choose>
      <!-- If this file is inside the dependency context, replace it -->
      <xsl:when test="../pom:artifactId/text() = $dependency">
        <xsl:copy>
          <xsl:value-of select="$version"/>
        </xsl:copy>
      </xsl:when>
      <!-- Otherwise, leave as is -->
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Identity template. Do not touch unmatched nodes -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
