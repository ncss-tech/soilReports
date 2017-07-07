## Shiny Interactive Pedon Summary

### Basic setup
The report has a `config.R` file where the following are specified:
 - **cache_data**  -- toggle to auto-load SoilProfileCollection and linework from Rda file
 - **use_regex_ghz** -- toggle to regular expressions to apply generalized horizon labels (component layer ID); otherwise, assign them manually in NASIS;
 - **poly.dsn** -- polygon feature class data source name (path without trailing slash, may be an ESRI GDB)
 - **poly.layer** -- shapefile layer containing map unit delineations
 - **poly.bounds** -- shapefile layer denoting boundary of survey area / map units (currently not used)
 - **p.low.rv.high** --  quantiles to assign to "LO" "RV" and "HI"
 - **q.type** -- quantile type
 - **ml.profile.smoothing** -- smoothing parameter for density plots
 - **rasters** -- named list of rasters of environmental data; values will be extracted at point locations for pedons (NOT SAMPLED FROM MAPUNITS) and summarized in output

### Walkthrough
Here is shiny-pedon-summary v0.1 in action. In this example, the NASIS selected set contains all pedons and DMUs from CA630. First and foremost pedons are filtered by mapunit (MUSYM '6074'). Pedon overlap with mapunits is based on linework from the CA630 GDB. Generalized horizons were assigned manually during the process of populating the 607X MUs.

![shiny-pedon-summary-example](https://user-images.githubusercontent.com/20842828/27937272-ac620ed2-626a-11e7-9ae0-ada8c4d97710.PNG)

The above profile plot shows the pedons that are currently being aggregated together. Here, two taxa that are similar soils (Sierra and Auberry) are selected via a regex pattern and then are both subjected to the same horizonation scheme to come up with the component ranges. In this particular MU, the component was named Sierra. 

There are many other tabs on the main information pane, including:
- _spatial (mapview) overview_ - click on pedon locations to view site-level data from SPC.
- _slab-wise profile plot_ -  makes 1cm slabs of all pedons in the filtered set shown in GPP; plots the 25-75% quantiles in grey, the median in blue and the modal pedon value (user selected via drop down on left side) in red.
- _generalized GPP_ - shows grouped profile plot using generalized horizons as labels instead of field-described designations
- _generalized horizon probability_ - plots probability density functions as a function of depth for each generalized horizon. this is useful to look at to make sure there isn't anything super wacky with your generalization, but currently the "crossover" depths aren't used for anything since depth RVs come from modal not a "50% probability threshold"
- _geomorphology_ - tabular / proportional summary of 2D/3D/Geomorphon/Drainage Class/SurfaceShape for all pedon locations. based on either data entered in NASIS or extracted from rasters at pedon locations. shows proportional summary along side the selected modal pedon value.
- _aspect_ - plot of distribution of aspects at pedon locations 
- _ecology_ - tabular / proportional summary of ecological site assignment by pedon
- _horizon_ - shows matrix of field-described (columns) versus generalized (rows) horizons. 
- _modal_ - shows the pedon selected as modal in the drop down box. shows field-described versus generalized horizons. this is useful to see where multiple interpretively-similar horizons from the modal are collapsed into a single general horizon.
- _texture_ - tabular / proportional summary of textural classes from NASIS across generalized horizons 
- _color_ - graphical / proportional summary of soil colors from NASIS across generalized horizons. useful for refining soil series range in characteristics. 
- _morphology_ - clay, sand, pH, rock fragment fractions, albedo - the bread and butter of the component, quantiles for each variable:horizon combination (min, LO, RV, HI, max). Quantiles defined in `config.R`
- _surface fragments_ - LO-RV-HI by size fraction
- _diagnostics_ - diagnostic horizons from NASIS; number of each occurring in filtered set, LO-RV-HI for top depth, bottom depth and thickness
- _diagnostics plot_ - graphical summary of above, showing individual pedon IDs and clustering
- _mapunit summary_ - when pedons from multiple mapunits are combined in a filtered set, you will get one boxplot per variable per horizon per mapunit. for mapunits with a ton of data, this provides an excellent opportunity to test out the "components are special snowflakes" hypothesis

### Trying it out for yourself...
Aside from getting `config.R` set up in a way that works with your system, you will also need to prepare your NASIS selected set. Summaries and the static "report" output retrieved by pushing the button on the bottom left pane rely on **most** pedons having generalized horizon labels assigned in NASIS via the **Comp. Layer ID** field. Individual pedons or horizons are allowed to have blanks in this field if they are not intended to be included in the range of characteristics (RIC). The RIC for each component horizon (modal pedon horizon defines RVs) is determined by aggregating other similar horizons from the non-modal pedons. This aggregation is achieved by assigning them the same "label" in the Comp Layer ID.

For personal use, I have manually entered component layer IDs after selecting my modal pedon (and therefor my "modal horizon scheme"). This becomes increasingly less practical as the number of pedons involved in the analysis increases. 

An alternate way of doing the horizon aggregation if you can't stomach doing it in NASIS manually is to use the old generalized horizon script. Various vintages of this kick around in the 2-SON office but it is currently not publically available. These scripts use regular expressions (1 expression per generalized horizon; matches many horizon designations and aggregates to a single label) and taxonname (each taxon can have its own set of  generalized horizons). Then the script spits out a `horizonagg.txt` file that can be imported into NASIS component layer ID fields via a calculation. This script is long overdue for an overhaul and will be one of the near-future projects to bring in as a new soilReport.

### Future plans
Tying in with re-vamping the horizon generalization script, I would like to have a really slick way to interactively generate regex patterns/manually assign horizonation. This could likely be a separate shiny interface report (e.g. shiny-pedon-aggregation) or a "prequel" to running the pedon-summary stage (say, if generalized horizons don't already exist in the SPC or if the user asks to override NASIS). It also would be fun to drive the "horizon similarity" metrics off of the numerical data we have and try to programmatically assign GHZ that way. Though most components/series/etc. in our region are probably not well documented enough to actually rely on this, we probably do have a handful that would be really great demonstration datasets.

The shiny interface would show a plot and graphs of properties from the selected modal pedon in a side pane. The modal pedon defines the actual "label" and number of labels for a particular component's generalized horizons. In a larger pane would be the "unaggregated" pedons. The user would be able to rapidly visualize the original description, generalized description, numerical effects on ranges of including/excluding different horizons from a particular generalized horizon group, and so on.

##  TODOS
 - horizon tab : currently rownames (GENHZs) don't show up correctly in Shiny output due to issues with `kable`.
 - modal pedon : include modal pedon value alongside median where appropriate for texture, color, morphology, surface frags, diagnostics
 - "order level" or region-tailored general horizon patterns - allows for exploration without concern for taxon/correlation status using generic horizon aggregation that is based on higher order taxonomy and common horizon designations in those taxa
