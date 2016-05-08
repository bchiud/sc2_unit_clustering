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

characterizer<-function(df){
  data.frame(sapply(df, as.character))
}

## @knitr parameters

## @knitr data_load

# http://wiki.teamliquid.net/starcraft2/Terran_Unit_Statistics
# file.remove(file.path(work_dir, data_dir, "terran_data.Rds"))
if(!file.exists(file.path(work_dir, data_dir, "terran_data.Rds"))){
  terran_files<-c("terran_data.csv")
  terran_data<-get_data(file.path(work_dir, data_dir, terran_files)) %>%
    mutate(
      unit_name=gsub("\xca", " ", unit_name) #Ê
      ,race="terran"
      )
  saveRDS(terran_data, file.path(work_dir, data_dir, "terran_data.Rds"))
}else{
  terran_data<-readRDS(file.path(work_dir, data_dir, "terran_data.Rds"))
}

# http://wiki.teamliquid.net/starcraft2/Zerg_Unit_Statistics
# file.remove(file.path(work_dir, data_dir, "zerg_data.Rds"))
if(!file.exists(file.path(work_dir, data_dir, "zerg_data.Rds"))){
  zerg_files<-c("zerg_data.csv")
  zerg_data<-get_data(file.path(work_dir, data_dir, zerg_files)) %>%
    mutate(race="zerg") %>%
    dplyr::select(-creep_bonus)
  saveRDS(zerg_data, file.path(work_dir, data_dir, "zerg_data.Rds"))
}else{
  zerg_data<-readRDS(file.path(work_dir, data_dir, "zerg_data.Rds"))
}

# http://wiki.teamliquid.net/starcraft2/Protoss_Unit_Statistics
# file.remove(file.path(work_dir, data_dir, "protoss_data.Rds"))
if(!file.exists(file.path(work_dir, data_dir, "protoss_data.Rds"))){
  protoss_files<-c("protoss_data.csv")
  protoss_data<-get_data(file.path(work_dir, data_dir, protoss_files)) %>%
    mutate(
      race="protoss"
      ,health=as.character(as.integer(health)+as.integer(plasma_shield))
    ) %>%
    dplyr::select(-plasma_shield)
  saveRDS(protoss_data, file.path(work_dir, data_dir, "protoss_data.Rds"))
}else{
  protoss_data<-readRDS(file.path(work_dir, data_dir, "protoss_data.Rds"))
}

## @knitr data_column_check
list(
  data.frame(column_names=names(terran_data), terran=T)
  ,data.frame(column_names=names(zerg_data), zerg=T)
  ,data.frame(column_names=names(protoss_data), protoss=T)
) %>%
  Reduce(function(df1, df2) full_join(df1, df2, by="column_names"), .)

## @knitr data_cleanup - WIP
unit_data<-bind_rows(lapply(list(terran_data,zerg_data, protoss_data), characterizer)) %>%
  mutate(
    supply=as.integer(supply)
    ,minerals=as.integer(minerals)
    ,gas=as.integer(gas)
    ,build_time=as.interger(gsub("\\d{1,}/", "", unit_data$build_time))

    )
grepl("/", unit_data$build_time)


# write.csv(unit_data,file.path(data_dir,"unit_data.csv"),row.names=F)