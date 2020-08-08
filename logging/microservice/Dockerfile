FROM olegkunitsyn/gnucobol:2.2
RUN mkdir /microservice
WORKDIR /microservice
COPY . .
EXPOSE 8000
RUN cobolget -t bca12d6c4efed0627c87f2e576b72bdb5ab88e34 install
ENTRYPOINT ["/bin/ash", "-c", "/usr/local/bin/cobc -j -x src/microservice.cbl"]
