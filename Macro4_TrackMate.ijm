dir="/Users/kingaserafin/Desktop/dane_h2o2/probka_2/";
list = getFileList(dir);

for (i = 0; i < list.length; i++) {

    name = list[i];

    if (endsWith(name, ".tif") && indexOf(name, "_green") != -1) {
	
		base = replace(name, "_green.tif", "");
		
        greenPath = dir + name;
        redPath = dir + base + "_red.tif";
        maskPath = dir + base + "_green_SD_maska.tif";

        if (File.exists(redPath) && File.exists(maskPath)) {
        	print("OK: " + base);
        	
        	open(greenPath);   //otwiera wszystkie trzy obrazy
            open(redPath);
            open(maskPath);
            
            selectImage(name);
            rename("green");

            selectImage(base + "_red.tif");
            rename("red");

            selectImage(base + "_green_SD_maska.tif");
            rename("mask");
            
             // nałozenie green
            run("Image Calculator...", "operation=AND create stack image1=green image2=mask");
            rename("green_masked");
            
            selectImage("green_masked");
            run("TrackMate");
            waitForUser("Sprawdź obraz i kliknij OK");

             // nałozenie red
            run("Image Calculator...", "operation=AND create stack image1=red image2=mask");
            rename("red_masked");
            
            selectImage("red_masked");
            run("TrackMate");
            waitForUser("Sprawdź obraz i kliknij OK");
            
            close("*");
            

        } else {
            print("Brak pary dla: " + name);
        }
    }
}