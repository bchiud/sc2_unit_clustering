#======================================================================
# Title: Starcraft 2 - Unit Clustering
# Author: Brady Chiu
# Date: May 8, 2016
#======================================================================
## @knitr notes

## @knitr setup
library(data.table, warn.conflicts=F)
library(dplyr, warn.conflicts=F)
library(ggplot2, warn.conflicts=F)
library(knitr, warn.conflicts=F)
library(lubridate, warn.conflicts=F)
library(tidyr, warn.conflicts=F)
library(xlsx, warn.conflicts=F)
sessionInfo()

work_dir<-"/Users/bradychiu/Dropbox (Uber Technologies)/R/sc2_unit_clustering"
data_dir<-"data/"
deliverables_dir<-"deliverables"
# setwd(work_dir)

## @knitr functions
get_data<-function(data_file_paths) {
  bind_rows(lapply(data_file_paths, fread, stringsAsFactors=F, na.strings="-")) %>%
    data.frame()
}

## @knitr parameters

## @knitr data_load

# http://wiki.teamliquid.net/starcraft2/Terran_Unit_Statistics
# file.remove(file.path(work_dir, data_dir, "terran_data.Rds"))
if(!file.exists(file.path(work_dir, data_dir, "terran_data.Rds"))){
  terran_files<-c("terran_data.csv")
  terran_data<-get_data(file.path(work_dir, data_dir, terran_files))
  saveRDS(terran_data, file.path(work_dir, data_dir, "terran_data.Rds"))
}else{
  terran_data<-readRDS(file.path(work_dir, data_dir, "terran_data.Rds"))
}

# http://wiki.teamliquid.net/starcraft2/Zerg_Unit_Statistics
# file.remove(file.path(work_dir, data_dir, "zerg_data.Rds"))
if(!file.exists(file.path(work_dir, data_dir, "zerg_data.Rds"))){
  zerg_files<-c("zerg_data.csv")
  zerg_data<-get_data(file.path(work_dir, data_dir, zerg_files))
  saveRDS(zerg_data, file.path(work_dir, data_dir, "zerg_data.Rds"))
}else{
  zerg_data<-readRDS(file.path(work_dir, data_dir, "zerg_data.Rds"))
}

# http://wiki.teamliquid.net/starcraft2/Protoss_Unit_Statistics
# file.remove(file.path(work_dir, data_dir, "protoss_data.Rds"))
if(!file.exists(file.path(work_dir, data_dir, "protoss_data.Rds"))){
  protoss_files<-c("protoss_data.csv")
  protoss_data<-get_data(file.path(work_dir, data_dir, protoss_files))
  saveRDS(protoss_data, file.path(work_dir, data_dir, "protoss_data.Rds"))
}else{
  protoss_data<-readRDS(file.path(work_dir, data_dir, "protoss_data.Rds"))
}