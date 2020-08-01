FROM olegkunitsyn/gnucobol:2.2
WORKDIR /package
COPY . .
RUN cobolget install
RUN cobc -x -debug modules/gcblunit/gcblunit.cbl tests/* --job='banking-test'
