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

## ----uls-map------------------------------------------------------------------
plot_pt(level = "uls")

## ----uls-join-----------------------------------------------------------------
df <- data.frame(uls = c("ULS Coimbra", "uls são joão"), casos = c(340, 120))
m <- get_map("uls", data = df, by = "uls")
plot_pt(m, value = "casos")

## ----uls-municipio------------------------------------------------------------
h <- pt_lookup(health_vintage = "2024")
unique(h$unit_municipio[h$unit != h$unit_municipio])

## ----uls-municipio-chain------------------------------------------------------
u <- unique(h$unit_municipio[h$municipio == "Lisboa"])
lx <- h[h$unit_municipio == u, ]
table(lx$municipio, sub("ULS ", "", lx$unit))

## ----grain--------------------------------------------------------------------
df <- data.frame(concelho = "Gondomar", v = 1)
out <- pt_join(df, by = c(municipio = "concelho"))
out$uls_municipio
"uls" %in% names(out)

## ----uls-municipio-map--------------------------------------------------------
df <- data.frame(concelho = c("Lisboa", "Odivelas", "Porto", "Maia", "Coimbra"),
                 casos = c(10, 5, 7, 3, 4))
df <- pt_join(df, by = c(municipio = "concelho"))
casos <- aggregate(casos ~ uls_municipio, data = df, FUN = sum)
casos
plot_pt(casos, value = "casos", level = "uls_municipio", by = "uls_municipio")

## ----vintages-----------------------------------------------------------------
h24 <- pt_lookup(health_vintage = "2024")
h22 <- pt_lookup(health_vintage = "2022")
d <- data.frame(municipio = h24$municipio,
                reg_saude_2022 = h22$reg_saude[match(h24$dtmnfr, h22$dtmnfr)],
                reg_saude = h24$reg_saude)
d <- d[d$reg_saude != d$reg_saude_2022, ]
unique(d[, c("municipio", "reg_saude_2022", "reg_saude")])

## ----aces-join----------------------------------------------------------------
df <- data.frame(aces = c("ACES Baixo Vouga", "aces braga"), casos = c(10, 20))
head(pt_join(df, by = "aces"))

## ----aces-map, eval = FALSE---------------------------------------------------
# plot_pt(level = "aces")

## ----aces-municipio-----------------------------------------------------------
h <- pt_lookup(health_vintage = "2022")
grep(" [+] ", unique(h$unit_municipio), value = TRUE)

