#!/bin/sh
ml LUMI/25.03
ml partition/C
ml PrgEnv-gnu
ml cray-mpich/8.1.32
ml cray-libsci/25.03.0
ml cray-hdf5/1.12.2.11
ml cray-netcdf/4.9.0.11
ml buildtools/25.03
ml makedepf90/2.8.8  ## needs to be installed with EasyBuild
ml perftools-lite
