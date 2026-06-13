//dir = "C:/Users/ADMIN/Desktop/2025_11_14_HEK/";      // wybór katalogu
dir="/Users/kingaserafin/Desktop/do mgr/2026_04_29_HEK/2026_04_29_H2O2_kontrola_obrazy/";
list = getFileList(dir); // pobiera liste plikow

for (i = 0; i < list.length; i++) {
    name = list[i];

    if (endsWith(name, ".tif") != -1 && indexOf(name, "stack") != -1 && indexOf(name, "SD") != -1 && indexOf(name, "ROI") == -1 && indexOf(name, "green") != -1 && indexOf(name, "red") == -1 && indexOf(name, "maska") == -1) {

        fullPath = dir + name;
        print("Przetwarzam: " + name);

        open(fullPath); // Otwórz obraz
        selectImage(name); // Wybierz otwarty obraz
        setThreshold(1, 65535);
		setOption("BlackBackground", true);
		run("Convert to Mask", "background=Dark black");
		
		run("Watershed", "stack");
		
		newName = replace(name, ".tif", "_maska.tif");
		saveAs("Tiff", dir + newName);
		close();
		close(name);

    }
    else {
    	print("Pomijam " + name);
    	}
}