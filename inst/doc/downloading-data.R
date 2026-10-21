## ----include = FALSE----------------------------------------------------------
# Network-dependent: nothing here is evaluated at build time.
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----setup, eval = TRUE-------------------------------------------------------
library(geopt)

## ----client-------------------------------------------------------------------
# client <- GeoClient$new()
# client

## ----failed-download----------------------------------------------------------
# # With no internet connection
# bgri <- get_censos("Braga")
# #> Downloading Censos 2021 0303 (BGRI2021_0303.zip)...
# #> Error: Could not reach mapas.ine.pt: Could not resolve hostname
# #> [mapas.ine.pt]: Could not resolve host: mapas.ine.pt. Check your internet
# #> connection, or try again later.

## ----failed-download-catch----------------------------------------------------
# bgri <- lapply(c("Braga", "Guimarães"), function(m) {
#   tryCatch(get_censos(m), geopt_download_error = function(e) NULL)
# })

## ----caop---------------------------------------------------------------------
# # Latest year, full detail, as sf
# mun <- client$get_caop("continente", "municipio")
# 
# # A specific year and a simplification preset
# freg_2022 <- client$get_caop("continente", "freguesia",
#                              year = 2022, detail = "medium")

## ----download-only------------------------------------------------------------
# paths <- client$download_caop("continente", year = 2024)

## ----ogc----------------------------------------------------------------------
# # One district's municipalities
# lisboa <- client$get_ogc("municipios", properties = list(distrito = "Lisboa"))
# 
# # Everything inside a rectangle (longitude and latitude)
# box <- client$get_ogc("freguesias", bbox = c(-9.3, 38.6, -9.0, 38.85))
# 
# # A filter expression, in the service's query language (CQL)
# alg <- client$get_ogc("municipios", cql_filter = "distrito_ilha = 'Faro'")

## ----cos----------------------------------------------------------------------
# cos <- client$get_ogc("cos2023v1", bbox = c(-8.45, 40.15, -8.35, 40.25))

## ----collections--------------------------------------------------------------
# client$list_ogc_collections()

## ----censos-------------------------------------------------------------------
# # City blocks of Braga, 2021 variables included
# bgri <- get_censos("Braga")
# 
# library(ggplot2)
# ggplot(bgri) +
#   geom_sf(aes(fill = N_INDIVIDUOS / as.numeric(sf::st_area(geometry)) * 1e6),
#           color = NA) +
#   scale_fill_viridis_c(name = "hab/km²", trans = "log10")

## ----censos-variants----------------------------------------------------------
# # The 2011 census has 122 variables; keep only some
# get_censos("Braga", year = 2011,
#            variables = c("N_INDIVIDUOS_RESIDENT", "N_EDIFICIOS_CLASSICOS"))
# 
# # Secções: INE's 2021 files have about 180 variables.
# # For earlier censuses, geopt merges the subsecções and adds up their counts.
# get_censos("Braga", level = "seccao")
# get_censos("Braga", level = "seccao", year = 2011)
# 
# # A NUTS3, and the 2021-only 1 km grid (region scope only)
# get_censos(region = "Cávado")
# get_censos(region = "continente", level = "grid")
# 
# # Data without geometry
# get_censos("Braga", geometry = FALSE)

## ----censos-vars, eval = TRUE-------------------------------------------------
head(pt_censos_vars[pt_censos_vars$year == 2021 &
                      pt_censos_vars$level == "subseccao",
                    c("variable", "description")])

## ----export-------------------------------------------------------------------
# client$export_boundaries(mun, "municipios.geojson", detail = "low")

## ----cache--------------------------------------------------------------------
# client$list_cached()
# client$clear_cache("processed")  # or "raw", "all"

