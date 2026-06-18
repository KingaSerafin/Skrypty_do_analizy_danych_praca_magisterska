library(readxl)
library(ggplot2)
library(dplyr)

plik  <- "~/Desktop/analiza/dane_mgr_mediana.xlsx"
dane1 <- read_excel(plik, sheet = "60uj_zywe_ratio_stat")
dane2 <- read_excel(plik, sheet = "60uj_zywe_nieuszk_ratio_stat")

colnames(dane1)[1] <- "czas"
colnames(dane2)[1] <- "czas"

# Dodaj kolumnę identyfikującą grupę
dane1$grupa <- "Komórki USZKADZANE \n(mediana ± IQR)"
dane2$grupa <- "Komórki KONTROLNE \n(mediana ± IQR)\n"

# Połącz w jedną ramkę
dane_all <- bind_rows(dane1, dane2)

# USTAWIENIA OSI
os_x_min <- 0
os_x_max <- 15
os_y_min <- 0.8
os_y_max <- 1.05

# Wykres
wykres <- ggplot(dane_all, aes(x = czas, color = grupa, fill = grupa)) +
  geom_ribbon(aes(ymin = Q1, ymax = Q3),
              alpha = 0.3, color = NA) +
  geom_line(aes(y = mediana),
            linewidth = 1.15) +
  geom_vline(xintercept = 4.56, lwd = 0.8, color = "navy", linetype = "dashed") +
  scale_x_continuous(limits = c(os_x_min, os_x_max), expand = c(0, 0)) +
  scale_y_continuous(limits = c(os_y_min, os_y_max), expand = c(0, 0)) +
  scale_color_manual(values = c("Komórki USZKADZANE \n(mediana ± IQR)" = "#ff9900",
                                "Komórki KONTROLNE \n(mediana ± IQR)\n" = "#663300")) +
  scale_fill_manual(values  = c("Komórki USZKADZANE \n(mediana ± IQR)" = "#ffcc33",
                                "Komórki KONTROLNE \n(mediana ± IQR)\n" = "#CC9966")) +
  labs(
    title = NULL, #"A.60",
    x     = "Czas [s]",
    y     = "Znormalizowany stosunek R/G",
    color = NULL,   # usuwa tytuł legendy
    fill  = NULL
  ) +
  theme_classic() +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.4),
    panel.grid.minor = element_line(color = "grey92", linewidth = 0.2),
    legend.position  = c(0.77, 0.2),   # lub "bottom", "right", c(0.8, 0.9),
    legend.text = element_text(size = 11, face = "bold"),
    axis.title.x = element_text(face = "bold", size = 13),
    axis.title.y = element_text(face = "bold", size = 14),
    axis.text.x = element_text(face = "bold", size = 12),
    axis.text.y = element_text(face = "bold", size = 12)
  )

print(wykres)