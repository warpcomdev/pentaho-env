#!/bin/bash

# Check prerequisites
/opt/check.sh || exit $?

# Compile pentaho dsp
if [ ! -f "${PENTAHO_HOME}/tomcat/webapps/pentaho/WEB-INF/lib/pentaho-dsp.jar" ]; then
  /opt/pentaho-dsp.sh || (echo "REQUIREMENT ERROR: failed to compile pentaho-dsp"; exit -100)
fi

# Prepare volume
/opt/prep.sh  || exit $?

# Run pentaho server
exec ${PENTAHO_HOME}/tomcat/bin/startup.sh

