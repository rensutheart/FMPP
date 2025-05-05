// deconv_path = "C:/RESEARCH/Sholto_Data/Deconvolved/"
// output_path = "C:/RESEARCH/Sholto_Data/Pre-processed/";

deconv_path = "C:/RESEARCH/MEL/Deconvolved/"
output_path = "C:/RESEARCH/MEL/Pre-processed/";

if(!File.exists(output_path))
	File.makeDirectory(output_path);

list = getFileList(deconv_path);

close("*");

for(index = 0; index < list.length; index++)
{
	fName = list[index];

	run("Bio-Formats", "open=[" + deconv_path + fName + "] color_mode=Default rois_import=[ROI manager] split_timepoints view=Hyperstack stack_order=XYCZT");
	// open(deconv_path + fName);

	numFrames = nImages;
	for(i = 0; i < numFrames; i++)
	{
		selectImage(deconv_path + fName + " - T=" + i);
		run("8-bit");
		run("Subtract Background...", "rolling=6 stack");
		run("Sigma Filter Plus", "radius=1 use=2 minimum=0.2 outlier stack");
		run("Enhance Local Contrast (CLAHE)", "blocksize=64 histogram=256 maximum=1.25 mask=*None*");
		run("Gamma...", "value=0.8 stack");
	}
	run("Concatenate...", "all_open open");
	saveAs("Tiff", output_path + fName);
	
	close("*");
}
