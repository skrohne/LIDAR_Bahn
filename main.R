library(lidR)
library(mapview)
library(future)
library(dplyr)
library(sp)
library(st)
library(sf) 
library(leaflet)

#read las files and merge
las_file_0_0 <- readLAS("LASfiles/hiltrup_407_5749_nw.laz",filter = "-drop_classification 18")
las_file_0_1 <- readLAS("LASfiles/hiltrup_407_5750_nw.laz",filter = "-drop_classification 18")
merged_las<-rbind(las_file_0_0,las_file_0_1)
#read shapefiles and merge
#buf_las_20 <- st_read ("Shapefiles/buffered_hiltrup_20.shp")
buf_las_40 <- st_read ("Shapefiles/buf_hiltrup_40.shp")
shp_hiltrup <- st_read("Shapefiles/shape_hiltrup.shp")
dif_hil_40 <- st_read("Shapefiles/dif_hiltrup_40.shp")
#dif_las <- clip_roi (merged_las, dif_hil_40)
#clipped_las <- clip_roi(merged_las, shp_hiltrup)
buffered_las <- clip_roi(merged_las, buf_las_40)
#small_buf_las <- clip_roi(merged_las, buf_las_20)
shapefile_strecke <- st_read("Shapefiles/ERTS_shp_strecke.shp")

#create DTM from Las
dtm <- rasterize_terrain(buffered_las, res = 2, algorithm = tin())
plot_dtm3d(dtm, bg = "white") 

#DTM Surface normalization
#sutract dtm from las
las_norm <- buffered_las - dtm
plot(las_norm, size = 4, bg = "white")

#filter out rails
las_norm_dif <- clip_roi (las_norm, dif_hil_40)
#calculate treetops
ttops_norm <- locate_trees(las_norm_dif, lmf(ws = 10,hmin=5, shape="circular"))
x <- plot(las_norm,size = 3)
add_treetops3d(x, ttops_norm)

#add parameter min distances
min_distances <- numeric(length(ttops_norm$treeID))
#calculating each distance to the rails
for (i in seq_along(ttops_norm$treeID)) {
  specific_treetop <- ttops_norm[ttops_norm$treeID == ttops_norm$treeID[i], ]
  distance_to_line <- st_distance(specific_treetop, shapefile_strecke)
  min_distance <- min(distance_to_line)
  min_distances[i] <- min_distance
}
#adding in the values to ttops
ttops_norm$min_distance_to_line <- min_distances

#calculate difference in height to distance to rails
for (i in seq_along(ttops_norm$treeID)) {
  ttops_norm$height_distance_diff[i]<-((ttops_norm$Z[i])/ttops_norm$min_distance_to_line[i])
}
