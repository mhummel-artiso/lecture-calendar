FROM quay.io/keycloak/keycloak:22.0.1 as builder
COPY ./providers /opt/keycloak/providers/
# see: https://gist.github.com/xgp/768eea11f92806b9c83f95902f7f8f80
ENV KC_CACHE_CONFIG_FILE=cache-ispn-jdbc-ping.xml
COPY ./cache-ispn-jdbc-ping.xml /opt/keycloak/conf/cache-ispn-jdbc-ping.xml
RUN /opt/keycloak/bin/kc.sh build --cache ispn
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]