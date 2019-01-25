#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

f <- args[1]

if(file.exists(f)){
  library(Thermimage)

  img<-readflirJPG(f, exiftoolpath="installed")

  cams<-flirsettings(f, exiftoolpath="installed", camvals="")

  ObjectEmissivity<-  cams$Info$Emissivity              # Image Saved Emissivity - should be ~0.95 or 0.96
  dateOriginal<-cams$Dates$DateTimeOriginal             # Original date/time extracted from file
  dateModif<-   cams$Dates$FileModificationDateTime     # Modification date/time extracted from file
  PlanckR1<-    cams$Info$PlanckR1                      # Planck R1 constant for camera  
  PlanckB<-     cams$Info$PlanckB                       # Planck B constant for camera  
  PlanckF<-     cams$Info$PlanckF                       # Planck F constant for camera
  PlanckO<-     cams$Info$PlanckO                       # Planck O constant for camera
  PlanckR2<-    cams$Info$PlanckR2                      # Planck R2 constant for camera
  OD<-          cams$Info$ObjectDistance                # object distance in metres
  FD<-          cams$Info$FocusDistance                 # focus distance in metres
  ReflT<-       cams$Info$ReflectedApparentTemperature  # Reflected apparent temperature
  AtmosT<-      cams$Info$AtmosphericTemperature        # Atmospheric temperature
  IRWinT<-      cams$Info$IRWindowTemperature           # IR Window Temperature
  IRWinTran<-   cams$Info$IRWindowTransmission          # IR Window transparency
  RH<-          cams$Info$RelativeHumidity              # Relative Humidity
  h<-           cams$Info$RawThermalImageHeight         # sensor height (i.e. image height)
  w<-           cams$Info$RawThermalImageWidth          # sensor width (i.e. image width)

  temperature<-raw2temp(img, ObjectEmissivity, OD, ReflT, AtmosT, IRWinT, IRWinTran, RH,
                        PlanckR1, PlanckB, PlanckF, PlanckO, PlanckR2)

  outname=paste(normalizePath(dirname(f)),"/FLIR_", tools::file_path_sans_ext(basename(f)), sep="")

  writeFlirBin(as.vector(t(temperature)), templookup=NULL, w=w, h=h, I="", rootname=outname)
}
