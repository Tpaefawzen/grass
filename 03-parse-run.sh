#!/bin/sh

# pub
awk 'BEGIN {
   globls = split("read 119 next out", globl);
}

/^w/ {
   for (i=2; i<=NF; i++) $i = -length($i);
   globl[++globls] = $0;
   next
}

/^W/ {
   for (i=1; i<=NF; i++) globls[++globls] = (-length($i)) OFS (-length($(i+1)));
   next
}

END {
   for (i in globl) print i,globl[i]                                                    }'
