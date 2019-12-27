rm(list = ls())
library(neurobase)
library(extrantsr)
library(ANTsR)
library(fslr)
library(readr)
library(dplyr)

imgs = list.files(pattern = "\\d.nii.gz")
df = data.frame(image = imgs,
                label = gsub("[.]nii", "_glm.nii", imgs),
                stringsAsFactors = FALSE)
df$ss = gsub("[.]nii", "_SS.nii", df$image)
df$mask = gsub("[.]nii", "_mask.nii", df$image)
df$tissues = gsub("[.]nii", "_tissues.nii", df$image)
iimg = 5

lut = read_csv(file = "../MICCAI-Challenge-2012-Label-Information.csv")
lut = lut[, c(1,3)]
colnames(lut) = c("index", "label")
lut$label[ is.na(lut$label)] = "None"
lut$label = recode(lut$label, None = 0, CSF = 1, GM = 2, WM = 3)
lut$label = as.integer(lut$label)

for (iimg in seq(nrow(df))) {

  print(iimg)
  img_fname = df$image[iimg]
  ss_fname = df$ss[iimg]
  mask_fname = df$mask[iimg]
  tissue_fname = df$tissues[iimg]
  label_fname = df$label[iimg]

  if (!all(file.exists(tissue_fname))) {

    img = readnii(label_fname)
    uvals = sort(unique(c(img)))

    idf = lut[ lut$index %in% uvals, ]
    idf = idf[ idf$label != 0, ]
    tissues = img * 0

    splitdf = split(idf, idf$label)
    for (ilabel in seq_along(splitdf)) {
      idf = splitdf[[ilabel]]
      index = idf$index
      label = unique(idf$label)

      tissues[ img %in% index ] = label
    }


    writenii(tissues, filename = tissue_fname)
  }
}
