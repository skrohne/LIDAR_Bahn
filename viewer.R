library(mapview)

#Remove Z-Value
ttops_norm<-st_zm(ttops_norm)

# Define your custom color palette
custom_palette <- c("darkgreen", "yellow", "orange", "red","darkred")

# Create the map using mapview
mapview(ttops_norm, zcol = "height_distance_diff",
        map.types = c("CartoDB.Positron","Esri.WorldImagery"),
        at = seq(0, 3.5,0.5),
        legend = TRUE,
        col.regions = custom_palette, 
        alpha = 0,) #change Style
