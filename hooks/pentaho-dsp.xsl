<!--
    Copyright 2020 Telefónica Soluciones de Informática y Comunicaciones de España, S.A.U.

    This file is part of Pentaho DSP.

    Pentaho DSP is free software: you can redistribute it and/or
    modify it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    Pentaho DSP is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero
    General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Orion Context Broker. If not, see http://www.gnu.org/licenses/.

    For those usages not covered by this license please contact with
    sc_support at telefonica dot com
-->
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
