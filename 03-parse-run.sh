#!/bin/sh

# pub
awk -v file="${1:?}" '
BEGIN {
   globls = split("read 119 next out", globl);

   while ((getline <file) > 0) {
      if (/^w/) {
	 for (i=2; i<=NF; i++)
	    $i = -length($i);
	 globl[++globls] = $0;
      } else if (/^W/) {
	 for (i=1; i<=NF; i++)
	    globl[++globls] = (-length($i)) OFS (-length($(++i)));
      } else {
	 Unreachable();
      }
   }

exit

}

END {
   for (i in globl) print i, globl[i];
}

function Unreachable() {
   print "WTF", NR, $0 | "cat 1>&2"
   exit 1
}
'
