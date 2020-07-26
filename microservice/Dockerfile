FROM olegkunitsyn/gnucobol:2.2
RUN mkdir /microservice
WORKDIR /microservice
COPY . .
EXPOSE 8000
RUN cobc -x -debug modules/gcblunit/gcblunit.cbl tests/* --job='microservice-test'
