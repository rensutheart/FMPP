path = "C:/RESEARCH/Sholto_Data_N2_N3/N3/"
list = getFileList(path);
print("Directory contains "+list.length+" files");

for(i = 0; i < list.length; i++)
{
	fName = list[i];
	if(fName.endsWith(".czi"))
	{
		print(fName);
//		open(path + fName);
		run("Bio-Formats Importer", "open=[" + path  + fName+ "]");
		run("Split Channels");
		selectWindow("C1-" + path + fName);
		close();
		selectWindow("C2-" + path + fName);
		if(!File.exists(path + "Mito_Tiff/"))
			File.makeDirectory(path + "Mito_Tiff/");
		saveAs("Tiff", path + "Mito_Tiff/" + fName.substring(0, fName.lastIndexOf(".")) + ".tif");
		close();
	}
}


