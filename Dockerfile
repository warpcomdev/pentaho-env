FROM fivecorp/pentaho-env:v8.3.6

MAINTAINER warpcom

# Startup scripts for pentaho-dsp
USER root
ADD files /opt/

USER pentaho
CMD "/opt/start-with-dsp.sh"
