
climatoKrige <- function(d,xmin,ymin,xmax,ymax,taille, periode){


  library(sp)

  #VALIDATION INPUTS


  if (d %in% c("NORPAV","NORPINT", "NORRR", "NORPFL90", "NORRR1MM","NORPXCWD", "NORPN20MM", "NORPXCDD"))
  {
    dataset <- Precipitations
    print("Dataset : Precipitations")
  } else if (d %in% c("NORTAV", "NORTNAV", "NORTXAV", "NORTRAV", "NORTXQ90", "NORTXQ10", "NORTNQ10", "NORTNQ90",
                      "NORTXND", "NORTNND", "NORTNHT", "NORTXHWD", "NORTNCWD", "NORTNFD", "NORTXFD", "NORTXFD",
                      "NORSD", "NORTR", "NORHDD", "NORCDD")){
    dataset <- Temperatures
    print("Dataset : Temperatures")

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
      dplyr::select(Point, Mois,d) %>%
      mutate(Mois = paste0("d_",Mois)) %>%
      spread(Mois, d) %>%
      mutate(TOT = rowSums(.[grep("d_", names(.))], na.rm = TRUE) ) %>%
      mutate(d_2 = d_2 * (31/28.25),
             d_4 = d_4 * (31/30),
             d_6 = d_6 * (31/30),
             d_9 = d_9 * (31/30),
             d_11 = d_11 * (31/30))
    data <- data[,c("Point", grep(paste0("_",periode), names(data), value=TRUE, useBytes = TRUE))]
    if(NCOL(data) >2) {
      data <- data[,1:2]
    }
    print(head(data))
  } else if (is.vector(periode)){

  } else if (periode == "annee"){

  } else {
    stop("Mauvais paramètre de période")
  }

  #GRRRRID
  grid <- expand.grid(x=seq(from=xmin, to=xmax, by=taille), y=seq(from=ymin, to=ymax, by=taille))
  coordinates(grid) <- ~ x+y
  proj4string(grid) <- CRS("+init=epsg:2154")
  gridded(grid) <- TRUE
  cat("Grille créée tous les", taille,"m\n")

  # GEODATA

  geodata <- Points.geo %>% merge(data, by = "Point")
  # conversion sf vers sp juste pour gstat
  geodata <- as(geodata, 'Spatial')
  geodata <- spTransform(geodata, crs(grid))
  geodata_compr <<-geodata

  kri <- autoKrige(geodata@data[,2] ~ 1,
            geodata,
            grid,
            model = c("Sph", "Exp", "Gau", "Ste"))
  print(kri)
}
