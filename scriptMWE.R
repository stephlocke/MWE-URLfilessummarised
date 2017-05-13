# bootstrap package installation if not available
if(!require(data.table)) install.packages(data.table)
if(!require(urltools)) install.packages(urltools)
if(!require(stringr)) install.packages(stringr)

# load packages
library(data.table)
library(urltools)
library(stringr)

# find all csvs of interest
csvs<-list.files(pattern="sample*")

# read all csvs
allcsvs<-lapply(csvs,fread)

# combine csvs into one dataset
urls<-rbindlist(allcsvs)

# add some supplementary info
urls[,`:=`(
  rooturl=urltools::domain(URL),
  levelsno=stringr::str_count(urltools::path(URL),"/")+1
)]
urls[is.na(levelsno), levelsno:=0]

# make some summaries
byroot<-urls[,.(N=sum(Volume),
                AvgLevel=mean(levelsno)
                )
             ,rooturl]

# write summary to csv
fwrite(byroot, "summary.csv")


