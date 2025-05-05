/*
 * Macro template to process multiple images in a folder
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ File (label = "PSF", style = "file") psfpath
#@ String (label = "File suffix", value = ".tif") suffix

setBatchMode(true);
processFolder(input);
print("Deconvolution complete!");
setBatchMode(false);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
	print("Processing: " + input + File.separator + file);

	// Get stack information
	open(input + File.separator + file);
	title = getTitle;
	width = getWidth;
	height = getHeight;
	depth = nSlices;
	cstack = getImageID();

	// Iterate over stack frames
	for (i=1; i<=depth; i++) {
		selectImage(cstack);
		setSlice(i);
		run("Duplicate...", "title=Slice");
		cslice = getImageID();

		image = " -image platform active";
		psf = " -psf file " + psfpath;
		algorithm = " -algorithm RIF 0.1000 -path " + output;
		parameters = " -monitor no -out stack decon-" + i + " nosave";
		prevn = nImages;
		run("DeconvolutionLab2 Run", image + psf + algorithm + parameters);
		while(nImages == prevn)
			wait(50);
		selectImage(cslice);
		close();
		if(i > 1){
			run("Concatenate...", "stack1=frame-"+ (i-1) + " stack2=decon-" + (i) + " title=frame-" + i);
			close("decon-" + i);
			close("frame-" + (i-1));
			print("Frame " + i + "...");
		} else {
        	rename("frame-1");
		}
		
	}

	// Save result stack
	selectImage("frame-" + depth);
	saveAs("Tiff", output + File.separator + file);
	close();
	selectImage(cstack);
	close();
}
