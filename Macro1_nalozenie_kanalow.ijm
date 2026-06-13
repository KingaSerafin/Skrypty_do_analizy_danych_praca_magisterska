//dir = "C:/Users/ADMIN/Desktop/2025_11_14_HEK/";      // wybór katalogu
dir="/Users/kingaserafin/Desktop/dane_h2o2/probka_1/";
list = getFileList(dir); // pobiera liste plikow

for (i = 0; i < list.length; i++) { //for - petla przeglada wszystkie pliki

    name = list[i];

    // filtr: plik .tif, zawiera "8uJ", NIE zawiera "ROI"
    if (endsWith(name, ".tif") && indexOf(name, "stack") != -1 && indexOf(name, "ROI") == -1 && indexOf(name, "green") == -1 && indexOf(name, "red") == -1) {

        fullPath = dir + name;
        print("Przetwarzam: " + name);

        open(fullPath); // Otwórz obraz
        selectImage(name); // Wybierz otwarty obraz
        run("Split Channels");

        // ======= Zielony kanał =======
        selectWindow("C1-" + name);
        run("Green");                               // zamienia lut z gray na green
        run("Gaussian Blur...", "sigma=1 stack");
        greenName = replace(name, ".tif", "_green.tif");
        saveAs("Tiff", dir + greenName);
        close(); // zamknięcie zielonej wersji
        
         // ======= Czerwony kanał =======
        selectWindow("C2-" + name);
        run("Red");                                  // zamienia lut z gray na red
        run("Gaussian Blur...", "sigma=1 stack");
        redName = replace(name, ".tif", "_red.tif");
        saveAs("Tiff", dir + redName);
        close(); // zamknięcie czerwonej wersji
        
        selectWindow("C3-" + name);
        close(); // zamyka stack swiatla przechodzacego
    }
    else {
    	print("Pomijam " + name);
    	}
}