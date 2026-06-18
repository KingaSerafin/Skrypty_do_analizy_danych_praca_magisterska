library(readxl)
library(tidyr)
library(dplyr)

df_wide <- read_excel(
  path  = "~/Desktop/analiza/dane_mgr_srednie.xlsx",
  sheet = "zywe_poprawka"
)

# Przekształcenie do formatu długiego
df <- df_wide |>
  pivot_longer(
    cols      = everything(),
    names_to  = "grupa",
    values_to = "sygnal"
  ) |>
  mutate(sygnal = as.numeric(sygnal)) |>
  filter(!is.na(sygnal)) |>
  mutate(grupa = factor(grupa, levels = c(
    "zywe_15", "zywe_nieuszk"
  )))

# Mediany w grupach
aggregate(sygnal ~ grupa, data = df,
          FUN = function(x) round(median(x), 5))

# Podział na dwie grupy
grupa1 <- df$sygnal[df$grupa == "zywe_15"]
grupa2 <- df$sygnal[df$grupa == "zywe_nieuszk"]

# Test U Manna-Whitneya
mw <- wilcox.test(
  x           = grupa1,
  y           = grupa2,
  alternative = "two.sided",   
  paired      = FALSE,
  exact       = FALSE,          
  correct     = TRUE,          
  conf.int    = TRUE,
  conf.level  = 0.95
)

print(mw)
