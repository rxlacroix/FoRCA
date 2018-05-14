#' Indices annuels de precipitations et nombre de jours de precipitations issus du modele Aladin-Climat
#'
#' Moyennes des differents indices annuels de precipitations et de nombre de jours de precipitations, sur les 8602 points terrestres de la France metropolitaine sur la periode de reference (1976-2005)
#' Moyennes calculees à partir de donnees corrigees du CNRM (Centre National de Recherches Meteorologiques).
#'
#' Parametres :
#'
#'     NORPAV : Precipitations journalieres moyennes (mm/jour)
#'
#'     NORPINT : Precipitation moyenne les jours pluvieux (mm/jour)
#'
#'     NORRR : Cumul de precipitation (mm)
#'
#'     NORPFL90 : Fraction des precipitations journalieres intenses (%)
#'
#'     NORRR1MM : Nombre de jours de pluie (jour)
#'
#'     NORPXCWD : Nombre maximum de jours pluvieux consecutifs (jour)
#'
#'     NORPN20MM : Nombre de jours de fortes precipitations (jour)
#'
#'     NORPXCDD : Periode de secheresse (jour)
#'
#' @docType data
#'
#'
#' @format An object of class \code{"data.frame"}
#'
#' @keywords datasets
#'
#' @source \href{https://www.data.gouv.fr/s/resources/indices-annuels-de-precipitations-et-nombre-de-jours-de-precipitations-issus-du-modele-aladin-pour-la-periode-de-reference/20150930-202008/Precip_REF_annuel.txt}{https://www.data.gouv.fr/s/resources/indices-annuels-de-precipitations-et-nombre-de-jours-de-precipitations-issus-du-modele-aladin-pour-la-periode-de-reference/20150930-202008/Precip_REF_annuel.txt}
#'
#' @examples
#' data(Precipitations)
#' @export
"Precipitations"
