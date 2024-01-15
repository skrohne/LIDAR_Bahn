library(sf)

# Set the path to your input shapefile
input_shp_path <- "C:\\Users\\krohn\\OneDrive\\Dokumente\\Uni\\WS23\\LIDAR\\geo-strecke_2020\\Strecken\\Shapefiles"

# Set the path to the output folder
output_folder <- "C:\\Users\\krohn\\OneDrive\\Dokumente\\Uni\\WS23\\LIDAR\\gitR\\LIDAR_Bahn"

# Read the input shapefile
sf_data <- st_read(input_shp_path)

# Check the current CRS of the data
print(st_crs(sf_data))

# Set the target CRS (ETRS89 / UTM Zone 32N)
target_crs <- st_crs("+init=epsg:25832")

# Reproject the data to the target CRS
sf_data_reprojected <- st_transform(sf_data, target_crs)

# Print the CRS of the reprojected data
print(st_crs(sf_data_reprojected))

# Convert 3D Line String to 2D Line String
sf_data_2D <- st_zm(sf_data_reprojected)

# Set the path to the output shapefile
output_shp_path <- file.path(output_folder, "ETRS_shapefile.shp")

# Write the reprojected data to the output shapefile
st_write(sf_data_2D, output_shp_path)
