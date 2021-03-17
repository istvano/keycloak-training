FROM jboss/keycloak:11.0.3

USER root
RUN microdnf update -y && microdnf install -y curl findutils && microdnf clean all

USER jboss
ENV TRAINING_HOME /tmp/workspace/training
RUN curl --create-dirs https://keycloak-docs.herokuapp.com/filelist.txt -o $TRAINING_HOME/filelist.txt
RUN cat $TRAINING_HOME/filelist.txt | xargs -n 2 | xargs -I{} sh -c 'V="{}"; curl --create-dirs ${V% *} -o ${V#* }'

# add a new admin user called keycloak using keycloak as credential
RUN /opt/jboss/keycloak/bin/add-user.sh -u keycloak -p keycloak -r ManagementRealm --silent