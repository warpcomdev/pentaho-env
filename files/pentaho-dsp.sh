#!/bin/bash

set -eoux pipefail

# Get the code for the multi-tenant solution
cd /tmp
git clone https://github.com/telefonicasc/pentaho-dsp.git
cd pentaho-dsp
cp pom.xml pom.new.xml

# Replace dependencies in the POM file, with the actual versions
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
	   /opt/pentaho-dsp.xsl pom.new.xml && \
  mv -f pom.modified.xml pom.new.xml

done

# Now, compile
/usr/local/bin/mvn -q -B initialize
/usr/local/bin/mvn -q -B package

# And move to the proper location
mv target/pentaho-dsp-*.jar "${PENTAHO_HOME}/tomcat/webapps/pentaho/WEB-INF/lib/pentaho-dsp.jar"
