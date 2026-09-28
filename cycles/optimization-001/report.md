# HAM-Lite optimization results


## Executive summary 

The HAM-Lite aerosol model was optimized and ported to cray compiler. The optimizations were targeted at the 3D model setup using gfortran and cray compilers. The bulk of the optimization work was conducted on the radiation calculation components. They consumed 71-85\% of the total runtime of the model during the initial assessment. 

Optimization results can be seen in the figure below. Compared to a gfortran baseline, the execution time of the radiation calculation, relative to the gfortran baseline, was reduced by 83.6% with gfortran and 87.0% with cray compiler. This along with small improvement in the cloud microphysics module led to 62.7% improvement on the total runtime with gfortran and 73.4% improvement with cray compiler. These results were achieved with output staying bit-identical. The results were computed on 64x64 and 137 vertical levels and 100 time steps. Smaller 16x16 grid with 137 vertical levels showed similar speedup.

![Optimization results](/figures/base+opt_timing_barplot.png)

## 1. Introduction

The HAM-Lite box model is available in a private github repository https://github.com/HOR-INFRAEU-TerraDT/hamlite_box. The optimizations are merged to the main branch. 

* The initial state of the code before optimizations can be seen here: https://github.com/HOR-INFRAEU-TerraDT/hamlite_box/tree/165d97bc6decb2379595f36b45abfa5426922638

* The optimized code is here: https://github.com/HOR-INFRAEU-TerraDT/hamlite_box/tree/6b9d7e22c79bd05c45d96670f27e70d6e3dad182

## 2. Environment

The runs and analysis were performed on LUMI, using the `LUMI/25.03` software stack. The code was built twice, with GNU Fortran 14.3.0 (`PrgEnv-gnu`) and Cray `cce/19.0.0` Fortran compilers. The exact environments are given by the scripts `scripts/lumi_gftn_env.sh` and `scripts/lumi_cray_env.sh`.

The jobs were run with these parameters: 

```bash
salloc -A project_<our_project> -p debug -N 1 -n 1 -c 1 --mem=50G -t 00:30:00
```


## 3. Methodology

Execution time by function was measured by a simple timer utility function. More in depth analysis was conducted using CrayPat performance analysis tools. The tools were used to find bottlenecks in the code. These included unnecessary read/write operations, cache misses and call-tree breakdown of the heaviest parts of the code.  

## 4. Implemented optimizations

Most of the optimizations were performed in the radiation submodule `mo_ham_lite_rad.f90`.

### 4.1 Removing unnecessary intermediate arrays and array operations

> Radiation calculation speedup with Cray 50% and with gfortran 15%

* Changes performed in `mo_ham_lite_rad.f90:ham_lite_rad`, the main radiation subroutine
  * Removed unnecessary zeroing of arrays at the beginning of the subroutine
  * Eliminated recurring allocation and deallocation of arrays on each timestep
  * Fused multiple costly computational loops together

### 4.2 a) Removing unused communication arrays

> Radiation calculation speedup with Cray 66% and gfortran 78% over the previous optimization

* Changes performed in `mo_ham_lite_rad.f90:ham_lite_rad`, the main radiation subroutine
  * Removed 5 unused communication arrays (sigma, omega, asym, ni and nr)
    * Were used in ICON implementation for global communication
    * Were deemed unnecessary for this project
  * Major reduction in reading/writing in hot loops

### 4.2 b) Minor arithmetic optimizations for cloud microphysics

> Cloud microphysics speedup by 20% with gfortran, cray improvement negligible

* Changes performed in `o_ham_lite_act.f90:mo_ham_lite_nact`, the main cloud microphysics subroutine
  * Replacing real-valued exponents with squere roots when possible

### 4.3 Loop reordering and masking

> Radiation calculation speedup with Cray 25% and gfortran 15% over the previous optimization

* Changes performed in `mo_ham_lite_rad.f90:ham_lite_rad`, the main radiation subroutine
  * Moved the aerosol class index as the innermost variable in the loop and array indexing
    * 30% less computations in the hot loop. 
    * Reduced cache misses
    * Required a masking approach in the innermost loop



## 5. Results

> Achieved a 73.4% improvement in the total runtime of the code with Cray compiler and 62.7% imporvement with gfortran

* Output stayed bit-identical between baseline and optimized model versions with the same compiler.
  * Small differences between code compiled with Cray and gfortran as expected. 

* Testing documented here was done with a 64x64 grid with 137 vertical levels and 100 time steps. Similar results were obtained with a smaller 16x16 grid and 137 vertical levels.

### 5.1 Timing output of each function at each optimization level

>The following tables show the mean time spent in each HAM-Lite component in seconds. The compute loop contains every other funcrtion except for the initializatin which is only run once. The opt x.x optimization levels correspond to the section numbers above. The optimization was only performed for radiation and cloud microphysics subroutines.

**Cray**

| Function               |   Baseline |    opt 4.1 |    opt 4.2 |    opt 4.3 |
|------------------------|-----------:|-----------:|-----------:|-----------:|
| **Compute loop**       | **1.1046** | **0.5375** | **0.3068** | **0.2642** |
| ↳ Radiation 1          |     0.1165 |     0.0428 |     0.0166 |     0.0114 |
| ↳ Cloud microphysics   |     0.0132 |     0.0145 |     0.0133 |     0.0132 |
| ↳ Update tracers       |     0.0056 |     0.0062 |     0.0056 |     0.0056 |
| ↳ Sedimentation        |     0.0009 |     0.0014 |     0.0010 |     0.0009 |
| ↳ Wet deposition       |     0.0009 |     0.0011 |     0.0008 |     0.0009 |
| ↳ Dry deposition       |     0.0008 |     0.0009 |     0.0007 |     0.0007 |
| ↳ Radiation 2          |     0.0000 |     0.0000 |     0.0000 |     0.0000 |
| *Outside compute loop* |            |            |            |            |
| Initialization         |     4.8159 |     5.3102 |     4.8403 |     5.1433 |

**gfortran**

| Function               |   Baseline |    opt 4.1 |    opt 4.2 |    opt 4.3 |
|------------------------|-----------:|-----------:|-----------:|-----------:|
| **Compute loop**       | **0.9943** | **0.8477** | **0.3966** | **0.3712** |
| ↳ Radiation 1          |     0.0874 |     0.0694 |     0.0168 |     0.0143 |
| ↳ Cloud microphysics   |     0.0180 |     0.0179 |     0.0149 |     0.0146 |
| ↳ Update tracers       |     0.0100 |     0.0095 |     0.0099 |     0.0096 |
| ↳ Sedimentation        |     0.0044 |     0.0044 |     0.0044 |     0.0045 |
| ↳ Wet deposition       |     0.0013 |     0.0013 |     0.0013 |     0.0013 |
| ↳ Dry deposition       |     0.0014 |     0.0014 |     0.0015 |     0.0014 |
| ↳ Radiation 2          |     0.0013 |     0.0013 |     0.0000 |     0.0000 |
| *Outside compute loop* |            |            |            |            |
| Initialization         |     7.7774 |     4.4900 |     8.8065 |     4.8644 |



