#!/bin/bash

ETH_STR_HEAD="12:34:"
# will generate remain 4 pair of hex number
# xx:xx:xx:xx
ADDR_PART1=`printf "%04x\n" $RANDOM`
ADDR_PART2=`printf "%04x\n" $RANDOM`

ETH_STR_HEAD=`echo $ADDR_PART1 | awk '{print head substr($0, 1, 2) ":" substr($0, 3, 2) ":"}' head=$ETH_STR_HEAD`

ETH_STR_HEAD=`echo $ADDR_PART2 | awk '{print head substr($0, 1, 2) ":" substr($0, 3, 2)}' head=$ETH_STR_HEAD`

echo $ETH_STR_HEAD
