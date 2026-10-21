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

## ----timeline, echo = FALSE, fig.height = 2.8, fig.retina = 2, eval = requireNamespace("ggplot2", quietly = TRUE), fig.alt = "Timeline from 1995 with one row each for freguesias, NUTS 3 regions and health units, showing the years each vintage was in force."----
library(ggplot2)

n_units <- function(x) length(unique(x))
nuts3 <- function(v) pt_nuts_codes$nuts3_cod[pt_nuts_codes$nuts_vintage == v]

x_min <- 1995
x_max <- 2029

# One bar per vintage, over the years it was in force. A bar with an open start
# is a map with no single start date, and fades in from `start`.
v <- data.frame(
  row = c(3, 3, 3, 3, 2, 2, 2, 1, 1),
  label = c("2001", "2011", "2013", "2025", "2002", "2013", "2024", "2022", "2024"),
  start = c(x_min, 2004, 2013, 2025, 2002, 2015, 2024, 2008, 2024),
  end = c(2001.5, 2013, 2025, x_max, 2015, 2024, x_max, 2024, x_max),
  open_start = c(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE),
  current = c(FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE),
  count = c(
    n_units(pt_lookup(admin_vintage = "2001")$dtmnfr),
    n_units(pt_lookup(admin_vintage = "2011")$dtmnfr),
    n_units(pt_lookup(admin_vintage = "2013")$dtmnfr),
    n_units(pt_lookup(admin_vintage = "2025")$dtmnfr),
    n_units(nuts3("2002")), n_units(nuts3("2013")), n_units(nuts3("2024")),
    n_units(pt_lookup(health_vintage = "2022")$unit),
    n_units(pt_lookup(health_vintage = "2024")$unit)
  )
)

surface <- "#ffffff"
ink <- "#0b0b0b"
muted <- "#52514e"
gap <- 0.1   # half the white gap between neighbouring bars, in years
h <- 0.2     # half the bar height
fade <- 3    # years over which an open start fades in

v$x0 <- ifelse(v$start == x_min, v$start, v$start + gap)
v$x1 <- ifelse(v$end == x_max, v$end, v$end - gap)
v$fill <- ifelse(v$current, "#2a78d6", "#9ec5f4")
v$text_col <- ifelse(v$current, "#ffffff", ink)
solid <- transform(v, x0 = ifelse(open_start, x0 + fade, x0))

# The fade is drawn as thin slices blended from the background to the bar colour
fades <- do.call(rbind, lapply(which(v$open_start), function(i) {
  k <- 24
  edges <- seq(v$x0[i], v$x0[i] + fade, length.out = k + 1)
  mix <- grDevices::colorRamp(c(surface, v$fill[i]))((seq_len(k) - 0.5) / k)
  data.frame(row = v$row[i], x0 = edges[-(k + 1)], x1 = edges[-1] + 0.02,
             fill = grDevices::rgb(mix, maxColorValue = 255))
}))

rows <- data.frame(
  row = 3:1,
  name = c("Freguesias", "NUTS 3 regions", "Health units"),
  arg = c("admin_vintage", "nuts_vintage", "health_vintage")
)

ggplot() +
  geom_rect(aes(xmin = x0, xmax = x1, ymin = row - h, ymax = row + h,
                fill = I(fill)), data = fades) +
  geom_rect(aes(xmin = x0, xmax = x1, ymin = row - h, ymax = row + h,
                fill = I(fill)), data = solid) +
  geom_text(aes(x = x0 + 0.35, y = row, label = paste0('"', label, '"'),
                colour = I(text_col)), data = solid, hjust = 0, size = 3.5) +
  geom_text(aes(x = x0 + 0.35, y = row - h - 0.13,
                label = format(count, big.mark = ",")),
            data = solid, hjust = 0, vjust = 1, colour = muted, size = 3) +
  geom_text(aes(x = x_min - 0.6, y = row + 0.08, label = name), data = rows,
            hjust = 1, colour = ink, size = 3.6, fontface = "bold") +
  geom_text(aes(x = x_min - 0.6, y = row - 0.16, label = arg), data = rows,
            hjust = 1, colour = muted, size = 3, family = "mono") +
  scale_x_continuous(breaks = seq(1995, 2025, 5), minor_breaks = x_min:x_max,
                     expand = c(0, 0)) +
  scale_y_continuous(expand = expansion(add = c(0.45, 0.35))) +
  coord_cartesian(xlim = c(x_min, x_max), clip = "off") +
  labs(x = NULL, y = NULL) +
  theme_minimal(base_size = 11) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.grid.major.x = element_line(colour = "#e1e0d9", linewidth = 0.3),
    panel.grid.minor.x = element_line(colour = "#f0efec", linewidth = 0.25),
    axis.text.y = element_blank(),
    axis.text.x = element_text(colour = muted),
    plot.background = element_rect(fill = surface, colour = NA),
    plot.margin = margin(8, 12, 4, 118)
  )

## ----crosswalk----------------------------------------------------------------
x <- pt_crosswalk("2013", "2025")
table(x$relation)

## ----split-example------------------------------------------------------------
x[x$from == "010121", ]

## ----split--------------------------------------------------------------------
old <- data.frame(dtmnfr = "010121", casos = 100)

# Copy the value to every restored freguesia (right for rates)
pt_recode(old, from = "2013", values = "casos", split = "replicate")

# Share it out in proportion to area
pt_recode(old, from = "2013", values = "casos",
          split = "weight", weights = "area")

## ----split-pop, eval = FALSE--------------------------------------------------
# pop <- c("010130" = 14000, "010133" = 5000)  # population per freguesia
# pt_recode(old, from = "2013", values = "casos",
#           split = "weight", weights = pop)

## ----pre2013-recode-----------------------------------------------------------
old <- data.frame(dtmnfr = c("010301", "010302", "010314"),
                  pop = c(500, 800, 300))
pt_recode(old, from = "2011", values = "pop", aggregate = sum)

## ----pre2013------------------------------------------------------------------
x11 <- pt_crosswalk("2011", "2025")
table(x11$relation)

## ----pre2013-names------------------------------------------------------------
x11[x11$to == "030364", c("from", "name_from", "name_to")]

## ----pre2013-forward----------------------------------------------------------
old <- data.frame(freg = c("Sé", "Maximinos", "Cividade", "Gualtar"),
                  mun = "Braga", pop = c(100, 200, 300, 400))
old$dtmnfr <- pt_match(old$freg, level = "freguesia", context = old$mun,
                        quiet = TRUE)
old

## ----pre2013-aggregate--------------------------------------------------------
aggregate(pop ~ dtmnfr, old, sum)

## ----pre2013-own--------------------------------------------------------------
d <- data.frame(dtmnfr = pt_match(old$freg, level = "freguesia",
                                   context = old$mun, admin_vintage = "2011",
                                   quiet = TRUE),
                pop = old$pop)
d
pt_recode(d, from = "2011", values = "pop", aggregate = sum)

## ----ponte--------------------------------------------------------------------
x01 <- pt_crosswalk("2001", "2011")
x01[x01$from == "030838", ]

## ----ponte-recode-------------------------------------------------------------
pt_recode(data.frame(dtmnfr = "030838", taxa = 4.2), from = "2001",
          to = "2011", values = "taxa", split = "replicate")

## ----merge--------------------------------------------------------------------
members <- x$to[x$from == "010121"]
df <- data.frame(dtmnfr = members, casos = c(30, 10))

pt_recode(df, from = "2025", to = "2013", values = "casos", aggregate = sum)

## ----year-map, eval = FALSE---------------------------------------------------
# m2013 <- get_map("freguesia", admin_vintage = "2013")
# sum(m2013$geopt_type == "boundary")   # 3092 freguesias

## ----year-map-join, eval = FALSE----------------------------------------------
# get_map("freguesia", admin_vintage = "2013", data = data_2021, by = "dtmnfr")

## ----names-2013---------------------------------------------------------------
pt_match(c("Buarcos e São Julião", "Buarcos"), level = "freguesia",
         context = "Figueira da Foz", admin_vintage = "2013", quiet = TRUE)

## ----censos-2011, eval = FALSE------------------------------------------------
# bgri <- get_censos(region = "ram", year = 2011,
#                    variables = "N_INDIVIDUOS_RESIDENT")
# freg_2011 <- aggregate(bgri["N_INDIVIDUOS_RESIDENT"],
#                        by = list(dtmnfr = bgri$dtmnfr), FUN = sum)

## ----nuts-revisions-----------------------------------------------------------
pt_nuts_codes[pt_nuts_codes$dtmn == "0503", c("nuts_vintage", "nuts3_cod", "nuts3")]

## ----nuts-old-name------------------------------------------------------------
pt_match(c("Tâmega", "Alto Trás-os-Montes"), level = "nuts3", quiet = TRUE)

pt_match(c("Tâmega", "Alto Trás-os-Montes"), level = "nuts3",
         nuts_vintage = "2002", quiet = TRUE)

## ----nuts-shared-name---------------------------------------------------------
pt_match("Ave", level = "nuts3", quiet = TRUE)                        # today's Ave
pt_match("Ave", level = "nuts3", nuts_vintage = "2002", quiet = TRUE) # the 2002 Ave

## ----nuts-shared-table--------------------------------------------------------
n <- pt_nuts_codes
members <- function(v, nm) sort(n$dtmn[n$nuts_vintage == v & n$nuts3 == nm])

shared <- intersect(n$nuts3[n$nuts_vintage == "2002"],
                    n$nuts3[n$nuts_vintage == "2024"])
moved <- Filter(function(nm) !identical(members("2002", nm), members("2024", nm)),
                shared)
moved

