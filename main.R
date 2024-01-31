library(lidR)
library(sp)
library(st)
library(sf) 

#read las files and merge
las_file_0_0 <- readLAS("LASfiles/hiltrup_407_5749_nw.laz",filter = "-drop_classification 18")
las_file_0_1 <- readLAS("LASfiles/hiltrup_407_5750_nw.laz",filter = "-drop_classification 18")
merged_las<-rbind(las_file_0_0,las_file_0_1)
#read shapefiles and merge
buf_las_40 <- st_read ("Shapefiles/buf_hiltrup_40.shp")
shp_hiltrup <- st_read("Shapefiles/shape_hiltrup_new.shp")
dif_hil_40 <- st_read("Shapefiles/dif_hiltrup_new.shp")
buffered_las <- clip_roi(merged_las, buf_las_40)
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
#remove z values from geometry
st_zm(ttops_norm)

# Set sizes for subsets
ttops_try <- ttops_norm
set_size <- 100
num_sets <- ceiling(nrow(ttops_norm) / set_size)

# Create a list to store subsets
subset_list <- vector("list", length = num_sets)

# Split the data into subsets
for (i in 1:num_sets) {
  start_index <- (i - 1) * set_size + 1
  end_index <- min(i * set_size, nrow(ttops_norm))
  subset_list[[i]] <- ttops_norm[start_index:end_index, ]
  
  # Calculate the average of height_distance_diff for each subset
  average_height_diff <- mean(subset_list[[i]]$height_distance_diff)
  
  # Add average and subset number to the subset
  subset_list[[i]]$average_height_diff <- average_height_diff
  subset_list[[i]]$subset_number <- i
}

# Combine the subsets back into a single data frame
ttops_try <- do.call(rbind, subset_list)

# Print or use the modified ttops_norm data frame as needed
print(ttops_try)