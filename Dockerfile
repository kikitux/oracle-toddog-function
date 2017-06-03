FROM    store/oracle/database-instantclient:12.2.0.1 
ADD     scripts/preparecontainer.sh /
RUN     bash /preparecontainer.sh
ADD     scripts/build.sh /
RUN     chmod +x /build.sh
CMD     /build.sh
