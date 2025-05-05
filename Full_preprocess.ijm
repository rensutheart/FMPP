// SHOLTO DATA
//psf_file = "C:/RESEARCH/Sholto_Data/Mito_Tiff/PSF/PSF BW.tif";
//files_path = "C:/RESEARCH/Sholto_Data/Mito_Tiff/";
// files_path = "C:/RESEARCH/Sholto_Data/Process_this/";
//output_path = "C:/RESEARCH/Sholto_Data/FullProcessed/"

psf_file = "C:/RESEARCH/Sholto_Data/Mito_Tiff/PSF/PSF BW.tif";

basePath = "C:/RESEARCH/Sholto_Data_N2_N3/N3/";
files_path = basePath + "Mito_Tiff/";
// files_path = basePath + "Process_this/";
output_path = basePath + "FullProcessed/";


if(!File.exists(files_path))
	File.makeDirectory(files_path);

if(!File.exists(output_path))
	File.makeDirectory(output_path);

// ORIGINAL MEL DATA
//files_path = "C:/RESEARCH/MEL_2020_CHOSEN/Original/"
//psf_file = "C:/RESEARCH/MEL_2020_CHOSEN/PSF BW.tif"
//output_path = "C:/RESEARCH/MEL_2020_CHOSEN/NewOutput/"

list = getFileList(files_path);

// Thresholding parameters
blockSize = 7.5;
C = 1;
outlierRadius = 2;

close("*");

for(index = 0; index < list.length; index++)
//for(index = 1; index < 2; index++)
{
	fName = list[index];

	//run("Bio-Formats Importer", "open=[" + files_path  + list[0]+ "]");
	//run("Stack Splitter", "number=24");

	run("Bio-Formats", "open=[" + files_path  + fName+ "] color_mode=Default rois_import=[ROI manager] split_timepoints view=Hyperstack stack_order=XYCZT");
	numFrames = nImages;
	for(i = 0; i < numFrames; i++)
	{
			selectImage(files_path + fName + " - T=" + i);

			// Deconvulution step
			prevn = nImages;
			run("DeconvolutionLab2 Run", " -image platform  "+files_path + fName + " - T=" + i + " -psf file "+ psf_file + " -algorithm RLTV 30 1.000E-04 -out stack " + fName + "-T=" + i + "_deconv nosave");	
			while(nImages == prevn)
				wait(50);
			selectImage(files_path + fName + " - T=" + i);
			close();	
			if (isOpen("Monitor of Run")) 	close("Monitor of Run");

			// Pre-process
			// TODO: I should make these parameters setable
			run("8-bit");
			run("Subtract Background...", "rolling=6 stack");
			run("Sigma Filter Plus", "radius=1 use=2 minimum=0.2 outlier stack");
			run("Enhance Local Contrast (CLAHE)", "blocksize=64 histogram=256 maximum=1.25 mask=*None*");
			run("Gamma...", "value=0.8 stack");

			// Threshold
			numSlices = nSlices;
			for (s = 1; s <= numSlices; s++)
			{
				setSlice(s);
				run("adaptiveThr ", "using=[Weighted mean] from=" + blockSize + " then=-" + C + " slice");
			}
	
			run("Despeckle", "stack");
			run("Remove Outliers...", "radius=" + (outlierRadius) + " threshold=50 which=Bright stack");
			run("3D Fill Holes");
	}
	
	
	run("Concatenate...", "all_open open");
	saveAs("Tiff", output_path + fName.substring(0, fName.lastIndexOf(".")) + ".tif");
	close("*");
}