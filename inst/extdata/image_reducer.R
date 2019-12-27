#
rm(list = ls())
library(neurobase)
library(extrantsr)
library(ANTsR)
library(fslr)

imgs = list.files(pattern = ".nii.gz")
df = data.frame(image = imgs,
                id = gsub("(\\d*).*", "\\1", imgs),
                stringsAsFactors = FALSE)
df$type = gsub(".*_(.*)[.]nii.gz", "\\1", df$image)
df$type[ !grepl("_", df$image)] = "original"
df = reshape(df, direction = "wide",
        timevar = "type", idvar = "id")
colnames(df) = gsub("image[.]", "", colnames(df))
rownames(df) = NULL
iimg = 1

for (iimg in seq(nrow(df))) {
# for (iimg in 1:20) {
  id_imgs = df[ iimg, ]
  id_imgs$id = NULL
  id_imgs = unlist(id_imgs)
  mask_fname = id_imgs["mask"]
  img_fname = id_imgs["original"]
  print(iimg)
  dims = lapply(id_imgs, dim_)
  res = sapply(dims,
               identical,
               x = dims[[1]])
  res = all(res)
  if (!res) {
    stop("dimensions are not equal!")
  }


  if (all(file.exists(id_imgs))) {

    template.file = mni_fname(mm = 1, brain = TRUE)
    template.mask = mni_fname(mm = 1, brain = TRUE, mask = TRUE)
    img = remove_neck(file = img_fname,
                         template.file = template.file,
                         template.mask = template.mask)
    omask = oMask(img)
    mask = readnii(mask_fname)

    drop_mask = omask | mask
    rm(list = c("mask", "omask")); gc(); gc();
    imgs = check_nifti(id_imgs)

    inds = getEmptyImageDimensions(img = drop_mask)

    imgs = lapply(imgs, applyEmptyImageDimensions, inds = inds)

    if (!same_dims(imgs)) {
      stop("Something has gone terribly wrong!")
    }
    mapply(writenii, nim = imgs, filename = id_imgs)
    rm(list = c("imgs", "img"));
    for (i in 1:10) gc();
  }
}
