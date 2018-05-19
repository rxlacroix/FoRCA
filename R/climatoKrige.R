#'@title climatoKrige
#'@description Krigeage selon un parametre climato, une bounding box, une taille de cellule et une periode
#'@param d une variable climatique (character) à choisir parmi celles proposées : "NORTAV","NORTNAV","NORTXAV","NORTRAV","NORTXQ90","NORTXQ10","NORTNQ10","NORTNQ90","NORTXND","NORTNND","NORTNHT","NORTXHWD","NORTNCWD","NORTNFD","NORTXFD","NORSD","NORTR","NORHDD","NORCDD"
#'@param xmin ... copier coller la bounding box créée depuis http://bboxfinder.com (choisir les coordonnées EPSG:2154)
#'@param taille  taille du côté d'une cellule de la grille (en metres)
#'@param periode un nombre entre 1 et 12 pour choisir un mois précis
#'@export
#'@examples climatoKrige("NORTAV", 805532.9843,6292039.0981,876022.3895,6353126.3605,200,7)

climatoKrige <- function(d,xmin,ymin,xmax,ymax,taille, periode){

  #VALIDATION INPUTS

  cndata <- colnames(data_climat)

  if (paste0(d,"_",1) %in% cndata)
  {
    dataset <- data_climat
    print("Dataset : data_climat")
  } else {
    stop("Mauvais paramètre climatologique")
  }

  cat("Paramètre : ", d, "\n")

  if(xmin < 90000){
    stop("xmin trop à l'ouest, vous pouvez vous aider de http://bboxfinder.com et choisir EPSG:2154 pour calibrer vos points")
  } else if(xmax > 1278778) {
    stop("xmax trop à l'est, vous pouvez vous aider de http://bboxfinder.com et choisir EPSG:2154 pour calibrer vos points")
  } else if(ymin <6040000){
    stop("ymin trop au sud, vous pouvez vous aider de http://bboxfinder.com et choisir EPSG:2154 pour calibrer vos points")
  } else if (ymax > 7150000){
    stop("ymax trop au nord, vous pouvez vous aider de http://bboxfinder.com et choisir EPSG:2154 pour calibrer vos points")
  } else {
    # print("Grille tous les "+taille+"m : xmin = "+xmin+ "  xmax = " + xmax + "  ymin = "+ymin+ "  ymax = " + ymax)
  }

  if (is.numeric(periode)){

    data <-
      dataset %>%
      dplyr::select(Point, Latitude, Longitude,paste0(d,"_",periode))

    print(head(data))
  } else if (is.vector(periode)){

  } else if (periode == "annee"){

  } else {
    stop("Mauvais paramètre de période")
  }

  #GRRRRID
  grid <- expand.grid(x=seq(from=xmin, to=xmax, by=taille), y=seq(from=ymin, to=ymax, by=taille))
  coordinates(grid) <- ~ x+y
  proj4string(grid) <- sp::CRS("+init=epsg:2154")
  gridded(grid) <- TRUE
  cat("Grille créée tous les", taille,"m\n")

  # GEODATA
  myTheme <- rasterTheme(region = viridis(n = 10)); myTheme$axis.list$col <- 'transparent'

  data <- subset(data, data$Longitude < 1.1*xmax & data$Longitude > 0.9*xmin & data$Latitude < 1.1*ymax & data$Latitude > 0.9*ymin)
  coordinates(data) <- ~Longitude+Latitude
  proj4string(data) <- CRS("+init=epsg:2154")
  variogram <- autofitVariogram(data@data[,paste0(d,"_",periode)]~1,data, model = c("Sph", "Exp", "Gau", "Bes", "Ste"), fix.values = c(NA,20000,NA))
  plot(variogram)
  k_i <- krige(data@data[,paste0(d,"_",periode)]~1, data, grid, model=variogram$var_model, nmax = 20, maxdist = 20000)
  k_i <- as.data.frame(k_i)
  k_i <- k_i[,-c(4)]
  r_k_i <- rasterFromXYZ(k_i)
  plot <- levelplot(r_k_i, par.settings= myTheme, main = paste0(d,"_",periode))
  print(plot)
  }
