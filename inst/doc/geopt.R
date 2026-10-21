## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 6,
  out.width = "100%"
)

## ----setup--------------------------------------------------------------------
library(geopt)

## ----quick-plot---------------------------------------------------------------
df <- data.frame(
  concelho = c("Porto","Lisboa","Braga","Coimbra","Faro","Lagoa (Açores)","Santana (RAM)"),
  score = c(10, 25, 15, 12, 8, 18, 12)
)

plot_pt(df, value = "score", by = c(municipio = "concelho"))

## ----echarts, eval = identical(Sys.getenv("IN_PKGDOWN"), "true")--------------
# plot_pt(df, value = "score", by = c(municipio = "concelho"),
#         renderer = "echarts")

## ----check--------------------------------------------------------------------
df <- data.frame(
  concelho = c("Porto", "Lagoa", "Lisbon"),
  score    = c(10, 18, 25)
)

joined <- pt_join(df, by = c(municipio = "concelho"))

## ----report-------------------------------------------------------------------
pt_match_report(joined)

## ----fix----------------------------------------------------------------------
df$concelho[2] <- "Lagoa (Açores)"

joined <- pt_join(df, by = c(municipio = "concelho"),
                  aliases = c(Lisbon = "Lisboa"))
joined[, c("concelho", "dtmn", "municipio", "nuts3", "reg_saude")]

## ----get-map------------------------------------------------------------------
m <- get_map("nuts3")
head(m[, c("nuts3_cod", "nuts3", "area_ha")])

## ----nuts---------------------------------------------------------------------
now <- pt_lookup("municipio")
now[now$municipio %in% c("Lisboa", "Setúbal"), c("municipio", "nuts2_cod", "nuts2")]

before <- pt_lookup("municipio", nuts_vintage = "2013")
before[before$municipio %in% c("Lisboa", "Setúbal"), c("municipio", "nuts2_cod", "nuts2")]

## ----historic-----------------------------------------------------------------
pt_match("Sé", level = "freguesia", context = "Braga")

## ----downloads, eval = FALSE--------------------------------------------------
# # 2021 census data for Braga's statistical sections, with their boundaries
# braga <- get_censos("Braga", level = "seccao")
# 
# # Full-resolution municipality boundaries for the mainland
# client <- GeoClient$new()
# mun <- client$get_caop("continente", "municipio")

