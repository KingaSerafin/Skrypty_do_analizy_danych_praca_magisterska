library(readxl)
library(openxlsx)

#zmieniać nazwy pod analizowane dane
plik_wejsciowy  <- "~/Desktop/analiza/h2o2/h2o2.xlsx"
plik_wyjsciowy  <- "~/Desktop/analiza/h2o2/h2o2.xlsx" 
arkusz_wejscie  <- "probka"
arkusz_wyjscie  <- "probka_norm"         # nowy arkusz
zakres          <- "B2:GT158"

# Wczytanie danych
dane <- read_excel(plik_wejsciowy, sheet = arkusz_wejscie, range = zakres, col_names = TRUE)
#str(dane) # spr jakiego typy są dane, tylko gdy jest jakiś błąd i, aby go poprawić

# Wczytanie kolumny z czasem
czas <- read_excel(plik_wejsciowy, sheet = arkusz_wejscie, range = "A2:A158")

# wykrycie pustej kolumny - podział między green, a red
pusta_kolumna <- which(sapply(dane, function(k) all(is.na(k))))

if (length(pusta_kolumna) != 1) {
  stop("Nie znaleziono dokładnie jednej pustej kolumny separatora. Sprawdź dane!")
}

cat("Separator wykryty w kolumnie:", pusta_kolumna, "\n")

# Podział na dwa kanały
kanal_1 <- dane[, 1:(pusta_kolumna - 1)]
kanal_2 <- dane[, (pusta_kolumna + 1):ncol(dane)]

# Sprawdzenie zgodności liczby kolumn
if (ncol(kanal_1) != ncol(kanal_2)) {
  stop(paste("Kanały mają różną liczbę kolumn:", ncol(kanal_1), "vs", ncol(kanal_2)))
}

cat("Liczba ROI:", ncol(kanal_1), "\n")

# Obliczenie stosunku kanal_2 / kanal_1
stosunek <- kanal_2 / kanal_1

# Nadanie nazw kolumnom ratio
nazwy_roi <- gsub("_ROI.*", "", colnames(kanal_1))
colnames(stosunek) <- paste0("ROI_", nazwy_roi, "_ratio")

# Normalizacja:
# dla każdej kolumny osobno: liczona jest średnia z pierwszych 17 wierszy,
# następnie każda wartość w tej kolumnie jest dzielona przez tę średnią
stosunek_norm <- stosunek 

for (i in 1:ncol(stosunek)) {
  srednia_baseline    <- mean(stosunek[1:21, i] |> unlist())
  stosunek_norm[, i]  <- stosunek[, i] / srednia_baseline
}

# Nadanie nazw kolumnom normalizacji
colnames(stosunek_norm) <- paste0("ROI_", nazwy_roi, "_norm")

# Pusta kolumna separatora
separator <- data.frame(matrix(NA, nrow = nrow(stosunek), ncol = 1))
colnames(separator) <- ""

# Sklejenie: czas + ratio + separator + normalizacja
wynik <- cbind(czas, stosunek, separator, stosunek_norm)

# Zapis do istniejącego pliku - nowy arkusz
if (file.exists(plik_wyjsciowy)) {
  wb <- loadWorkbook(plik_wyjsciowy)    
} else {
  wb <- createWorkbook()                 
}

addWorksheet(wb, arkusz_wyjscie)
writeData(wb, arkusz_wyjscie, wynik)
saveWorkbook(wb, plik_wyjsciowy, overwrite = TRUE)

cat("Gotowe! Zapisano arkusz '", arkusz_wyjscie, "' z", ncol(stosunek), "kolumnami.\n")




