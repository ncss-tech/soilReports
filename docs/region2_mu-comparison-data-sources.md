

# Overview

Several of the Region 2 reports make use of a standardized set of raster data sources.



# Climate Data

These maps are derived from the daily, 800m resolution, PRISM data spanning 1981--2010.


## Basic Summaries

  * **final_MAAT_800m.tif** Mean annual air temperature (deg C).

  * **final_MAP_mm_800m.tif** Mean accumulated annual precipitation (mm).

  * **final_monthly_ppt_800m.tif** Mean accumulated monthly precipitation (mm).
  
  * **final_monthly_tavg_800m.tif** Mean monthly temperature (deg C).



## Frost-Free Period

### Frost-Free Days

   * **ffd_50_pct_800m.tif** Frost-free days, 50th percentile.

   * **ffd_80_pct_800m.tif** Frost-free days, 80th percentile.

   * **ffd_90_pct_800m.tif** Frost-free days, 90th percentile.


### Day of Last Spring / First Fall Frost
    
   * **last_spring_frost_50_pct_800m.tif** Julian day of last spring frost, 50th percentile.
   
   * **first_fall_frost_50_pct_800m.tif** Julian day of first fall frost, 50th percentile.

   * **last_spring_frost_80_pct_800m.tif** Julian day of last spring frost, 80th percentile.
   
   * **first_fall_frost_80_pct_800m.tif** Julian day of first fall frost, 80th percentile.
   
   * **last_spring_frost_90_pct_800m.tif** Julian day of last spring frost, 90th percentile.

   * **first_fall_frost_90_pct_800m.tif** Julian day of first fall frost, 90th percentile.



## Design Freeze Index

   * **q90_freeze_index_800m.tif**
   
   * **q90_freeze_index_F_800m.tif**



## Growing Degree Days (C)

   * **gdd_mean_800m.tif**



## Calculations

   * **effective_precipitation_800m.tif**

   * **rain_fraction_mean_800m.tif**



# Terrain


## 10 meter Resolution

   * **SSR2_DEM10m_AEA.tif** Integer representation of elevation (m).
   
   * **SSR2_Aspect10m_AEA.tif** Integer representation of aspect angle (degrees clock-wise from North).
   
   * **SSR2_Slope10m_AEA.tif** Integer representation of slope gradient (percent).


### Surface Shape and Landform

   * **curvature_classes_10_class_region2.tif** Surface curvature classes, coded.
   
   * **forms10_region2.tif** Landform elements as estimated by the geomorphons algorithm.


## 30 meter Resolution

   * **DEM_30m_SSR2.tif** Integer representation of elevation (m).

   * **Aspect_30m_SSR2.tif** Integer representation of aspect angle (degrees clock-wise from North).
   
   * **Slope_30m_SSR2.tif** Integer representation of slope gradient (percent).
   

### Surface Shape and Landform

   * **curvature_classes_30_class_region2.tif** Surface curvature classes, coded.
   
   * **forms30_region2.tif** Landform elements as estimated by the geomorphons algorithm.


### Terrain Indices

   * **beam_rad_sum_mj30_int_region2.tif** Modeled annual beam radiance
   
   * **saga_twi_30_int_region2.tif**
   
   * **tci_30_int_region2.tif**



# Land Cover

## NLCD

   * **nlcd_2011_cropped.tif**
   
   * **nlcd_impervious_2011_cropped.tif**


## NASS


# FEMA













