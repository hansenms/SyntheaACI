FROM ubuntu-debootstrap

WORKDIR /app

#Installing JAVA and Synthea
RUN apt-get update && apt-get install -y software-properties-common python3-software-properties
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN apt-get install -yq --allow-unauthenticated oracle-java8-installer git

RUN git clone https://github.com/synthetichealth/synthea.git && \
    cd synthea && \
    ./gradlew build check test 

COPY generate_patients.sh ./
RUN chmod +x generate_patients.sh
ENTRYPOINT [ "bash", "-c", "./generate_patients.sh" ]