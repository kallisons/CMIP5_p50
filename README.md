### CMIP5 P<sub>50</sub> Tuna Analysis  
-----------------------------  
The CMIP5 P<sub>50</sub> Tuna Analysis calculates metrics related to blood-oxygen binding, which is a mechanism determining hypoxia tolerance in the ocean.  Blood-oxygen binding is measured as the oxygen pressure in the blood at which whole blood is 50% oxygenated, called P<sub>50</sub>. A low P<sub>50</sub> means that respiratory pigments in the blood of an organism equilibrate to 100% oxygenation at lower oxygen pressures, and the organism is more hypoxia tolerant. Temperature alters hypoxia tolerance by shifting the P<sub>50</sub> of organisms.  According to results from the Coupled Model Intercomparison Project Phase 5 (CMIP5) RCP 8.5, temperature and oxygen are projected to change by 2100.  This analysis calculates the effects of these changes on the blood-oxygen binding and hypoxia tolerance of tuna species.  Comparisons are made among tuna species with different physiological adaptations.   

**Please cite the following paper if you use this code:**

Mislan, K. A. S., C. A. Deutsch, R. W. Brill, J. P. Dunne, and J. L. Sarmiento. (2017) Projections of climate driven changes in tuna vertical habitat based on species-specific differences in blood oxygen affinity. Global Change Biology.

---------------------------
#### Software dependencies
---------------------------
**All the required software is open source.**

NOAA Ferret v7:[http://www.ferret.noaa.gov/Ferret/](http://www.ferret.noaa.gov/Ferret/)

Python 3.5.1 [https://www.python.org/](https://www.python.org/)
Anaconda 4.0.0 (x86_64) [https://www.continuum.io](https://www.continuum.io)
Python packages: scipy 0.19.0, basemap 1.1.0, netcdf4 1.2.2, numpy 1.11.3, matplotlib 1.5.1, pandas 0.18.0, cmocean 1.0

R v3.3.3: [http://www.r-project.org/](http://www.r-project.org/)  
R packages: ncdf4 1.16, viridis 0.4.0

GMT 5.4.1

NCO 4.6.7 (Installed using `conda install -c conda-forge nco` otherwise had an error with linking the hdf5 libraries.)

GDAL 1.11.5  (Installed using `brew install gdal`)

**Operating system information:**

Mac OS X and Unix-like operating systems should be able to install NOAA Ferret and R without any additional dependencies.

NOAA Ferret running under Windows is not currently supported.  The NOAA Ferret [documentation](http://ferret.pmel.noaa.gov/Ferret/downloads/downloading_ferret) has suggestions for running NOAA Ferret on Windows operating systems.

---------------
#### Folders
---------------

**data:** This folder is for the World Ocean Atlas (WOA) data, Coupled Model Intercomparison Project Phase 5 (CMIP5) model results, and the International Union for the Conservation of Nature (IUCN) data.  The World Ocean Atlas data files and the CMIP5 model results files that we used for the analysis can be downloaded here: [https://doi.org/10.5281/zenodo.807748](https://doi.org/10.5281/zenodo.807748).  The IUCN data must be requested from the IUCN (see below).  

**ferret:** This folder contains the NOAA ferret code for doing the analysis.

**graphs:**  This folder is where graphs generated by the Python code and R code are located.

**pyCode:**  This folder contains the Python code that is used to generate the geographic maps.

**RCode:**  This folder contains the R code that is used to test and generate plots of the results.

**results:**  This folder contains the results that are generated by the shell scripts that run the NOAA Ferret software.

**sh:**  The shell scripts automate the calculation of changes in P<sub>50</sub> depth due to changes in climate using the NOAA Ferret software.   

**testfiles:**  Contains test files to verify that the results were generated by the code are correct.


--------------------------
#### Environmental data
--------------------------
#### WOA data

The WOA data files that serve as the starting point for this analysis can be downloaded here:   
[https://doi.org/10.5281/zenodo.807748](https://doi.org/10.5281/zenodo.807748)

The original files are from:   
[https://www.nodc.noaa.gov/OC5/WOA09/netcdf_data.html](https://www.nodc.noaa.gov/OC5/WOA09/netcdf_data.html)


#### CMIP5 results   

Files with some pre-processing were used for this study.  The pre-processing included regridding the results from each model to the WOA grid.  Also, the projected changes in temperature and oxygen concentrations were calculated by subtracting the 30 year average of historical results from 1975 to 2005 from the 30 year average of the future projections from 2070 to 2100.  

The CMIP5 files that serve as the starting point for this analysis can be downloaded here:   
[https://doi.org/10.5281/zenodo.807748](https://doi.org/10.5281/zenodo.807748)

The original files are from:
[https://esgf-node.llnl.gov/search/cmip5/](https://esgf-node.llnl.gov/search/cmip5/)


#### IUCN data

Request spatial data for tuna range areas from IUCN Red List of Threatened Species:  
[http://www.iucnredlist.org/](http://www.iucnredlist.org/)   
<br>
Tuna species: skipjack tuna (*Katsuwonus pelamis*), yellowfin tuna (*Thunnus albacares*), southern bluefin tuna (*Thunnus maccoyii*), bigeye tuna (*Thunnus obesus*), Pacific bluefin tuna (*Thunnus orientalis*), Atlantic bluefin tuna (*Thunnus thynnus*), albacore tuna (*Thunnus alalunga*), blackfin tuna (*Thunnus atlanticus*), and longtail tuna (*Thunnus tonggol*).  
<br>
If granted access, download the data and put the folders, `species_#####`, with the data in the `data/IUCN` folder.  


-------------------------------
#### Running the analysis code
-------------------------------
All of the following commands assume that the current directory is the CMIP5_p50_tuna folder. The analysis is run in NOAA Ferret using shell scripts in the sh folder and .jnl files in the ferret folder.  WOA data is World Ocean Atlas 2009 data.  Projections refer to results from the Coupled Model Intercomparison Project Phase 5 (CMIP5) models.  

<br>

The first step in the analysis is to calculate the projected changes in temperature and oxygen over the next century.  Also, oxygen concentrations are converted to oxygen pressure.  

Generate projections for the end of the century by adding the modeled changes in ocean temperature and oxygen to WOA data.  Results from 6 models are saved in the `data/CMIP5/projections` folder.

    ferret < ferret/Projections_modeldiff_WOA_rcp8.5.jnl

Convert dissolved oxygen concentrations to oxygen pressure (pO<sub>2</sub>). Results from 6 models are saved in the `data/CMIP5/projections` folder.  WOA results are saved in the `data/WOA` folder.

    ferret < ferret/Projections_convert_pO2.jnl  
    ferret < ferret/WOA_convert_pO2.jnl

Calculate annual average pO<sub>2</sub> from WOA files with monthly data.     

    ferret < ferret/Calculate_PO2_monthly_average.jnl

<br>

The second step in the analysis is to calculate P<sub>50</sub> depth for tuna species.  The P<sub>50</sub> and &Delta;H values for the tuna species are in the `sh/Species_global4.csv` file.

Calculate p50 and p50 depth for the models and data.

    sh sh/Models_p50/p50depth_rcp8.5.sh < sh/Species_global4.csv
    sh sh/WOA_p50/WOA_p50depth.sh < sh/Species_global4.csv

Calculate the change in P<sub>50</sub> depth and then find the mean of the projections from all 6 models.

    sh sh/Models_p50/deltap50depth_rcp8.5.sh < sh/Species_global4.csv
    sh sh/Mean_AllModels/ModelMean_deltap50depth.sh < sh/Species_global4.csv

Convert IUCN Shape Files to NetCDF grid so that masks can be used to extract the P<sub>50</sub> depth just for the habitat area.

    sh sh/IUCN/IUCN_shptonc.sh
    sh sh/IUCN/ConvertTo5deg.sh < sh/Species_global4.csv
    sh sh/IUCN/NetCDF_To_ascii.sh < sh/Species_global4.csv

Use IUCN mask to extract P<sub>50</sub> depth for the habitat range of each tuna species from the models and WOA data.

    sh sh/IUCN_P50Depth/IUCN_modelmean_P50Depth.sh < sh/Species_global4.csv
    sh sh/IUCN_P50Depth/IUCN_modelmean_deltaP50Depth.sh < sh/Species_global4.csv
    sh sh/IUCN_P50Depth/IUCN_WOA_P50Depth.sh < sh/Species_global4.csv

Calculate projected changes in vertical separation for tuna.  First step is to calculate the number of tuna species with P<sub>50</sub> depth measurements globally.  

    ferret < ferret/IUCN_GeoNumSpecies_P50depthanalysis.jnl
    ferret < ferret/Calculate_P50Depth_CommonArea_deltaseparation.jnl

<br>

Calculate geospatial distribution of the number of tuna species as supporting information for the paper.

    mkdir results/IUCN
    ferret < ferret/IUCN_GeoNumSpecies.jnl


-----------------------------
#### Verifying the results
-----------------------------
Compare final results generated using the commands above to a set of test files to make sure the results are the same. The commands assume that the current directory is the `CMIP5_p50_tuna` folder.

Command to run comparison tests:

    Rscript RCode/RunTest.R

-----------------------------
#### Graphing the results
-----------------------------
Plots are produced and saved in the `graphs/` folder.  The commands assume that the current directory is the `CMIP5_p50_tuna` folder.

Figure 1:

    python pyCode/IUCN_numberspecies.py

Figure 2: (Ignore WARNING)

    python pyCode/IUCN_combined_woa_rcp8.5_plot.py

Figure 3:

    Rscript RCode/IUCN_allmodels_deltaP50depth.R

Figure 4:

    python pyCode/IUCN_southernbluefin_spawning.py

Figure 5:

    python pyCode/IUCN_deltaseparation.py

Figure S1:

    Rscript RCode/IUCN_Transect_p50.R

Figure S2: (Ignore WARNING)

    python pyCode/IUCN_woa_p50depthav_map.py

Figure S3: (Ignore WARNING)

    python pyCode/IUCN_rcp8.5_p50depthav_map.py

-----------------------------
#### Acknowledgements
-----------------------------
We thank Hartmut Frenzel for regridding the CMIP5 results. K.A.S. was supported by the Washington Research Foundation Fund for Innovation in Data-Intensive Discovery and the Moore/Sloan Data Science Environments Project at the University of Washington.  
