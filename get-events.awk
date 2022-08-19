function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s; }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s; }
function trim(s)  { return rtrim(ltrim(s)); }
function fixlocation(s) { gsub(/\\/, "", s); return s; }
function getcurrentyear() { return strftime("%Y", systime()) }

BEGIN {
    FS = ":";
    OFS = " ";
}

{
    KEY = $1;
    VALUE = trim($2);
}

KEY == "BEGIN" && VALUE == "VEVENT" {
    DTSTART = "";
    DTEND = "";
    SUMMARY = "";
    LOCATION = "";
    START_DATE = "";
    START_TIME = "";
    START_DATE_YEAR = "";
    START_DATE_MONTH = "";
    END_DATE = "";
    END_TIME = "";
    END_DATE_YEAR = "";
    END_DATE_MONTH = "";
    SUMMARY = "";
    LOCATION = "";
    UID="";
}

KEY ~ /^DTSTART/ { 
    START_DATE = substr(VALUE, 1, 4) "-" substr(VALUE, 5, 2) "-" substr(VALUE, 7, 2);
    START_TIME = substr(VALUE, 10, 2) ":" substr(VALUE, 12, 2) ;
    START_DATE_YEAR = substr(START_DATE, 1, 4);
    START_DATE_MONTH = substr(START_DATE, 6, 2);

    if (START_TIME == ":") {
        START_TIME = "";
    }
}

KEY ~ /^DTEND/ { 
    END_DATE = substr(VALUE, 1, 4) "-" substr(VALUE, 5, 2) "-" substr(VALUE, 7, 2);
    END_TIME = substr(VALUE, 10, 2) ":" substr(VALUE, 12, 2);

    if (END_TIME == ":") {
        END_TIME = "";
    }

    END_DATE_YEAR = substr(END_DATE, 1, 4);
    END_DATE_MONTH = substr(END_DATE, 6, 2);
}

KEY == "UID" {
    UID = VALUE;
}

KEY == "SUMMARY" { 
    SUMMARY = VALUE;
}

KEY == "LOCATION" { 
    LOCATION = fixlocation(VALUE);
}

KEY == "END" && VALUE == "VEVENT" {
    if (END_DATE == "") {
        END_DATE = START_DATE;
    }

    if (START_DATE < END_DATE) {
        print START_DATE " - " END_DATE " " SUMMARY 
    }
    else if (START_TIME == "") {
        print START_DATE " " SUMMARY 
    } 
    else {
        print START_DATE " (" START_TIME ") - " END_DATE " (" END_TIME ") " SUMMARY 
    }
}
