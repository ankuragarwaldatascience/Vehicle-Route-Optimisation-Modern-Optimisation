getData <- function(){
  library(readxl)
  library(ggrepel)
  library(tidyverse)
  route <- read_excel("/Users/deepdata/Desktop/greece.xlsx") #/Users/deepdata/Desktop/greece.xlsx /Users/deepdata/Documents/tspfile.xlsx
  route_distance <<- dist(route[ ,2:3], upper=T, diag=T) %>% as.matrix()
  D <- as.matrix(route_distance)
  return(D)
}


tourLength <- function(tour, distMatrix) {
     tour <- c(tour, tour[1])             #e.g. convert A,B,C to A,B,C,A. Thus the tour finishes where it started.
     route <- embed(tour, 2)[,2:1]        #converts the tour into a matrix of trips. i.e. 
                                          # 
     tourlength <- sum(distMatrix[route]) #tour length must be minimised
     return(tourlength)                   #however, GA package only maximises. So 1/tourlength can be maximised. 
}

tspFitness <- function(tour, ...){       #... allows passing some unspecified arguments to the function, which can be passed on further. 
     return (1/tourLength(tour, ...))    #Since the tour length must be minimsed, 1/tourlength can be maximised. 
                                         #We convert it into a maximisation problem because the GA package can only maximise. 
}

plotTSPSolution<-function(solution){
  data("eurodist", package = "datasets")
  mds <- cmdscale(eurodist)
  x <- mds[, 1]
  y <- -mds[, 2]
  plot(x, y, type = "n", asp = 1, xlab = "", ylab = "")
  abline(h = pretty(range(x), 10), v = pretty(range(y), 10),
            col = "light gray")
  tour <- solution[1, ]
  tour <- c(tour, tour[1])
  n <- length(tour)
  arrows(x[tour[-n]], y[tour[-n]], x[tour[-1]], y[tour[-1]],
            length = 0.15, angle = 25, col = "steelblue", lwd = 2)
  text(x, y, labels(eurodist), cex=0.8)
}

