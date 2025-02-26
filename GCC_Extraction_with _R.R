library(phenopix)
#library(raster)
library(terra)

imags_path <- "data/images/"
output <- "Output/"
path_ROI <- "data/ROI/"


# We selected the first photo in the folder as the referece photo
# it took at the mid day of Augest with good weater.
path_img_ref <- "data/images/Ylpssuo_2024_08_16_111013.jpg"
terra::plotRGB(rast(path_img_ref))

# Draw the ROI on the reference photo
DrawMULTIROI(path_img_ref, path_ROI, nroi = 1,"roi_Ylpssuo", file.type='.jpg')
# we then load the ROI

load( "data/ROI/roi.data.Rdata")

ylp_roi <- roi.data['roi_Ylpssuo']

# we can check the roi again

PrintROI("data/images/Ylpssuo_2024_10_31_111013.jpg" , path_ROI)

# PERFECT

# WE first check the date format of the images
extractDateFilename(path_img_ref, date.code='yyyy_mm_dd_HHMM')
# if successful, we can now extract the VIs
# you should remove damaged photo
extractVIs(img.path = imags_path, 
           roi.path = path_ROI, 
           vi.path = output,
           date.code='yyyy_mm_dd_HHMM', 
           npi=1,
           ncores=5,
           log.file=output)



# laod the vegtation index data

load('Output/VI.data.Rdata')

with(VI.data$roi_Ylpssuo, plot(date, ri.av, pch=20, col='red',ylim=c(0.1,0.6), ylab='Relative indexes'))
with(VI.data$roi_Ylpssuo, points(date, gi.av, col='green', pch=20))
with(VI.data$roi_Ylpssuo, points(date, bi.av, col='blue', pch=20)) 



# filter out data
filtered.data <- autoFilter(VI.data$roi_Ylpssuo)

# cover to data frame
dataframed <- convert(filtered.data, year='2024')

my.options <- get.options()
my.options$max.filter$qt <- 0.95
filtered.data2 <- autoFilter(VI.data$roi_Ylpssuo,filter.options=my.options,raw.dn = T)

# compare the 2 methods
plot(filtered.data$max.filtered,ylim=c(0.33,0.36),ylab ="GCC")
lines(filtered.data2$max.filtered, col='red')
legend('topleft', col=palette()[1:2], lty=1, legend=c('90th', '95th'), bty='n')
