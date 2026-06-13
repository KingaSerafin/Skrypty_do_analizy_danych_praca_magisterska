dir = "C:/Users/ADMIN/Desktop/2025_11_14_HEK/";      // wybór katalogu
list = getFileList(dir); // pobiera liste plikow

for (i = 0; i+1 < list.length; i++) {

    name = list[i];

    if (endsWith(name, ".tif") && indexOf(name, "green") != -1 && indexOf(name, "ROI") == -1 
    && indexOf(name, "red") == -1 && indexOf(name, "merged") == -1 && indexOf(name, "SD") == -1) {
    	
    	

        fullPath = dir + name;
        print("Przetwarzam: " + name);

        open(fullPath); // Otwórz obraz
        selectImage(name); // Wybierz otwarty obraz
        
        run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'" + name + "', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.0', 'probThresh':'0.3', 'nmsThresh':'0.15', 'outputType':'Label Image', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
		newName = replace(name, ".tif", "_SD.tif");
		saveAs("Tiff", dir + newName);
		close();
		close(name);
    }
    else {
    	print("pomijam " + name);
    	}
}