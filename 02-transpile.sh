#!/bin/sh

# pub
awk -v CheckOob="${check_oob:-}" '
BEGIN {
   print "f1 = read";
   print "f2 = 119";
   print "f3 = next";
   print "f4 = out";

   last_fn = 4;
}

substr($1,1,1) == "w" { parseFn(); next }
substr($1,1,1) == "W" { parseApp(); next }

END {
   if (!err)
   print "main = f" last_fn " f" last_fn;
}

function parseFn() {
   s = "f" ++last_fn;
   args = length($1);
   for (last_var = last_fn; args--; last_var++)
      s = s OFS "v" last_var;
   last_var--;
   s = s OFS "=";
   print s

   for (i=2; i<=NF; ) {
      s = "  let";
      s = s OFS "v" (++last_var);
      s = s OFS "=";
      s = s OFS tryGetFn2($(i++));
      s = s OFS tryGetFn2($(i++));
      s = s OFS "in";
      print s;
   }

   print "  v" last_var;
}
function tryGetFn2(n) {
   n = length(n);
   n = last_var -  n;
   if (n >= last_fn) return "v" n;
   if (n >= 1) return "f" n;
   if (CheckOob) error("Error inside function: attempted to get f" n);
   return "f" n;
}

function parseApp() {
  for (i = 1; i<=NF; ) {
      s = "f" ++last_fn;
   s = s OFS "=";
      s = s OFS tryGetFn1($(i++));
      s = s OFS tryGetFn1($(i++));
      print s;
   }
}
function tryGetFn1(n) {
   n = length(n);
   n = last_fn - n;
   if (n >= 1) return "f" n;
   if (CheckOob) error("Error for app: attempted to get f" n);
   return "f" n;
}

function error(msg) {
   print "Compile error:" NR ": " msg | "cat 1>&2";
   print "Compile error:" NR ": original tokens: " $0 | "cat 1>&2";
   exit (err=1);
}
'
