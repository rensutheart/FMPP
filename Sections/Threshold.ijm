//input_path = "C:/RESEARCH/Sholto_Data/Pre-processed/";
//output_path = "C:/RESEARCH/Sholto_Data/Thresholded/";

input_path = "C:/RESEARCH/MEL/Pre-processed/";
output_path = "C:/RESEARCH/MEL/Thresholded/";

if(!File.exists(output_path))
	File.makeDirectory(output_path);

list = getFileList(input_path);

blockSize = 10;
C = 1;
outlierRadius = 2;

close("*");

for(index = 0; index < list.length; index++)
{
	fName = list[index];

	run("Bio-Formats", "open=[" + input_path + fName + "] color_mode=Default rois_import=[ROI manager] split_timepoints view=Hyperstack stack_order=XYCZT");
	// open(deconv_path + fName);

	numFrames = nImages;
	for(i = 0; i < numFrames; i++)
	{
		selectImage(input_path + fName + " - T=" + i);
		numSlices = nSlices;
		for (s = 1; s <= numSlices; s++)
		{
			setSlice(s);
			run("adaptiveThr ", "using=[Weighted mean] from=" + blockSize + " then=-" + C + " slice");
			//run("Make Binary", "method=Otsu background=Default calculate black");
		}

		run("Despeckle", "stack");
		run("Remove Outliers...", "radius=" + (outlierRadius) + " threshold=50 which=Bright stack");
		run("3D Fill Holes");
	}
	run("Concatenate...", "all_open open");
	saveAs("Tiff", output_path + fName);
	
	close("*");
}




