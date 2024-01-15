library(lidR)
library(mapview)
library(future)
library(dplyr)
library(sp)

las_file_0_0 <- readLAS("hiltrup_407_5749_nw.laz",filter = "-drop_classification 18")
las_file_0_1 <- readLAS("hiltrup_407_5750_nw.laz",filter = "-drop_classification 18")

merged_las<-rbind(las_file_0_0,las_file_0_1)
summary(merged_las)

# Extract a transect
p1 <- c(407313, y = 5751642)
p2 <- c(408133, y = 5748986)
#las <- clip_transect(merged_las , p1, p2, width = 60)
#las <- clip_circle (merged_las, 407845,5749737, 50)
las <- clip_circle(merged_las, 407822, 5750033 ,120)

# Non-ground points (trees and other objects)
las_trees <- filter_poi(Classification != 2)
plot(las_trees)


# Funktion locate berechnet höchsten Punkt mithilfe des Umfeldes
#ws:Beobachtungsraum, (Durchmesser in m) 
ttops <- locate_trees(las, lmf(ws = 10,hmin=65, shape="circular"))


x <- plot(las, bg = "white", size = 3)
add_treetops3d(x, ttops)


# run segment trees function on the LASfile using the li2012 algorithm
las <- segment_trees(las, li2012())
# select a random assortment of 200 colours (prep for plotting data)
col <- random.colors(200)
# plot the data using the 200 colour, assigning them to the tree IDs created by the segment_tress() function
plot(las, color = "treeID", colorPalette = col)


summary(las)
