library(lidR)
library(mapview)
library(future)
library(dplyr)
library(sp)
library(st)
library(sf) 
library(leaflet)


las_file_0_0 <- readLAS("LASfiles/hiltrup_407_5749_nw.laz",filter = "-drop_classification 18")
#plot(las_file_0_0$Intensity)
las_file_0_1 <- readLAS("LASfiles/hiltrup_407_5750_nw.laz",filter = "-drop_classification 18")
merged_las<-rbind(las_file_0_0,las_file_0_1)
buf_las_20 <- st_read ("Shapefiles/buffered_hiltrup_20.shp")
buf_las_40 <- st_read ("Shapefiles/buf_hiltrup_40.shp")
shp_hiltrup <- st_read("Shapefiles/shape_hiltrup.shp")
dif_hil_40 <- st_read("Shapefiles/dif_hiltrup_40.shp")
dif_las <- clip_roi (merged_las, dif_hil_40)
clipped_las <- clip_roi(merged_las, shp_hiltrup)
buffered_las <- clip_roi(merged_las, buf_las_40)
small_buf_las <- clip_roi(merged_las, buf_las_20)


#plot(buffered_las)
#plot(dif_las)
#plot(clipped_las)

# Funktion locate/lmf berechnet höchsten Punkt mithilfe des Umfeldes
#ws:Beobachtungsraum, (Durchmesser in m) 
ttops <- locate_trees(dif_las, lmf(ws = 10,hmin=65, shape="circular"))
x <- plot(buffered_las,size = 3)
add_treetops3d(x, ttops)



m <- leaflet() %>%
  addProviderTiles("Esri.WorldImagery")  %>%  # Add default OpenStreetMap map tiles
  addCircleMarkers(lng = 7.658, lat = 51.896, radius = 5, color = "darkgreen", popup = "Höhe: 9m, Abstand: 10m") %>%
  addCircleMarkers(lng = 7.658, lat = 51.898, radius = 5, color = "red",popup = "Höhe: 10m, Abstand: 5m") %>%
  addCircleMarkers(lng = 7.658, lat = 51.897, radius = 5, color = "red",popup = "Höhe: 10m, Abstand: 4m")
m  # Print the map



points_within_shape <- st_intersection(st_as_sf(ttops), buf_las_20)
plot(points_within_shape)

coordinates <- st_coordinates(ttops$geometry)

# Convert to a data frame
coordinates_df <- data.frame(X = coordinates[, 1], Y = coordinates[, 2], Z = coordinates[, 3])

X<-coordinates_df$X[1]
Y <- coordinates_df$Y[1]
Z <- coordinates_df$Z[1]

