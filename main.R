library(lidR)
library(mapview)
library(future)

las_file_0_0 <- readLAS("hiltrup_407_5749_nw.laz")
las_file_0_1 <- readLAS("hiltrup_407_5750_nw.laz")


merged_las<-rbind(las_file_0_0,las_file_0_1)
summary(merged_las)

# Extract a transect
p1 <- c(407313, y = 5751642)
p2 <- c(408133, y = 5748986)
#las <- clip_transect(merged_las , p1, p2, width = 60)
#las <- clip_circle (merged_las, 407845,5749737, 50)
las <- clip_circle(merged_las, 407822, 5750033 ,120)



chm <- rasterize_canopy(las, res=0.5, pitfree(subcircle = 0.2))

# Non-ground points (trees and other objects)
las_trees <- filter_poi(Classification != 2)
plot(las_trees)

# Funktion locate berechnet höchsten Punkt mithilfe des Umfeldes
#ws:Beobachtungsraum, (Durchmesser in m)
ttops <- locate_trees(las, lmf(ws = 10, hmin=65))

plot(chm, col = height.colors(50))
plot(sf::st_geometry(ttops), add = TRUE, pch = 3, col="white")

x <- plot(las, bg = "white", size = 3)
add_treetops3d(x, ttops)

# Point-to-raster 2 resolutions
chm_p2r_05 <- rasterize_canopy(las, 0.5, p2r(subcircle = 0.2), pkg = "terra")
chm_p2r_1 <- rasterize_canopy(las, 1, p2r(subcircle = 0.2), pkg = "terra")

# Pitfree with and without subcircle tweak
chm_pitfree_05_1 <- rasterize_canopy(las, 0.5, pitfree(), pkg = "terra")
chm_pitfree_05_2 <- rasterize_canopy(las, 0.5, pitfree(subcircle = 0.2), pkg = "terra")

# Post-processing median filter
kernel <- matrix(1,3,3)
chm_p2r_05_smoothed <- terra::focal(chm_p2r_05, w = kernel, fun = median, na.rm = TRUE)
chm_p2r_1_smoothed <- terra::focal(chm_p2r_1, w = kernel, fun = median, na.rm = TRUE)

ttops_chm_p2r_05 <- locate_trees(chm_p2r_05, lmf(5))
ttops_chm_p2r_1 <- locate_trees(chm_p2r_1, lmf(5))
ttops_chm_pitfree_05_1 <- locate_trees(chm_pitfree_05_1, lmf(5))
ttops_chm_pitfree_05_2 <- locate_trees(chm_pitfree_05_2, lmf(5))
ttops_chm_p2r_05_smoothed <- locate_trees(chm_p2r_05_smoothed, lmf(5))
ttops_chm_p2r_1_smoothed <- locate_trees(chm_p2r_1_smoothed, lmf(5))

par(mfrow=c(3,2))
col <- height.colors(50)
plot(chm_p2r_05, main = "CHM P2R 0.5", col = col); plot(sf::st_geometry(ttops_chm_p2r_05), add = T, pch =3)
plot(chm_p2r_1, main = "CHM P2R 1", col = col); plot(sf::st_geometry(ttops_chm_p2r_1), add = T, pch = 3)
plot(chm_p2r_05_smoothed, main = "CHM P2R 0.5 smoothed", col = col); plot(sf::st_geometry(ttops_chm_p2r_05_smoothed), add = T, pch =3)
plot(chm_p2r_1_smoothed, main = "CHM P2R 1 smoothed", col = col); plot(sf::st_geometry(ttops_chm_p2r_1_smoothed), add = T, pch =3)
plot(chm_pitfree_05_1, main = "CHM PITFREE 1", col = col); plot(sf::st_geometry(ttops_chm_pitfree_05_1), add = T, pch =3)
plot(chm_pitfree_05_2, main = "CHM PITFREE 2", col = col); plot(sf::st_geometry(ttops_chm_pitfree_05_2), add = T, pch =3)

algo <- dalponte2016(chm_pitfree_05_2, ttops_chm_pitfree_05_2)
las <- segment_trees(las, algo) # segment point cloud
plot(las, bg = "white", size = 4, color = "treeID") # visualize trees


summary(las)
