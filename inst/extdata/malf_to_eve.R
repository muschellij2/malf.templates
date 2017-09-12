###########################
# Trying
###########################
rm(list = ls())
library(extrantsr)
library(ms.lesion)
library(malf.templates)
library(EveTemplate)
library(neurobase)
library(ANTsR)

eve = getEvePath(what = "Brain")

iid = 1
templates = malf.templates::malf_images()
brains = templates$brains
brain_img = brains[iid]

target_file = brains[35]
target_img = readnii(target_file)

outprefix = file.path(
  "~/eve_malf", nii.stub(brain_img, bn = TRUE))
outprefix = path.expand(outprefix)

reg = registration(
  filename = brain_img,
  template.file = eve, 
  remove.warp = FALSE,
  outprefix = outprefix
  )
# res = readAntsrTransform(reg$fwdtransforms[2])

outprefix = tempfile()
eve_to_file = registration(
  filename = eve,
  template.file = target_file, 
  remove.warp = FALSE,
  outprefix = outprefix
  )

outprefix = tempfile()
brain_to_file = registration(
  filename = brain_img,
  template.file = target_file, 
  remove.warp = FALSE,
  outprefix = outprefix
  )

both = ants_apply_transforms(
  fixed = target_file,
  moving = brain_img,
  transformlist = c(reg$fwdtransforms,
    eve_to_file$fwdtransforms),
  interpolator = "Linear"
  )

twice = ants_apply_transforms(
  fixed = target_file,
  moving = reg$outfile,
  transformlist = eve_to_file$fwdtransforms,
  interpolator = "Linear"
  )

diff = twice - brain_to_file$outfile

