#!/bin/sh

awk -v beginWithAbs="${begin_with_abs:-1}" '
NR == 1 && begin_with_abs {
   if (substr($1,1,1) != "w") {
      error("Must begin with function definition");
   }
}

substr($1,1,1) == "w" {
   if (NF % 2 != 1) {
      error("Expected function has odd-number tokens, got " NF);
   }
   next
}

substr($1,1,1) == "W" {
   if (NF % 2 != 0) {
      error("Expected application has even-number tokens, got " NF);
   }
   next
}

{
   error("Unreachable");
}

function error(msg) {
   print "Grammar checker:" NR ": " msg | "cat 1>&2";
   print "Grammar checker: original tokens: " $0 | "cat 1>&2";
   exit 1
}
'
