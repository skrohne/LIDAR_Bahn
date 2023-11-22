library(lidR)
library(mapview)

# Replace with the path to your LAS file
las_file_0_0 <- readLAS("hiltrup_407_5749_nw.laz", filter)
las_file_0_1 <- readLAS("hiltrup_407_5750_nw.laz")
merged_las<-rbind(las_file_0_0,las_file_0_1)

# Extract a transect
p1 <- c(407313, y = 5751642)
p2 <- c(408133, y = 5748986)

clipped_las <- clip_transect(merged_las , p1, p2, width = 60)
plot(clipped_las)




chm <- rasterize_canopy(clipped_las, res = 1, algorithm = p2r())
col <- height.colors(25)
plot(chm, col = col)

mapview(chm)



# Read the LAS data
#lidar_data <- readLAS(las_file, filter = "-keep_first")
#lidar_data <- readLAS(las_file_1)

# Crop the LiDAR data to the specified bounding box
cropped_lidar <- clip_circle(lidar_data, xcenter, ycenter, radius)

# Summary of the cropped LiDAR data
#summary(cropped_lidar)


#plot(cropped_lidar)