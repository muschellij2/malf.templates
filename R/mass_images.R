#' @title Get Image Filenames for Skull Stripping
#'
#' @description Return a list of filenames for the images and
#' brain masks
#' @param n_templates Number of template filenames to return
#'
#' @return List of filenames for images and masks
#'
#' @export
mass_images = function(n_templates = 35){

  if (n_templates <= 0 || n_templates > 35) {
    stop("n_templates must be > 0 & <= 35")
  }
  L = malf_images()
  L = L[ c("images", "masks")]
  L = lapply(L, function(x) x[seq(n_templates)])
  return(L)
}

#' @rdname mass_images
#' @param ... arguments to pass \code{\link{mass_images}}
#' @export
mass_template_images = function(...) {
  L = mass_images(...)
  return(L$images)
}

#' @rdname mass_images
#' @export
mass_template_masks = function(...) {
  L = mass_images(...)
  return(L$masks)
}

