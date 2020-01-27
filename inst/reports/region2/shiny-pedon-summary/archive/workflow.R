#re-vamped component report 

#projected workflow (not complete)
#      start with NASIS selected set containing all potential pedons (could be entire survey area) and DMU(s) to be populated
#      set MU suite (defines an extended spatial extent with similar geology/climate/geography etc. for borrowing pedons in order to develop ranges
#      set criteria for borrowing (set of simple options/rules, can be defined on a regional basis; defined in terms of sets of attributes and related rules)
#      set target MU (by MUSYM/DMUID) - this will be what the report is generated for
#      get the components being used in the DMU; needs at least a stub record with name for each component (no HZ data required)
#      auto-fill pedon sets for each component using taxon name (could also use other attributes such as depth/drainage) using data from within target MU
#        generate grouped profile plot, allow for user interaction to drop "outliers" and reassign groupings; outliers will be excluded from range calculations
#      generate an "extended set" of pedons using taxon name and indices of similarity from the MU suite extent
#        generate grouped profile plot, allow for user interaction to include similar pedons from MU suite; these will be included in range calculation
#      generate grouped profile plot, clearly showing selected data from within and outside MU
#        calculate provisional ranges and estimate "representativeness" of each pedon WITHIN THE MU extent
#        allow user to select representative pedons (at least one per component in DMU) - need not agree with numerical "representative" index.
#      show representative pedons for each component
#        interactive horizon aggregation (stepwise construction of a base regex pattern, applied to the rep pedon)
#        as pattern for aggregation changes, update a plot of just that component's selected data; highlight horizons that are currently not being aggregated
#        allow pattern to be edited explicitly; or "dumbly" by simply piping hz designations on following user selection
#      once a generalized horizon pattern has been developed allow the patterns to be saved (timestamped) to an output folder
#      generate horizonagg.txt for NASIS import
