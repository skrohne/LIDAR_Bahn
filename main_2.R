library(lidR)
library(sp)
library(st)
library(sf) 

las_south = readLAS("LASfiles/msnord_406_5761.laz",filter = "-drop_classification 18")
las_north = readLAS("LASfiles/msnord_406_5762.laz",filter = "-drop_classification 18")
merged_las_2 = rbind(las_south,las_north)

#read Shapefiles
shp_msnord = st_read("Shapefiles/shape_msnord.shp")
shp_buf40 = st_read ("Shapefiles/buf_msnord_40.shp")
dif_40 = st_read("Shapefiles/dif_msnord_40.shp")
railline = st_read("Shapefiles/line_msnord.shp")

#combine shapefiles/lidar
clip_las_2 = clip_roi(merged_las_2, shp_msnord)
las_2_dif = clip_roi(merged_las_2,dif_40)
las_2_buf =clip_roi (merged_las_2,shp_buf40)

#create dtm from buflas
dtm_2 <- rasterize_terrain(las_2_buf, res = 2, algorithm = tin())
plot_dtm3d(dtm_2, bg = "white") 

#DTM Surface normalization
#sutract dtm from las
las_norm_2 <- las_2_buf - dtm_2
plot(las_norm_2, size = 4, bg = "white")

#filter out rails
las_norm_dif_2 <- clip_roi (las_norm_2, dif_40)

#calculate treetops
ttops_norm_2 <- locate_trees(las_norm_dif_2, lmf(ws = 10,hmin=5, shape="circular"))
x <- plot(las_norm_2,size = 3)
add_treetops3d(x, ttops_norm_2)

#add parameter min distances
min_distances_2 <- numeric(length(ttops_norm_2$treeID))

#calculating each distance to the rails
for (i in seq_along(ttops_norm_2$treeID)) {
  specific_treetop_2 <- ttops_norm_2[ttops_norm_2$treeID == ttops_norm_2$treeID[i], ]
  min_distance_2 <- st_distance(specific_treetop_2, railline)
  min_distances_2[i] <- min_distance_2
}

#adding in the values to ttops
ttops_norm_2$min_distance_to_line_2 <- min_distances_2

#calculate difference in height to distance to rails
for (i in seq_along(ttops_norm_2$treeID)) {
  ttops_norm_2$height_distance_diff_2[i]<-((ttops_norm_2$Z[i])/ttops_norm_2$min_distance_to_line_2[i])
}

#remove z values from geometry
ttops_norm_2 <- st_zm(ttops_norm_2)

#Filter out all trees with an index below 0.7
filtered_ttops_2 <- ttops_norm_2[ttops_norm_2$height_distance_diff > 0.7, ]






