#!/bin/sh

tr '\0' '.' |
sed 's/ｖ/v/g; s/ｗ/w/g; s/Ｗ/W/g' |
tr -Cd 'Wwv' |
tr v '\n' |
grep ^. |
sed 's/\(.\)\1\{0,\}/& /g'
