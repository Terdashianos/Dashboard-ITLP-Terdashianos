rm(list = ls())
#######################################
###library(rworldxtra)
###library(tidyverse)
###library(sf)
###library(raster)

pacman::p_load(bslib, shiny, shinydashboard, tidyverse, shinythemes, highcharter, zoo, readxl, shinyWidgets,
               leaflet, sf, viridis, RColorBrewer, dplyr, htmlwidgets, leaflet.providers, haven, leaflet, leaflet.extras,
               rworldxtra, raster, paletteer, rcartocolor)

ITLP_mother_base <- read_excel("www/ITLP_mother_base.xlsx")
transfer_ej <- read_excel("www/transfer_ej.xlsx")
m_desemp <- read_excel("www/m_ejercido_desemp.xlsx")
programas_cdmx <- read_excel("www/Programas_cdmx.xlsx")
Programas_cdmx_presupuesto <- read_excel("www/Programas_cdmx_presupuesto.xlsx")
nbi <- read_excel("www/nbi.xlsx")
transferencias_ds <- read_excel("www/transferencias_ds.xlsx")
aprobado <- read_excel("www/aprobado.xlsx")
ejercido <- read_excel("www/ejercido.xlsx")
desempleo_aprobado <- read_excel("www/desempleo_aprobado.xlsx")
desempleo_ejercido <- read_excel("www/desempleo_ejercido.xlsx")
alcaldias_desmpleo <- read_excel("www/alcaldias_desmpleo.xlsx")

### cambiale la direccion

shape_est <- st_read("www/sin_islas.shp")
shape_mun <- st_read("www/MUNICIPIOS.shp")
sol_ciudad <- read_dta("www/base solicitudes ciudad.dta")
pobreza_ciudad <- read_dta("www/MAPAS PARA ALCALDIAS.dta")


as.yearqtr(ITLP_mother_base$fecha)