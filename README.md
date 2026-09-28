
# TerraDT Aerosol DTC performance and optimizations

This repository holds the performance analysis and optimization cycles for the TerraDT Aerosol DTC, which is based on the HAM-Lite aerosol module. 
The aim of TerraDT is to couple the aerosol DTC to the DestinE IFS coupled model configurations, but is originally developed with the ICON framework and will be therefore available for 
both ICON and IFS configurations. 

The HAM-Lite source code is found [here](https://github.com/HOR-INFRAEU-TerraDT/hamlite_box).

HAM-Lite is a reduced-complexity version of the HAM-M7 aerosol module. The full HAM-M7 maybe used for reference in some of the analysis and optimization cycles and is found 
[here](https://github.com/HOR-INFRAEU-TerraDT/hambox).

Basic description for HAM-Lite is found [here](https://gmd.copernicus.org/articles/18/3877/2025/).

Analysis/optimization cycles found under [cycles/](cycles/):

| Cycle | Subject | Platform | Headline |
| ----- | ------- | -------- | -------- |
| [prof-baseline-001](cycles/prof-baseline-001) | First HAM-Lite performance profiling | LUMI | Main finding: inefficient memory access patterns |
| [optimization-001](cycles/optimization-001)   | First optimizations based on the baseline profiling results | LUMI | Porting to LUMI Cray environment; Speedup by more than 70 % achieved by fixing the inefficient memory access and other smaller optimizations |
