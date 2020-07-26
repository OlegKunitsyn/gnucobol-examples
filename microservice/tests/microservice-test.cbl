       >>SOURCE FORMAT FREE
identification division.
program-id. microservice-test.
environment division.
configuration section.
repository.
    function csv-ecb-rates
    function substr-pos
    function all intrinsic.
data division.
working-storage section.
    01 dataset external.
        05 dataset-ptr usage pointer.
    01 buffer pic x(1024) value "GET /USD/1 HTTP1.1".
procedure division.
    move csv-ecb-rates(concatenate("Date, USD, " x"0a" "17 July 2020, 1.1428, ")) to dataset.
    call "http-handler" using buffer, byte-length(buffer).
    perform http-handler-test.
    goback.

http-handler-test section.
    call "assert-notequals" using 0, substr-pos(buffer, "HTTP/1.1 200 OK").
    call "assert-notequals" using 0, substr-pos(buffer, "Content-Type: application/json").
    call "assert-notequals" using 0, substr-pos(buffer, "Content-Length: 44").
    call "assert-equals" using 104, substr-pos(buffer, "0.8750437521876093").
end program microservice-test.

copy "src/microservice.cbl".
