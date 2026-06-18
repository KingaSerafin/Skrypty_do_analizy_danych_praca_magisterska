library(readxl)
library(openxlsx)

plik_wejsciowy  <- "~/Desktop/analiza/dane_mgr_ratio_norm.xlsx"
plik_wyjsciowy  <- "~/Desktop/analiza/dane_mgr_normalnosc.xlsx"
arkusz_wejscie  <- "15uj_utrwalone_ratio"
arkusz_wyjscie  <- "15uj_utrwalone_SH-W"

# Wczytanie danych
dane <- read_excel(plik_wejsciowy, sheet = arkusz_wejscie)

# wykrycie kolumn z normalizacją (kończą się na "_norm")
kolumny_norm <- grep("_norm", colnames(dane), value = TRUE)
cat("Znalezione kolumny norm:", length(kolumny_norm), "\n")

# Wyodrębnienie samych danych znormalizowanych
dane_norm <- dane[, kolumny_norm]

# Shapiro-Wilk dla każdego wiersza (punktu czasowego)
p_values <- apply(dane_norm, 1, function(wiersz) {
  shapiro.test(unlist(wiersz))$p.value
})

# Ramka danych z wynikami
wyniki_shapiro <- data.frame(p_value_shapiro = p_values)

# Kolumna z interpretacją
wyniki_shapiro$normalnosc <- ifelse(p_values > 0.05, "normalne", "nienormalne")

arkusz_wyjscie <- paste0(arkusz_wejscie, "_SH-W")

# Zapis do nowego pliku
if (file.exists(plik_wyjsciowy)) {
  wb <- loadWorkbook(plik_wyjsciowy)
} else {
  wb <- createWorkbook()
}

addWorksheet(wb, arkusz_wyjscie)
writeData(wb, arkusz_wyjscie, wyniki_shapiro)
saveWorkbook(wb, plik_wyjsciowy, overwrite = TRUE)

cat("Gotowe! Zapisano p-value w arkuszu '", arkusz_wyjscie, "'.\n")