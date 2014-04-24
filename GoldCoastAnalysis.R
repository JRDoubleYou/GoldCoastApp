#First need to load in the appropriate packages to handle spatial data in R

library(sp)  
library(rgdal)
library(ggmap)
library(RgoogleMaps)
library(data.table)



# set working directory
setwd("/Users/admin 1/Documents/DigitalGlobe/GoldCoast/")
# load files containing centroid and parcel boundaries in R



centroids<-readOGR("./Centroids/","ParcelData")


parcel<-readOGR("./Parcels/","Gold_Coast_City_#9541_2007")

# need both files in the same coordinate system
# the provided data of parcels is in geographic
# coordinates (lat,lon), while centroids are in
# universal transverse mercator (UTM, measured in meters)
# since we will use lon/lat with ChipAPI let's 
# reproject the centroid data so it is lat/lon

parcels.projection<-proj4string(parcel)
centroid.projection<-proj4string(centroids)
centroid.proj<-spTransform(centroids,CRS(parcels.projection))

# Since we may want to know later what the area of the parcels is
# in meters, we will also create a parcels dataset in UTM
# this takes a second as the set is large, and polygons are more
# complicated that points 

parcels.UTM <-spTransform(parcel,CRS(centroid.projection))
parcel.areas.UTM <-sapply(slot(parcels.UTM, "polygons"), slot, "area")
parcel.IDs <-sapply(slot(parcels.UTM, "polygons"), slot, "ID")

#calculate the top 10% threshold of areas
threshold<-quantile(parcel.areas.UTM,.90)
large.idx<-which(parcel.areas.UTM > threshold)

large.parcel.IDs<-parcel.IDs[large.idx] 
large.parcel.areas <- parcel.areas.UTM[large.idx]


#which of the large parcels have centroids
centroid.df = as.data.frame(centroid.proj)
large.centroids.idx = !is.na(match(centroid.df[,"ParcelId"],large.parcel.IDs))
large.centroids<-centroid.proj[large.centroids.idx,]

# create a data frame from spatial object
large.locations = as.data.frame(large.centroids)

# add the parcel areas 

final.id.idx<-match(large.locations$ParcelId,parcel.IDs)
large.locations$parcel.area = parcel.areas.UTM[final.id.idx]
names(large.locations)<-c("Building Area","Material","ParcelID","lon","lat","Parcel_Area")
locations = large.locations



# generate a subset shape file

parcel.subset = parcel[final.id.idx,]

save(locations,parcel.areas.UTM,parcel.subset,file="./data/locations.Rdata")



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~






