library(mapview)


# Define your custom color palette
custom_palette <- c("darkgreen", "yellow", "orange", "red","darkred")

# Create the map using mapview
map2 <- mapview(ttops_norm_2, zcol = "height_distance_diff_2",
        map.types = c("CartoDB.Positron","Esri.WorldImagery"),
        at = seq(0, 3.5,0.5),
        legend = TRUE,
        layer.name = 'Height-Distance-Index',
        col.regions = custom_palette, 
        alpha = 0) #change Style
map2

# Create the filterd map using mapview
filter_map2 <- mapview(filtered_ttops_2, zcol = "height_distance_diff_2",
                      map.types = c("CartoDB.Positron","Esri.WorldImagery"),
                      at = seq(0, 3.5,0.5),
                      legend = TRUE,
                      layer.name = 'Height-Distance-Index',
                      col.regions = custom_palette, 
                      alpha = 0) #change Style
filter_map2