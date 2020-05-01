FROM jboss/keycloak:10.0.0

# add a new admin user called keycloak using keycloak as credential
RUN /opt/jboss/keycloak/bin/add-user.sh -u keycloak -p keycloak -r ManagementRealm --silent