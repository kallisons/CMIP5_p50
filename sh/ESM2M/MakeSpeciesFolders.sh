#!/bin/sh

while IFS=, read -r species p50 deltaH
do
  
  mkdir /Data/Projects/CMIP5_p50/ESM2M_Blood/${species}/depthp50max

done