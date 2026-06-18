library(readxl)
library(openxlsx)

plik_wejsciowy  <- "~/Desktop/analiza/dane_mgr_ratio_norm.xlsx"
plik_wyjsciowy  <- "~/Desktop/analiza/dane_mgr_mediana.xlsx"
arkusz_wejscie  <- "60uj_korekta"

# Wczytanie danych
dane <- read_excel(plik_wejsciowy, sheet = arkusz_wejscie)

# Wczytanie kolumny z czasem
czas <- dane[, grep("czas", colnames(dane), ignore.case = TRUE)]

# Automatyczne wykrycie kolumn z normalizacją
kolumny_norm <- grep("_norm", colnames(dane), value = TRUE)
cat("Znalezione kolumny norm:", length(kolumny_norm), "\n")

dane_norm <- dane[, kolumny_norm]

# Obliczenia dla każdego wiersza (punktu czasowego)
wyniki <- data.frame(
  mediana  = apply(dane_norm, 1, function(w) median(unlist(w), na.rm = TRUE)),
  Q1       = apply(dane_norm, 1, function(w) quantile(unlist(w), 0.25, na.rm = TRUE)),
  Q3       = apply(dane_norm, 1, function(w) quantile(unlist(w), 0.75, na.rm = TRUE)),
  srednia  = apply(dane_norm, 1, function(w) mean(unlist(w), na.rm = TRUE)),
  sd       = apply(dane_norm, 1, function(w) sd(unlist(w), na.rm = TRUE))
)

# Sklejenie z czasem
wynik_koncowy <- cbind(czas, wyniki)

# Zapis do nowego pliku
arkusz_wyjscie <- paste0(arkusz_wejscie, "_st")

if (file.exists(plik_wyjsciowy)) {
  wb <- loadWorkbook(plik_wyjsciowy)
} else {
  wb <- createWorkbook()
}

addWorksheet(wb, arkusz_wyjscie)
writeData(wb, arkusz_wyjscie, wynik_koncowy)
saveWorkbook(wb, plik_wyjsciowy, overwrite = TRUE)

cat("Gotowe! Zapisano statystyki w pliku '", plik_wyjsciowy, "'.\n")