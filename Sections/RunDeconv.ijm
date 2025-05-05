psf_folder = "D:\\RESEARCH\\2025\\Marisa\\PSFs\\";
listFolders = newArray("C5", "C7", "MK H37Rv");

basePath = "D:\\RESEARCH\\2025\\Marisa\\";
deconv_path = basePath + "Deconvolution\\";
overwriteExisting = false; // <<<< Set this to true if you want to always reprocess

if(!File.exists(deconv_path))
	File.makeDirectory(deconv_path);

for(folder = 0; folder < listFolders.length; folder++) {
	print("Processing folder: " + listFolders[folder]);
	deconv_temp_path = deconv_path + listFolders[folder] + "\\";
	if(!File.exists(deconv_temp_path))
		File.makeDirectory(deconv_temp_path);

	files_path = basePath + listFolders[folder] + "\\";
	filelist = getFileList(files_path);

	// First loop to count matching files
	count = 0;
	for (i = 0; i < lengthOf(filelist); i++) {
	    if (endsWith(filelist[i], ".czi") && indexOf(filelist[i], "Structured Illumination") > 0) { 
	        count++;
	    } 
	}
	print(count + " files found");

	list = newArray(count);
	index = 0;
	for (i = 0; i < lengthOf(filelist); i++) {
	    if (endsWith(filelist[i], ".czi") && indexOf(filelist[i], "Structured Illumination") > 0) { 
	        list[index] = filelist[i];
	        index++;
	    } 
	}
	
	close("*");

	for(index = 0; index < list.length; index++) {
		fName = list[index];
		saveName = fName.substring(0, fName.lastIndexOf(".")) + ".tif";
		savePath = deconv_temp_path + saveName;

		if (!overwriteExisting && File.exists(savePath)) {
			print(index + "\tSkipping " + fName + " (already processed)");
			continue;
		}

		print("\tProcessing File: " + fName);
		run("Bio-Formats", "open=[" + files_path  + fName+ "] color_mode=Default rois_import=[ROI manager] view=Hyperstack");
		numSlices = nSlices;
		psf_file = psf_folder + "PSF_z" + numSlices + ".tif";

		prevn = nImages;		
		run("DeconvolutionLab2 Run", " -image platform  " + fName + " -psf file " + psf_file + " -algorithm RLTV 10 1.000E-04 -out stack " + fName + "_deconv nosave");

		while(nImages == prevn)
			wait(50);

		found = false;
		for (i = 1; i <= nImages; i++) {
		    title = getTitle();
		    if (endsWith(title, "_deconv")) {
		        print("Found:", title);
		        selectImage(i);
		        found = true;
		        break;
		    }
		}
		if (!found)
		    print("No image ending with '_deconv' was found.");
		else
		    saveAs("Tiff", savePath);

		close("*");
	}
}
