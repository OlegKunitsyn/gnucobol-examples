       >>SOURCE FORMAT FREE
identification division.
program-id. banking-test.
environment division.
configuration section.
repository.
    function iban-checksum.
data division.
working-storage section.
procedure division.
    call "assert-equals" using "1", iban-checksum("BE71096123456769").
    call "assert-equals" using "1", iban-checksum("FR7630006000011234567890189").
    call "assert-equals" using "1", iban-checksum("DE91100000000123456789").
    call "assert-equals" using "1", iban-checksum("GR9608100010000001234567890").

    call "assert-equals" using "1", iban-checksum("RO09 BCYP 0000 0012 3456 7890").
    call "assert-equals" using "1", iban-checksum("ES79 2100 0813 6101 2345 6789").
    call "assert-equals" using "1", iban-checksum("CH56 0483 5012 3456 7800 9").
    call "assert-equals" using "1", iban-checksum("GB98 MIDL 0700 9312 3456 78").
end program banking-test.

copy "src/banking.cbl".
