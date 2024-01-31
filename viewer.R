library(mapview)

#Remove Z-Value
ttops_norm<-st_zm(ttops_norm)

# Define your custom color palette
custom_palette <- c("darkgreen", "yellow", "orange", "red","darkred")

# Create the map using mapview
mapview(ttops_try, zcol = "height_distance_diff",
        map.types = c("CartoDB.Positron","Esri.WorldImagery"),
        at = seq(0, 3.5,0.5),
        legend = TRUE,
        layer.name = 'Height-Distance-Index',
        col.regions = custom_palette, 
        alpha = 0) #change Style

subset_map <- mapview(ttops_try, zcol = "average_height_diff",
                map.types = c("CartoDB.Positron","Esri.WorldImagery"),
                at = seq(0.3,0.6,0.1),
                legend = TRUE,
                layer.name = 'Average Index',
                col.regions = custom_palette, 
                alpha = 0) #change Style
subset_map