### LIDAR_Bahn

#  Gefahrenanalyse von Baumbeständen entlang von Bahnschienen mit Hilfe von LIDAR
###  (Riskanalysis of tree populations along railroad tracks with the help of LIDAR data)

###  Description
In this project we tried to implement a workflow on how to analyse the risk of tree hazards along railroad tracks using LIDAR data in R. 
###  Workflow
1. Get lidar data and shapefiles of the railroad tracks for your Area of Interest
2. (to get a better result we filtered out points like masts and bridges along the track by creating a buffered shapefile)
3. load them into the script
4. run through the script
5. calculate the tree tops, create a dtm, substract the tree tops from the dtm, calculate height and distance to the railroad tracks, divide height by distance
6. display the result using a mapview interactive map

### Authors
@eerlenko @skrohne

### Contribute
If you would like to contribute to this repo, maybe you can find a better workflow to filter out falsley recognized tree tops along the tracks such as electricity masts and bridges
