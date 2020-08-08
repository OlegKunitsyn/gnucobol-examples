       >>SOURCE FORMAT FREE
identification division.
program-id. microservice.
environment division.
configuration section.
repository. 
    function csv-ecb-rates
    function all intrinsic.
input-output section.
file-control.
    select file-csv assign to "resources/eurofxref.csv" 
    organization is sequential
    file status is file-status.
data division.
file section.
fd file-csv.
    01 csv-content pic x(1024).
working-storage section.
    78 SYSLOG-FACILITY-USER value 8.
    78 SYSLOG-SEVERITY-ERRROR value 3.
    01 file-status pic x(2).
        88 file-exists value "00".
    01 dataset external.
        05 dataset-ptr usage pointer.
procedure division. 
    *> read CSV file into csv-content
    open input file-csv.
    if not file-exists
        display "Error reading file" upon syserr
        stop run
    end-if. 
    perform until exit
        read file-csv at end exit perform end-read
    end-perform.
    close file-csv.

    *> convert csv-content to the list of key-value pairs
    move csv-ecb-rates(csv-content) to dataset.

    *> start HTTP server with http-handler callback
    call "receive-tcp" using "localhost", 8000, 0, address of entry "http-handler".
end program microservice.

identification division.
program-id. http-handler.
environment division.
configuration section.
repository. function all intrinsic.
data division.
working-storage section.
    78 CRLF value x"0D" & x"0A".
    78 HTTP-OK value "200 OK".
    78 HTTP-NOT-FOUND value "404 Not Found".
    01 dataset external.
        05 dataset-ptr usage pointer.
    01 exchange-rates based.
        05 filer occurs 64 times indexed by idx.
            10 rate-currency pic x(3).
            10 rate-value pic 9(7)V9(8).
    01 request-method pic x(3).
        88 http-get value "GET".
    01 request-path.
        05 filler pic x value "/".
        05 get-currency pic x(3).
        05 filler pic x value "/".
        05 get-amount pic x(32).
    01 response.
        05 response-header.
            10 filler pic x(9) value "HTTP/1.1" & SPACE.
            10 response-status pic x(13).
            10 filler pic x(2) value CRLF.
            10 filler pic x(32) value "Content-Type: application/json" & CRLF.
            10 filler pic x(16) value "Content-Length: ".
            10 response-content-length pic 9(2).
            10 filler pic x(2) value CRLF.
            10 filler pic x(2) value CRLF.
        05 response-content.
            10 filler pic x(11) value '{"amount": '.
            10 eur-amount pic z(14)9.9(16).
            10 filler pic x(1) value '}'.
linkage section.
    01 l-buffer pic x any length.
    01 l-length usage binary-int unsigned.
procedure division using l-buffer, l-length returning omitted.
    *> initialize exchange rates
    set address of exchange-rates to dataset-ptr.
    
    *> parse request as "GET /<currency>/<amount>"
    unstring l-buffer(1:l-length) delimited by all SPACES into 
       request-method, request-path.
    if not http-get
        perform response-NOK
    end-if.

    *> find currency and calculate eur-amount
    perform varying idx from 1 by 1 until idx > 64
        if rate-currency(idx) = get-currency
            compute eur-amount = numval(get-amount) / rate-value(idx) 
                on size error perform response-NOK
            end-compute
           perform response-OK
        end-if
    end-perform.

    *> or nothing
    perform response-NOK.

response-OK section.
    move HTTP-OK to response-status.
    move byte-length(response-content) to response-content-length.
    perform response-any.

response-NOK section.
    move HTTP-NOT-FOUND to response-status.
    move 0 to response-content-length.
    perform response-any.

response-any section.
    string response delimited by size into l-buffer.
    compute l-length = byte-length(response-header) + response-content-length.
    goback.
end program http-handler.

copy "modules/modules.cpy".
