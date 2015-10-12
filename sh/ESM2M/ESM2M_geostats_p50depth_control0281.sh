#!/bin/sh
rm geostats.jnl
rm /Data/Projects/CMIP5_p50/ESM2M_Blood/P50Depthav_geostats.txt

while IFS=, read -r species p50 deltaH
do
      rm /Data/Projects/CMIP5_p50/ESM2M_Blood/${species}/P50Depthav_geostats_control0281.txt

      echo "SET DATA \"/Data/CMIP5/ESM2M/processed/controls/ocean.0281-0300.temp.nc\", \"/Data/CMIP5/ESM2M/processed/controls/esm2m.0281-0300.po2.nc\"" > geostats.jnl

      echo "Let p50_critter = ${p50}" >> geostats.jnl #kPa

      echo "Let deltaH_critter = ${deltaH}" >> geostats.jnl  #kJ mol^-1

      echo "Let R =  0.008314" >> geostats.jnl  #kJ mol^-1 K^-1 universal gas constant

      echo "Let tempK = temp[d=1]" >> geostats.jnl #Convert to Kelvin

      echo "Let tempK_ml = temp[d=1, z=10]" >> geostats.jnl #Convert to Kelvin

      echo "Let tempshift_p50 = (deltaH_critter*((1/tempK)-(1/tempK_ml))/(2.303*R))" >> geostats.jnl #Van't Hoff Equation

      echo "Let p50 = 10^(log(p50_critter) + tempshift_p50)" >> geostats.jnl

      echo "Let p50_diff = po2[d=2]-p50" >> geostats.jnl

      echo "Let p50depth = p50_diff[z=@loc:0]" >> geostats.jnl

      echo "Let p50av = p50[l=@ave]" >> geostats.jnl

      echo "Let p50av_diff = po2[d=2,l=@ave]-p50av" >> geostats.jnl

      echo "Let p50depthav = p50av_diff[z=@loc:0]" >> geostats.jnl

      echo "Let ocean = temp[d=1]*0+1" >> geostats.jnl

      echo "Let p50depth_area = p50depth*0+1" >> geostats.jnl

      echo "Let tempav = temp[d=1, l=@ave]" >> geostats.jnl

      echo "Let oceanav= tempav*0+1" >> geostats.jnl

      echo "Let p50depthav_area = p50depthav*0+1" >> geostats.jnl

      echo "list/clobber/nohead/file=\"/Data/Projects/CMIP5_p50/ESM2M_Blood/${species}/P50Depth_geostats_control0281.txt\"/format=tab/append ocean[x=@din, y=@din, k=1], p50depth_area[x=@din, y=@din], p50depth[x=@ave, y=@ave], p50depth[x=@var, y=@var], p50depth[x=@ngd, y=@ngd]" >> geostats.jnl

      echo "list/clobber/nohead/file=\"/Data/Projects/CMIP5_p50/ESM2M_Blood/P50Depthav_geostats.txt\"/format=tab/append \"control0281\", \"${species}\", ${p50}, ${deltaH}, oceanav[x=@din, y=@din, k=1], p50depthav_area[x=@din, y=@din], p50depthav[x=@ave, y=@ave], p50depthav[x=@var, y=@var], p50depthav[x=@ngd, y=@ngd]" >> geostats.jnl

      echo "quit" >> geostats.jnl

      ferret <  geostats.jnl > ferret_out.txt

      rm ferret.jnl*

done
