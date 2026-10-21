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

## ----by-code------------------------------------------------------------------
df <- data.frame(dtmn = c("1106", "1312"), value = c(20, 10))
m <- get_map("municipio", data = df, by = "dtmn")

## ----pad----------------------------------------------------------------------
pt_pad_code(c(115, 1106), "municipio")

## ----by-name------------------------------------------------------------------
df <- data.frame(concelho = c("porto", "CÂMARA DE LOBOS", "S. João da Madeira"),
                 value = c(1, 2, 3))
pt_match(df$concelho)

## ----ambiguous----------------------------------------------------------------
pt_match("Lagoa")

## ----disambiguate-------------------------------------------------------------
pt_match(c("Lagoa (Faro)", "Lagoa (Açores)", "Lagoa (R.A.A.)"), quiet = TRUE)

pt_match("Lagoa", context = "Faro", quiet = TRUE)

## ----freg-context-------------------------------------------------------------
df <- data.frame(freg = c("Pinheiro", "Pinheiro"),
                 mun  = c("Guimarães", "Castro Daire"))
pt_match(df$freg, level = "freguesia", context = df$mun, quiet = TRUE)

## ----historic-----------------------------------------------------------------
pt_match(c("Sé", "Maximinos"), level = "freguesia",
         context = "Braga", quiet = TRUE)

## ----historic-to--------------------------------------------------------------
pt_match(c("Sé", "Maximinos"), level = "freguesia", context = "Braga",
         admin_vintage = "2011", quiet = TRUE)

## ----aliases------------------------------------------------------------------
pt_match("VN Gaia", aliases = c("VN Gaia" = "Vila Nova de Gaia"), quiet = TRUE)

## ----fuzzy, eval = requireNamespace("stringdist", quietly = TRUE)-------------
pt_match("Guimaraess", fuzzy = TRUE)

## ----report-------------------------------------------------------------------
res <- pt_match(c("Porto", "Lagoa", "Atlantis"), quiet = TRUE)
pt_match_report(res)

## ----get-map-join, eval = FALSE-----------------------------------------------
# m <- get_map("municipio", data = df, by = c(municipio = "concelho"))

## ----pt-join------------------------------------------------------------------
df <- data.frame(concelho = c("Porto", "Águeda"), value = c(1, 2))
out <- pt_join(df, by = c(municipio = "concelho"))
names(out)

## ----pt-join-vintage----------------------------------------------------------
ine <- data.frame(dtmnfr = "030882", value = 3)  # a união split in 2025
pt_join(ine, by = "dtmnfr", admin_vintage = "2013")[, c("dtmnfr", "freguesia", "municipio")]

## ----codes-direct-------------------------------------------------------------
codes <- pt_lookup(health_vintage = "2024")
head(codes[, c("dtmnfr", "freguesia", "dtmn", "municipio", "nuts3_cod", "unit")])

## ----normalize----------------------------------------------------------------
pt_normalize(c("S. Jorge", "SÃO JORGE", "Sao-Jorge"))

