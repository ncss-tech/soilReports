# EDITSoilFeatures v0.2 (2022-06-21)
- Uses new `fetchNASIS("components", duplicates = TRUE)` to ensure one profile in collection per component per mukey (in case same mapunit is used on several legends) rather than one profile per component per dmuiid. These results can be further modified with `INCLUDE_ADDITIONAL` and `INCLUDE_NONREP` parameters to optionally duplicate components in additional mapunits and non-representative data mapunits.

# EDITSoilFeatures v0.1 (2022-06-09)
- An Rmarkdown report (_report.Rmd_) with statistical summaries of tabular data (Low, RV and High values) from NASIS components. Configured for individual runs via YAML header at top of file.
- A basic batching utility (_batch.Rmd_) for running many instances of the main report
