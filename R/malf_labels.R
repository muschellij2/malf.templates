#' @title Label Names for Labeled Images
#'
#' @description A \code{data.frame} containing the label indices and
#' their corresponding names for identification of structures.
#'
#' @format A list with 3 elements, which are:
#' \describe{
#' \item{index}{integer relating to the labeled image}
#' \item{name}{structure name of the brain}
#' \item{ignore}{indicator if the label was "ignored" as indicated by the
#' challenge coordinators.  These may not be always labeled by each reader.}
#' }
"malf_labels"
