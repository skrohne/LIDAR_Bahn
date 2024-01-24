library(lidR)

buffered_las

# Set the desired resolution (adjust as needed)
resolution <- 1  # Example resolution in meters

# Create a Digital Terrain Model (DTM) without ground points  version 1
#dtm <- grid_terrain(buffered_las, algorithm = tin(), res = resolution)
#plot DTM model
#plot_dtm3d(dtm, col = "gray", size = 0.2)

# Create DTM Version 2
dtm1 = rasterize_terrain(buffered_las, resolution, knnidw())
plot(dtm1, col = gray(1:50/50))

#DTM Surface normalization
#sutract dtm from las
nlas <- buffered_las - dtm1
plot(nlas, size = 4, bg = "white")
#calculate treetops
ttops_norm <- locate_trees(nlas, lmf(ws = 10,hmin=5, shape="circular"))
x <- plot(nlas,size = 3)
add_treetops3d(x, ttops_norm)
