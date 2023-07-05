input_path = "/Volumes/Extreme SSD/RESEARCH/Vanderbilt Samples/2023/Marina/Output/Thresholded_RAW/"
output_path = "/Volumes/Extreme SSD/RESEARCH/Vanderbilt Samples/2023/Marina/Output/Thresholded_Registered/"

if(!File.exists(output_path))
	File.makeDirectory(output_path);

list = getFileList(input_path);

close("*");

maxShift = 50;

for(index = 0; index < list.length; index++) 
{
	fName = list[index];
	open(input_path + fName);
	getDimensions(width, height, channels, slices, frames);

	run("Correct 3D drift", "channel=1 correct only=0 lowest=1 highest=" + slices + " max_shift_x=" +maxShift +" max_shift_y=" +maxShift +" max_shift_z=0");

	saveAs("Tiff", output_path + fName);
	
	close("*");
}



