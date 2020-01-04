#!/bin/sh

state=`acpi -b | cut -d" " -f3 | cut -d, -f1`
level=`acpi -b | cut -d, -f2 | cut -d" " -f2`
prefix=""

if [ "$state" = "Discharging" ]
then
    prefix="-"

elif [ "$state" = "Full" ]
then
    prefix="="
else
    prefix="+"
fi

echo "$prefix$level"
