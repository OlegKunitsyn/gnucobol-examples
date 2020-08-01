       >>SOURCE FORMAT FREE
*>*
*> Calculate IBAN checksum for 64 countries
*> https://en.wikipedia.org/wiki/International_Bank_Account_Number#Validating_the_IBAN
*> 
*> @param l-iban IBAN string
*> @return '1' in case of success
*>*
identification division.
function-id. iban-checksum.
environment division.
configuration section.
repository. function all intrinsic.
data division.
working-storage section.
    01 filler value 
       "AD24" &
       "AE23" &
       "AL28" &
       "AT20" &
       "AZ28" &
       "BA20" &
       "BE16" &
       "BG22" &
       "BH22" &
       "BR29" &
       "CH21" &
       "CR21" &
       "CY28" &
       "CZ24" &
       "DE22" &
       "DK18" &
       "DO28" &
       "EE20" &
       "ES24" &
       "FI18" &
       "FO18" &
       "FR27" &
       "GB22" &
       "GE22" &
       "GI23" &
       "GL18" &
       "GR27" &
       "GT28" &
       "HR21" &
       "HU28" &
       "IE22" &
       "IL23" &
       "IS26" &
       "IT27" &
       "KW30" &
       "KZ20" &
       "LB28" &
       "LI21" &
       "LT20" &
       "LU20" &
       "LV21" &
       "MC27" &
       "MD24" &
       "ME22" &
       "MK19" &
       "MR27" &
       "MT31" &
       "MU30" &
       "NL18" &
       "NO15" &
       "PK24" &
       "PL28" &
       "PS29" &
       "PT25" &
       "RO24" &
       "RS22" &
       "SA24" &
       "SE24" &
       "SI19" &
       "SK24" &
       "SM27" &
       "TN24" &
       "TR26" &
       "VG24".
       05 country-lengths occurs 64 times indexed by country-lengths-idx.
           10 country-code pic x(2).
           10 country-length pic 9(2).
    01 ws-idx pic 9(2).
    01 ws-iban-numeric pic x(64) value SPACES.
    01 ws-digit-idx pic 9(2) value 1.
    01 ws-letter-digits pic 9(2).
    01 ws-iban pic x(64) value SPACES.
linkage section.
    01 l-iban pic x any length.
    01 l-checksum pic 9 value 0.
procedure division using l-iban returning l-checksum.
    initialize ws-iban-numeric, ws-digit-idx, l-checksum, ws-iban all to value.
    
    *> #1
    set country-lengths-idx to 1.
    search country-lengths at end goback
        when country-code(country-lengths-idx) equals l-iban(1:2)
           if country-length(country-lengths-idx) not equals length(l-iban)
               goback
           end-if
    end-search.

    *> #2
    move l-iban(5:) to ws-iban.
    move l-iban(1:4) to ws-iban(length(l-iban) - 3:).

    *> #3
    perform varying ws-idx from 1 by 1 until ws-idx > length(l-iban)
        if ws-iban(ws-idx:1) is numeric
            move ws-iban(ws-idx:1) to ws-iban-numeric(ws-digit-idx:1)
            add 1 to ws-digit-idx
        else
            compute ws-letter-digits = ord(ws-iban(ws-idx:1)) - ord("A") + 10
            move ws-letter-digits to ws-iban-numeric(ws-digit-idx:2)
            add 2 to ws-digit-idx
        end-if
    end-perform.

    *> #4
    move mod(numval(ws-iban-numeric), 97) to l-checksum.
end function iban-checksum.
