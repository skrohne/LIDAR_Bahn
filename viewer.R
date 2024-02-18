library(mapview)

# Define your custom color palette
custom_palette <- c("darkgreen", "yellow", "orange", "red","darkred")

# Create the map using mapview
map <- mapview(ttops_norm, zcol = "height_distance_diff",
        map.types = c("CartoDB.Positron","Esri.WorldImagery"),
        at = seq(0, 3.5,0.5),
        legend = TRUE,
        layer.name = 'Height-Distance-Index',
        col.regions = custom_palette, 
        alpha = 0) #change Style
map

# Create the filterd map using mapview
filter_map <- mapview(filtered_ttops, zcol = "height_distance_diff",
               map.types = c("CartoDB.Positron","Esri.WorldImagery"),
               at = seq(0, 3.5,0.5),
               legend = TRUE,
               layer.name = 'Height-Distance-Index',
               col.regions = custom_palette, 
               alpha = 0) #change Style
filter_map