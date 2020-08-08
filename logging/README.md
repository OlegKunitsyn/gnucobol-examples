## ELK 7.8.1 OSS
Elasticsearch, Logstash, Kibana based on the official open-source Docker images.

### Ports
- `5140` Syslog UDP input
- `9200` Elasticsearch engine
- `5601` Kibana dashboard

### Usage
Start the ELK
```bash
$ cd elk
$ docker-compose up
```

then open [http://localhost:5601](http://localhost:5601) in the browser.    
Received Syslog messages will be stored in `events` index.


## COBOL Microservice
A high-precision currency exchange microservice that exposes HTTP API and returns EUR amount in JSON format.

### Ports
- `8000` HTTP API

### Usage
Start the Microservice
```bash
$ cd microservice
$ docker build --tag microservice .
$ docker run -d -i --name microservice -p 8000:8000 microservice
```

then try in the browser:
- [http://localhost:8000/USD/99.99](http://localhost:8000/USD/99.99)
- [http://localhost:8000/ABC/99.99](http://localhost:8000/ABC/99.99)
- [http://localhost:8000/USD/9999999999999999](http://localhost:8000/USD/9999999999999999)

Stop the Microservice
```bash
$ docker rm --force microservice
```
