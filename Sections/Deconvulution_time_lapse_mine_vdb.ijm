// psf_file = "C:/RESEARCH/Sholto_Data/Mito_Tiff/PSF/PSF BW.tif";
//psf_file = "C:/RESEARCH/MEL/PSF BW.tif";
psf_file = "/Volumes/Extreme SSD/RESEARCH/2023/Peroxisomes/PSF BW.tif"
//files_path = "C:/RESEARCH/Sholto_Data/Mito_Tiff/";

//basePath = "C:/RESEARCH/Sholto_Data_N2_N3/N3/";
//basePath = "C:/RESEARCH/MEL/";
basePath = "/Volumes/Extreme SSD/RESEARCH/2023/Peroxisomes/"

//files_path = "C:/RESEARCH/Sholto_Data/Process_this/";

//files_path = basePath + "Mito_Tiff/";
files_path = basePath + "1 - Raw/";
//deconv_path = basePath + "Deconvolved/";
deconv_path = basePath + "2 - Deonv/";

if(!File.exists(files_path))
	File.makeDirectory(files_path);

if(!File.exists(deconv_path))
	File.makeDirectory(deconv_path);

//list = getFileList(files_path);
filelist = getFileList(files_path);
count = 0;
for (i = 0; i < lengthOf(filelist); i++) {
    if (endsWith(filelist[i], ".nd2")) { 
        count++;
    } 
}

list = newArray(count);
index = 0;
for (i = 0; i < count; i++) {
    if (endsWith(filelist[i], ".nd2")) { 
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

	run("Bio-Formats", "open=[" + files_path  + fName+ "] color_mode=Default rois_import=[ROI manager] split_timepoints view=Hyperstack stack_order=XYCZT");
	numFrames = nImages;
	for(i = 0; i < numFrames; i++)
	{
			selectImage(fName + " - T=" + i);
			prevn = nImages;
			run("DeconvolutionLab2 Run", " -image platform  "+fName + " - T=" + i + " -psf file "+ psf_file + " -algorithm RL 10 -out stack " + fName + "-T=" + i + "_deconv nosave");	 //or RLTV 30 1.000E-04 
			while(nImages == prevn)
				wait(50);
			selectImage(fName + " - T=" + i);
			close();	
	}
	
	
	run("Concatenate...", "all_open open");
	saveAs("Tiff", deconv_path + fName.substring(0, fName.lastIndexOf(".")) + ".tif");
	close("*");
}
