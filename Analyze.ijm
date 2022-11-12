basePath = "C:/RESEARCH/Sholto_Data_N2_N3/N2/";
input_path = basePath + "FullProcessed/"; // Thresholded
output_path = basePath + "Data_output/";

if(!File.exists(output_path))
	File.makeDirectory(output_path);

list = getFileList(input_path);

close("*");

for(index = 0; index < list.length; index++)
{
	fName = list[index];
	print("Processing: " + fName);

	open(input_path + fName);
	run("3D TimeLapse (4D) Analysis", "perform count total mean total_0 mean_0 sphericity branches total_1 mean_1 branch branch_0 mean_2 if=Count volume surface sphericity_0 branches_0 total_2 mean_3 branch_1 branch_2 mean_4 longest mask=None mask_0=Mask second=None second_0=[Channel 2] third=None third_0=[Channel 3] =None to=None then=None");
	
	print("Save as: " + output_path +fName.substring(0,fName.lastIndexOf("."))+".csv");	
	//if(isOpen("3D Analysis Data - per Cell")) saveAs("Results", output_path +fName.substring(0,fName.lastIndexOf("."))+".csv");
	selectWindow("3D Analysis Data - per Cell");
//	saveAs("Results", output_path +fName.substring(0,fName.lastIndexOf("."))+".csv");
//	
//	if (isOpen("Results")) 	close("Results");
//	if (isOpen(fName.substring(0,fName.lastIndexOf("."))+".csv")) 	close(fName.substring(0,fName.lastIndexOf("."))+".csv");
//	if (isOpen("3D Analysis Data - per Cell")) 	close("3D Analysis Data - per Cell");
//
//	close("*");
}



//output_path = "C:/RESEARCH/Sholto_Data/Data_output/";
//fName = "test.tif"
//if(isOpen("3D Analysis Data - per Cell")) saveAs("Results", output_path +fName.substring(0,fName.lastIndexOf("."))+".csv");

