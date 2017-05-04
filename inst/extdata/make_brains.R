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
iimg = 5


for (iimg in seq(nrow(df))) {
  print(iimg)
  ss_fname = df$ss[iimg]
  mask_fname = df$mask[iimg]
  img_fname = df$image[iimg]
  label_fname = df$label[iimg]

  if (!all(file.exists(ss_fname, mask_fname))) {
    # aimg = antsImageRead(img_fname)
    # # q25 = quantile(aimg[aimg > 0], probs = 0.25)
    # q25 = 0
    # mask = array(aimg > q25, dim = dim(aimg))
    # mask = as.antsImage(mask, reference = aimg)

    img = rpi_orient(img_fname)
    img = img$img

    label = rpi_orient(label_fname)
    label = label$img

    full_mask = img > 0

    dd = dropEmptyImageDimensions(
      full_mask,
      other.imgs = list(img = img,
                        label = label))
    img = dd$other.imgs$img
    writenii(img, img_fname)

    label = dd$other.imgs$label
    writenii(label, label_fname)

    mask = label > 0
    filled = filler(mask, fill_size = 5) %>%
      oMath("FillHoles")
    writenii(filled, mask_fname)
    ss = mask_img(img, filled)
    writenii(ss, ss_fname)
    # ortho2(img, filled)
  }
}
