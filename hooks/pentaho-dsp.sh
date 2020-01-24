#!/bin/bash
# Copyright 2020 Telefónica Soluciones de Informática y Comunicaciones de España, S.A.U.
#
# This file is part of Pentaho DSP.
#
# Pentaho DSP is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Pentaho DSP is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero
# General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Orion Context Broker. If not, see http://www.gnu.org/licenses/.
#
# For those usages not covered by this license please contact with
# sc_support at telefonica dot com

set -eoux pipefail

# Replace dependencies in the POM file, with the actual versions
echo "ACTUALIZANDO dependencias de pentaho-dsp"
cd /home/pentaho; cp pom.xml pom.new.xml
for DEPENDENCY in mondrian pentaho-platform-core pentaho-platform-api; do

  # Locate the .jar file
  export FILES=(${PENTAHO_HOME}/tomcat/webapps/pentaho/WEB-INF/lib/${DEPENDENCY}-*.jar)
  export FILE=${FILES[0]}

  # Isolate the version number
  export BASE=`basename "${FILE}" .jar`
  export VERSION=${BASE#"${DEPENDENCY}-"}
  
  # And feed the parameters into the POM
  xsltproc --stringparam dependency "${DEPENDENCY}" \
	   --stringparam path "${FILE}" \
	   --stringparam version "${VERSION}" \
	   -o pom.modified.xml \
	   /opt/hooks/pentaho-dsp.xsl pom.new.xml && \
  mv -f pom.modified.xml pom.new.xml

done

# Now, recompile with the proper version of the pentaho libs
echo "COMPILANDO pentaho-dsp offline"
/usr/local/bin/mvn -o -q -B --file pom.new.xml initialize
/usr/local/bin/mvn -o -q -B --file pom.new.xml package

# And move to the proper location
echo "INSTALANDO libreria pentaho-dsp en WEB-INF/lib"
mv target/pentaho-dsp-*.jar "${PENTAHO_HOME}/tomcat/webapps/pentaho/WEB-INF/lib/pentaho-dsp.jar"
