% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/climatoKrige.R
\name{climatoKrige}
\alias{climatoKrige}
\title{climatoKrige}
\usage{
climatoKrige(d, xmin, ymin, xmax, ymax, taille, periode)
}
\arguments{
\item{d}{une variable climatique (character) à choisir parmi celles proposées : "NORTAV","NORTNAV","NORTXAV","NORTRAV","NORTXQ90","NORTXQ10","NORTNQ10","NORTNQ90","NORTXND","NORTNND","NORTNHT","NORTXHWD","NORTNCWD","NORTNFD","NORTXFD","NORSD","NORTR","NORHDD","NORCDD"}

\item{xmin}{... copier coller la bounding box créée depuis http://bboxfinder.com (choisir les coordonnées EPSG:2154)}

\item{taille}{taille du côté d'une cellule de la grille (en metres)}

\item{periode}{un nombre entre 1 et 12 pour choisir un mois précis}
}
\description{
Krigeage selon un parametre climato, une bounding box, une taille de cellule et une periode
}
\examples{
climatoKrige("NORTAV", 806149.1821,6294916.9104,882619.2089,6382762.4764,150,7)
}
