library(readxl)
library(ggplot2)
library(tidyr)
###RStudio.Version() - do cytowania
# ============================================================
# USTAWIENIA
# ============================================================
plik           <- "~/Desktop/analiza/dane_mgr_srednie.xlsx"
arkusz         <- "wszystko_utrwalone"
os_y_min       <- 0.8
os_y_max       <- 1.05

# Kolory dla każdej grupy
kolory <- c(
  #"Przed\nmikroirradiacją"    = "#696969",   #kontrola czyli baseline, czyli komórki 17 klatek przed naswietlaniem
  "Komórki\nnieuszkadzane"    = "#cc9966",
  "15 µJ"    = "#b0e0e6",
  "30 µJ"    = "#ff9966",
  "60 µJ"    = "#ff99cc", #  "Żywe\nkomórki" = "#FFCC00", #"Utrwalone\nkomórki" = "#CC0066" 
  "150 µJ"   = "#CCccff"
)
# ============================================================

# Wczytanie danych
dane <- read_excel(plik, sheet = arkusz)

# Przekształcenie do formatu długiego
# Wymień nazwy kolumn na te które faktycznie są w pliku
dane_long <- pivot_longer(dane,
                          cols      = c(utrwalone_nieuszk, utrwalone_15, utrwalone_30, utrwalone_60, utrwalone_150), ##kontrola,zywe_nieuszk, zywe_15,zywe_30, zywe_60, zywe_150, utrwalone_nieuszk, utrwalone_15, utrwalone_30, utrwalone_60, utrwalone_150
                          names_to  = "grupa",
                          values_to = "wartosc")

# Przypisanie czytelnych etykiet - kolejność musi odpowiadać cols powyżej
dane_long$grupa <- factor(dane_long$grupa,
                          levels = c("utrwalone_nieuszk", "utrwalone_15", "utrwalone_30", "utrwalone_60", "utrwalone_150"), #"utrwalone_nieuszk", "utrwalone_15", "utrwalone_30", "utrwalone_60", "utrwalone_150","zywe_nieuszk", "zywe_15", "zywe_30", "zywe_60", "zywe_150"
                          labels = c("Komórki\nnieuszkadzane", "15 µJ", "30 µJ", "60 µJ", "150 µJ" )) #"NO DAMAGED", "15 µJ", "30 µJ", "60 µJ", "150 µJ"

# Boxplot
wykres <- ggplot(dane_long, aes(x = grupa, y = wartosc, fill = grupa)) +
  geom_boxplot(alpha = 0.7, outlier.shape = 16, outlier.size = 2) +
  scale_fill_manual(values = kolory) +
  scale_y_continuous(limits = c(os_y_min, os_y_max), expand = c(0, 0)) +
  coord_cartesian(ylim = c(os_y_min, os_y_max)) +
  labs(
    title = "B.", # "Spadek stosunku sygnału po korekcie na fotoblaknięcie\n                          podczas mikroirradiacji", #"A. Komórki żywe",
    x     = NULL, #"Porównanie różnych dawek mocy",
    y     = "Średni stosunek R/G",
    fill  = NULL
  ) +
  # Własna legenda opisująca elementy boxplota
  #annotate("text", x = Inf, y = Inf,
  #        label = "— mediana\n□ IQR (Q1–Q3)\n | Q1/Q3 ± 1,5×IQR\n● wartości odstające",
  #         hjust = 1.1, vjust = 1.5,
  #         size = 3.5,
  #        family = "sans",
  #       lineheight = 1.6) +
  theme_classic() +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.4),
    #panel.grid.minor = element_line(color = "grey92", linewidth = 0.2),
    legend.position  = "none",   # lub "bottom", "right", c(0.8, 0.9),
    axis.title.x = element_text(face = "bold", size = 13),
    axis.title.y = element_text(face = "bold", size = 14),
    #axis.line = element_line(size = 1.5, colour = "black"),
    axis.text.x = element_text(face = "bold", size = 14),
    axis.text.y = element_text(face = "bold", size = 12),
    plot.title       = element_text(face = "bold", size = 14)
  )

print(wykres)

#ggsave("~/Desktop/analiza/boxplot_srednie.png",
#      plot = wykres, width = 8, height = 6, dpi = 300)

cat("Gotowe!\n")