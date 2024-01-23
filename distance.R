library(st)
shapefile1 = st_read("ERTS_shp_strecke.shp")
summary(shapefile1)
plot(shapefile1)

# Assuming your sf object is named shapefile1
geometry_only <- shapefile1$geometry

# Create a new sf object with only the geometry column
geometry_sf <- st_sf(geometry = geometry_only)

summary(ttops)
# Assuming your sf object is named ttops
treeID_to_extract <- 1

# Extract the specific treetop based on treeID
specific_treetop <- ttops[ttops$treeID == treeID_to_extract, ]

# Print the extracted treetop
print(specific_treetop)

# Assuming specific_treetop and shapefile1 are your sf objects
distance_to_line <- st_distance(specific_treetop, geometry_sf)

# Print the distance
print(distance_to_line)

min_distance <- min(distance_to_line)

# Print the minimum distance
print(min_distance)

# Assuming ttops and shapefile1 are your sf objects
min_distances <- numeric(length(ttops$treeID))

for (i in seq_along(ttops$treeID)) {
  specific_treetop <- ttops[ttops$treeID == ttops$treeID[i], ]
  distance_to_line <- st_distance(specific_treetop, geometry_sf)
  min_distance <- min(distance_to_line)
  min_distances[i] <- min_distance
}

# Add the minimum distances to the ttops sf object
ttops$min_distance_to_line <- min_distances

# Print the updated ttops sf object
print(ttops)

# Assuming ttops and shapefile1 are your sf objects
plot(ttops["geometry"], main = "Treetops and Line 2D Plot", col = "blue", pch = 16)
plot(geometry_sf["geometry"], add = TRUE, col = "red")

# Assuming ttops and geometry_sf are your sf objects
plot(ttops["geometry"], main = "Treetops and Line 2D Plot", pch = 16,
     col = heat.colors(20)[cut(ttops$min_distance_to_line, breaks = 20)])
plot(geometry_sf["geometry"], add = TRUE, col = "red")
