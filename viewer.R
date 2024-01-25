library(mapview)
library(leafem)

#Remove Z-Value
ttops_norm<-st_zm(ttops_norm)

# Define your custom color palette
custom_palette <- c("darkgreen", "lightgreen", "yellow", "orange", "red")

# Create the map using mapview
mapview(ttops_norm, zcol = "height_distance_diff", at = seq(0, 2.5, 0.5),
        legend = TRUE, col.regions = custom_palette, alpha = 0)
