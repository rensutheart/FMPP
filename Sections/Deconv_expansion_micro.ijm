// Input paths
psf_file = "D:/BiochemData/PSF BW.tif";
//files_path = "D:\\BiochemData\\24 hpt (±46 hours old)\\CZI files\\";
files_path = "D:\\BiochemData\\UT 18 hpt (±38 hours old)\\CZI files\\";


// Output path
//deconv_path = "D:\\BiochemData\\24 hpt (±46 hours old)\\Deconv\\";
deconv_path = "D:\\BiochemData\\UT 18 hpt (±38 hours old)\\Deconv\\";


if(!File.exists(deconv_path))
	File.makeDirectory(deconv_path);

//list = getFileList(files_path);
filelist = getFileList(files_path);
count = 0;
for (i = 0; i < lengthOf(filelist); i++) {
    if (endsWith(filelist[i], ".czi")) { 
        count++;
    } 
}

list = newArray(count);
index = 0;
for (i = 0; i < count; i++) {
    if (endsWith(filelist[i], ".czi")) { 
        list[index] = filelist[i];
        index++;
    } 
}


close("*");


for(index = 0; index < list.length; index++)
{
	fName = list[index];

	//run("Bio-Formats Importer", "open=[" + files_path  + list[0]+ "]");
	//run("Stack Splitter", "number=24");

	run("Bio-Formats", "open=[" + files_path  + fName+ "] color_mode=Default rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT");

	selectImage(fName + " - C=1");
	close;
	selectImage(fName + " - C=2");
	close;
	selectImage(fName + " - C=0");
	prevn = nImages;
	run("DeconvolutionLab2 Run", " -image platform  "+fName + " - C=0 -psf file "+ psf_file + " -algorithm RLTV 10 1.000E-05 -out stack " + fName + " - C=0_deconv nosave");	 //or RLTV 30 1.000E-04 
	while(nImages == prevn)
		wait(50);
		
	saveAs("Tiff", deconv_path + fName.substring(0, fName.lastIndexOf(".")) + ".tif");
	close("*");
}
