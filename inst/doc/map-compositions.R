## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 6,
  out.width = "100%"
)

# Interactive widgets embed their JavaScript libraries (several MB each), so
# they only run when pkgdown builds the website, not in the installed vignette.
widgets <- identical(Sys.getenv("IN_PKGDOWN"), "true")

## ----setup--------------------------------------------------------------------
library(geopt)
library(ggplot2)

## ----default------------------------------------------------------------------
m <- get_map()

## ----default-plot-------------------------------------------------------------
boundaries <- m[m$geopt_type == "boundary", ]
frames <- m[m$geopt_type == "frame", ]

ggplot() +
  geom_sf(data = boundaries, aes(fill = nuts2)) +
  geom_sf(data = frames, aes(linewidth = factor(geopt_frame_level)), fill = NA) +
  scale_linewidth_manual(values = c(0.8, 0.4, 0.2)) +
  guides(linewidth = "none") +
  theme_void()

## ----levels-------------------------------------------------------------------
m_nuts2 <- get_map("nuts2")
boundaries <- m_nuts2[m_nuts2$geopt_type == "boundary", ]
frames <- m_nuts2[m_nuts2$geopt_type == "frame", ]

ggplot() +
  geom_sf(data = boundaries, aes(fill = nuts2)) +
  geom_sf(data = frames, aes(linewidth = factor(geopt_frame_level)), fill = NA) +
  scale_linewidth_manual(values = c(0.8, 0.4, 0.2)) +
  guides(linewidth = "none") +
  theme_void()

## ----mainland-only------------------------------------------------------------
m <- get_map("nuts3", islands = "none")
ggplot(m) +
  geom_sf(aes(fill = nuts3)) +
  guides(fill = "none") +
  theme_void()

## ----no-raa-------------------------------------------------------------------
m <- get_map("nuts2", islands = island_layout(raa = "none"))
ggplot(m[m$geopt_type == "boundary", ]) +
  geom_sf(aes(fill = nuts2)) +
  theme_void()

## ----layout-groups------------------------------------------------------------
m <- get_map("nuts3", islands = island_layout(raa = "groups", ram = "whole"))
boundaries <- m[m$geopt_type == "boundary", ]
frames <- m[m$geopt_type == "frame", ]

ggplot() +
  geom_sf(data = boundaries, aes(fill = nuts2)) +
  geom_sf(data = frames, fill = NA, linewidth = 0.5) +
  guides(fill = "none") +
  theme_void()

## ----no-frames----------------------------------------------------------------
m <- get_map("freguesia", islands = island_layout(frames = FALSE))
ggplot(m) +
  geom_sf(aes(fill = nuts2), linewidth = 0.05) +
  theme_void()

## ----island-box, warning = FALSE----------------------------------------------
m <- get_map("nuts3", islands = "box")

ggplot() +
  geom_sf(data = m, aes(fill = area_ha), color = "white") +
  geom_sf_text(
    data = m[!is.na(m$geopt_label), ],
    aes(label = geopt_label),
    nudge_x = 0.3,
    hjust = 0,
    size = 4
  ) +
  theme_void()

## ----box-position, warning = FALSE--------------------------------------------
m <- get_map("nuts3", islands = island_layout("box", box_position = c(-11.5, 38.5)))

ggplot() +
  geom_sf(data = m, aes(fill = area_ha), color = "white") +
  geom_sf_text(
    data = m[!is.na(m$geopt_label), ],
    aes(label = geopt_label),
    nudge_x = 0.3,
    hjust = 0,
    size = 4
  ) +
  theme_void()

## ----layout-print-------------------------------------------------------------
lay <- island_layout()
lay

## ----layout-edit--------------------------------------------------------------
lay$raa$anchor <- lay$raa$anchor + c(-0.5, 0)
lay$ram$groups$madeira$scale <- 2.5
lay$raa$label <- "Azores"

m <- get_map("nuts3", islands = lay)
frames <- m[m$geopt_type == "frame", ]

ggplot() +
  geom_sf(data = m[m$geopt_type == "boundary", ], aes(fill = nuts2)) +
  geom_sf(data = frames, fill = NA, linewidth = 0.4) +
  guides(fill = "none") +
  theme_void()

frames$geopt_label

## ----region-norte-------------------------------------------------------------
m <- get_map("municipio")
norte <- m[m$nuts2_cod %in% "PT11", ]

ggplot(norte) +
  geom_sf(aes(fill = area_ha)) +
  theme_void()

## ----region-acores, fig.height = 3.5------------------------------------------
m <- get_map("municipio", islands = "in_place")
acores <- m[m$nuts2_cod %in% "PT20", ]

ggplot(acores) +
  geom_sf(aes(fill = municipio)) +
  guides(fill = "none") +
  theme_void()

## ----plot-pt------------------------------------------------------------------
df <- data.frame(
  concelho = c("Porto", "Lisboa", "Braga", "Faro", "Lagoa (Açores)"),
  score = c(10, 25, 15, 8, 12)
)

plot_pt(df, value = "score", by = c(municipio = "concelho"))

## ----plot-pt-both, eval = FALSE-----------------------------------------------
# m <- get_map("nuts3", islands = "box")
# 
# plot_pt(m, value = "area_ha")                        # ggplot
# plot_pt(m, value = "area_ha", renderer = "echarts")  # interactive widget

## ----plot-pt-style, eval = FALSE----------------------------------------------
# plot_pt(df, value = "score", by = c(municipio = "concelho")) +
#   labs(title = "My indicator") +
#   theme(legend.position = "bottom")
# 
# plot_pt(m, value = "area_ha", renderer = "echarts") |>
#   echarts4r::e_title("Area by NUTS3")

## ----ggplot2------------------------------------------------------------------
m <- get_map("municipio")
boundaries <- m[m$geopt_type == "boundary", ]
frames <- m[m$geopt_type == "frame", ]

ggplot() +
  geom_sf(data = boundaries, aes(fill = nuts2)) +
  geom_sf(data = frames, aes(linewidth = factor(geopt_frame_level)), fill = NA) +
  scale_linewidth_manual(values = c(0.8, 0.4, 0.2)) +
  guides(linewidth = "none") +
  theme_void()

## ----tmap, eval = requireNamespace("tmap", quietly = TRUE)--------------------
library(tmap)

m <- get_map("nuts2")
boundaries <- m[m$geopt_type == "boundary", ]
frames <- m[m$geopt_type == "frame", ]

# Static mode
tmap_mode("plot")

tm_shape(boundaries) +
  tm_polygons(fill = "nuts2") +
  tm_shape(frames) +
  tm_lines(
    lwd = "geopt_frame_level",
    lwd.scale = tm_scale_ordinal(values = c(0.8, 0.4, 0.2)),
    lwd.legend = tm_legend_hide()
  )

## ----echarts-inset, eval = widgets && requireNamespace("echarts4r", quietly = TRUE)----
# library(echarts4r)
# 
# m <- get_map("municipio", islands = island_layout(raa = "groups", ram = "whole"))
# m$name <- ifelse(is.na(m$municipio), m$geopt_label, m$municipio)
# geojson <- geojsonsf::sf_geojson(m)
# 
# m |>
#   e_charts(name) |>
#   e_map_register("pt", geojson) |>
#   e_map(area_ha, map = "pt", roam = TRUE, data = frame_data_echarts(m, "area_ha")) |>
#   e_visual_map(area_ha) |>
#   e_tooltip()

## ----echarts-box, eval = widgets && requireNamespace("echarts4r", quietly = TRUE)----
# m <- get_map("nuts3", islands = "box")
# m$name <- ifelse(is.na(m$geopt_label), m$nuts3, m$geopt_label)
# geojson <- geojsonsf::sf_geojson(m)
# 
# m |>
#   e_charts(name) |>
#   e_map_register("pt", geojson) |>
#   e_map(area_ha, map = "pt", roam = TRUE) |>
#   box_labels_echarts(m) |>
#   e_visual_map(area_ha) |>
#   e_tooltip()

## ----plotly-sf, eval = widgets && requireNamespace("plotly", quietly = TRUE), warning = FALSE, message = FALSE----
# library(plotly)
# 
# m <- get_map("nuts3", islands = island_layout(frames = FALSE))
# boundaries <- sf::st_cast(m, "MULTIPOLYGON")
# 
# plot_ly(
#   boundaries,
#   split = ~nuts3,
#   color = ~nuts3,
#   text = ~paste0(nuts3, "<br>Area: ", round(area_ha), " ha"),
#   hoverinfo = "text",
#   hoveron = "fills"
# ) |>
#   add_sf(showlegend = FALSE)

## ----plotly-ggplotly, eval = widgets && requireNamespace("plotly", quietly = TRUE) && packageVersion("plotly") >= "4.12.0", warning = FALSE----
# p <- ggplot(boundaries) +
#   geom_sf(
#     aes(
#       fill = nuts3,
#       text = paste0(nuts3, "<br>Area: ", round(area_ha), " ha")
#     )
#   ) +
#   guides(fill = "none") +
#   theme_void()
# 
# plotly::ggplotly(p, tooltip = "text", showlegend = FALSE)

