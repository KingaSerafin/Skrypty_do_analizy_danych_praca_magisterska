library(readxl)
library(ggplot2)

plik          <- "~/Desktop/analiza/dane_mgr_mediana.xlsx"
arkusz        <- "60uj_utrwalone_ratio_stat"
os_x_min      <- 0
os_x_max      <- 180
os_y_min      <- 0.8
os_y_max      <- 1.05
nazwa_grupy   <- "UTRWALONE komórki \n(mediana ± IQR)"

dane <- read_excel(plik, sheet = arkusz)
colnames(dane)[1] <- "czas"

dane$grupa <- nazwa_grupy 

wykres <- ggplot(dane, aes(x = czas, color = grupa, fill = grupa)) +
  
  geom_ribbon(aes(ymin = Q1, ymax = Q3),
              alpha = 0.3, color = NA) +      
  
  geom_line(aes(y = mediana),
            linewidth = 1) +                  
  geom_vline(xintercept = 4.56, lwd = 0.8, color = "navy", linetype = "dashed") +
  scale_x_continuous(limits = c(os_x_min, os_x_max), expand = c(0, 0)) +
  scale_y_continuous(limits = c(os_y_min, os_y_max), expand = c(0, 0)) +
  scale_color_manual(values = setNames("#cc0066", nazwa_grupy)) +
  scale_fill_manual(values  = setNames("#ff99cc", nazwa_grupy)) +
  labs(
    title = NULL, #"A.", #"B. Sygnał akceptora",
    x     = "Czas [s]",
    y     = "Znormalizowany stosunek R/G",
    color = NULL,
    fill  = NULL
  ) +
  
  theme_classic() +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.4),
    panel.grid.minor = element_line(color = "grey92", linewidth = 0.2),
    axis.line        = element_line(color = "black"),
    plot.title       = element_text(face = "bold", size = 14),
    legend.position  = c(0.8, 0.9),
    legend.text = element_text(size = 12, face = "bold"),
    axis.title.x     = element_text(face = "bold", size = 14),
    axis.title.y     = element_text(face = "bold", size = 15),
    axis.text.x      = element_text(face = "bold", size = 12),
    axis.text.y      = element_text(face = "bold", size = 12)
  )

print(wykres)