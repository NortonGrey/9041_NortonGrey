# 9041_NortonGrey
Metadata and code for submission to BEES9041 final report assessment. Created by Norton Grey 5493084.

Raw temperature and biological data too large to fit within GitHub repository, uploaded to OneDrive:
- Physical data: https://unsw-my.sharepoint.com/:f:/g/personal/z5493084_ad_unsw_edu_au/EsTy-D-ajgVJlzuOYMLiRIkBoMkyvhI-Z8tUenLdzRcjRw?e=2j2q00
- Biological data: https://unsw-my.sharepoint.com/personal/z5452002_ad_unsw_edu_au/_layouts/15/onedrive.aspx?e=5%3A3f49b5fd3982471f9b0b11295c1b1294&at=9&cid=9acd33ea%2D7e51%2D47e5%2D8445%2D92d6114c7723&id=%2Fpersonal%2Fz5452002%5Fad%5Funsw%5Fedu%5Fau%2FDocuments%2Fbiological%20data&FolderCTID=0x01200059EFD3CFA3229C45ACF353DC126B2879&view=0

'Data' folder contains Biogeochemical dataset from Maria Island National Reference Station (‘IMOS – combined geochemical parameters (reference stations)) which was used for the water chemistry component as outlined in the report methods.

'PhysicalComponent' folder contains RStudio QMD documents used for processing and analysis of SRS sea surface temperature data (IMOS - SRS - SST - L3S - Single Sensor - 1 day – night time – Australia). 
- 'HeatWaveAnalysis.qmd' is the working file for loading a suitable NetCDF dataset, extracting relevant variables, averaging into a point-timeseries, interpolating NAs, and analysing with HeatWaveR. Also included are various mathods to plot the data, as well as extract processed data as '.csv'.
- 'AnomaliesMap.qmd' is the working file for loading a suitable NetCDF dataset, extracting relevant variables, calculating averages for each grid cell at desired times, and plotting as an anomaly map
- 'MapGraphics.qmd' is the working file for creating site map of loactions studied during the report analysis.

'OldVersions' is outdated/redundant scripts used during early stages of exploratory analysis. These files were not used in the final report but are there as a reference.
- 'AODNThredds.qmd' is an early attempt at pulling data from the AODN Thredds server in order to avoid needing to request and download large datasets.
- 'SpatialAveraging.qmd' is the first attempt to get a working code that averages spatial dataset into a single point, to create a point-time series which could be analysed by 'HeatWaveR'
- 'TemporalAvgTest.qmd' is the first attempt to get a working code that averages temporal datasets into a single time, as as to create a map of averages, which could then later be used to create an anomaly map of the site.


'BiologicalComponent' folder contains the R scripts used to analyse SRS chlorophyll-a data (IMOS - SRS - MODIS - 01 day - Chlorophyll-a concentration (OC3 model)) as outlined in the report.
- 'Chla_analysis_new.qmd' is the working file for loading relevant NetCDF files, extracting variables, creating a spatially averaged point-timeseries (as done in 'HeatWaveAnalysis.qmd'), establishing a baseline, and plotting.

- 'OldVersions' contains 'Chla_code' which is the original attempt at chlorophyll-a analysis and was not used in the final report.


'WaterChemistryComp' file contains the code used to anlyse water chemistry data (IMOS – combined geochemical parameters (reference stations)).
- 'Chemical.qmd' is the working file to extract data and plot as timeseries
- 'RefinedPlots.qmd' is the working file to create more advanced plots of water chemistry parameters
