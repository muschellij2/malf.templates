rm(list = ls())
library(neurobase)
library(extrantsr)
library(ANTsR)
library(fslr)

imgs = list.files(pattern = "\\d.nii.gz")
df = data.frame(image = imgs,
                label = gsub("[.]nii", "_glm.nii", imgs),
                stringsAsFactors = FALSE)
df$ss = gsub("[.]nii", "_SS.nii", df$image)
df$mask = gsub("[.]nii", "_mask.nii", df$image)
df$fast = gsub("[.]nii", "_tissues.nii", df$image)
iimg = 1


for (iimg in seq(nrow(df))) {

  print(iimg)
  img_fname = df$image[iimg]
  ss_fname = df$ss[iimg]
  mask_fname = df$mask[iimg]
  label_fname = df$fast[iimg]

  if (!all(file.exists(label_fname))) {

    ss = readnii(ss_fname)
    mask = readnii(mask_fname)
    # qimg = quantile_img(ss, mask = mask)
    ss = robust_window(ss, mask = mask,
      probs = c(0, 0.9999))
    ss = mask_img(ss, mask)

    bc = bias_correct(ss,
                      mask = mask_fname,
                      convergence = list(
                        iters = rep(400, 4),
                        tol = 1e-07),
                      correction = "N4")


    tissues = fast(bc, bias_correct = FALSE)
    writenii(tissues, filename = label_fname)
    # ortho2(img, filled)
  }
}
