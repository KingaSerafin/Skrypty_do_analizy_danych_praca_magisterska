library(readxl)

# Wczytaj dane
df <- read_excel("~/Desktop/analiza/dane_mgr_srednie.xlsx", sheet = "150uj_zywe_ratio_avg", range = "A1:C33", col_names = TRUE)

# Test Wilcoxona dla prób zależnych
wynik <- wilcox.test(
  x = df$srednia_PRZED,
  y = df$srednia_PO,
  paired = TRUE,
  alternative = "two.sided" 
)

print(wynik)
