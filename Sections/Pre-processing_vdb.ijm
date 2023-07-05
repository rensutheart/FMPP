// deconv_path = "C:/RESEARCH/Sholto_Data/Deconvolved/"
// output_path = "C:/RESEARCH/Sholto_Data/Pre-processed/";

//deconv_path = "C:/RESEARCH/MEL/Deconvolved/"
//output_path = "C:/RESEARCH/MEL/Pre-processed/";

//deconv_path = "/Volumes/Extreme SSD/RESEARCH/2023/Peroxisomes/2 - Deconv/"
//deconv_path = "/Volumes/Extreme SSD/RESEARCH/2023/Peroxisomes/4 - Thresh/"
//output_path = "/Volumes/Extreme SSD/RESEARCH/2023/Peroxisomes/4 - Thresh/"

deconv_path = "/Volumes/Extreme SSD/RESEARCH/Vanderbilt Samples/2023/Marina/Samples/MH15.2_hNPCs_Untreated/"
output_path = "/Volumes/Extreme SSD/RESEARCH/Vanderbilt Samples/2023/Marina/Output/Untreated/Thresh_contr/"

if(!File.exists(output_path))
	File.makeDirectory(output_path);

list = getFileList(deconv_path);

close("*");

outlierRadius = 0.5; // for peroxisomes

for(index = 0; index < 1; index++) // list.length
{
	fName = list[index];

	run("Bio-Formats", "open=[" + deconv_path + fName + "] color_mode=Default rois_import=[ROI manager] split_timepoints concatenate_series view=Hyperstack stack_order=XYCZT");
	// open(deconv_path + fName);

	numFrames = nImages;
	for(i = 0; i < numFrames ; i++)
	{
		//selectImage(fName + " - " +fName + " (series 1) - T=" + i);
		selectImage(fName + " - T=" + i);
//		run("8-bit");
		run("Subtract Background...", "rolling=10 stack");
		run("Sigma Filter Plus", "radius=1 use=2 minimum=0.2 outlier stack");
		
//		run("Enhance Contrast", "saturated=0.05");
		numSlices = nSlices;
		for (s = 1; s <= numSlices; s++)
		{
			setSlice(s);
			run("Enhance Local Contrast (CLAHE)", "blocksize=32 histogram=256 maximum=1.5 mask=*None*");
			//run("Make Binary", "method=Otsu background=Default calculate black");
		}
		run("Gamma...", "value=.9 stack");
//		run("Make Binary", "method=Default background=Default calculate black");

		centerSlice = Math.floor(nSlices/2);
		setSlice(centerSlice);
//		run("Make Binary", "method=Otsu background=Default black");
		run("Auto Threshold", "method=Default white stack use_stack_histogram");
		run("Despeckle", "stack");
		run("Remove Outliers...", "radius=" + (outlierRadius) + " threshold=50 which=Bright stack");
//		run("3D Fill Holes");
	}
//	break;
	run("Concatenate...", "all_open open");
	saveAs("Tiff", output_path + fName);
	
	close("*");
}

