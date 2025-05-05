run("Bio-Formats Macro Extensions");
// path = "C:/RESEARCH/MEL/Con001.czi"
//path = "C:/RESEARCH/Sholto_Chosen_data/Newest MEL/n1/Baf 2 (20.3).czi"
path = "/Volumes/Extreme SSD/RESEARCH/Sholto_Data_N2_N3/N2/Baf 1.czi"
open(path);
Ext.setId(path)
Ext.getMetadataValue("Information|Image|RefractiveIndex #1",refractiveIndexImmersion)
Ext.getMetadataValue("Information|Image|Channel|Wavelength #1",wavelength)
Ext.getMetadataValue("Information|Instrument|Objective|LensNA #1",NA)
Ext.getMetadataValue("Scaling|Distance|Value #1",pixelsizeXY)
getPixelSize(unit, pixelWidth, pixelHeight);
//getVoxelSize(width, height, depth, unit);
//width = getWidth();
//height = getHeight();
//depth = nSlices
Ext.getMetadataValue("Scaling|Distance|Value #3",zStep)
Ext.getMetadataValue(" SizeX",SizeX)
Ext.getMetadataValue(" SizeY",SizeY)
Ext.getMetadataValue(" SizeZ",SizeZ)
Stack.getDimensions(width, height, channels, slices, frames);


print("Refractive index immersion: " + refractiveIndexImmersion)
print("Wavelength: " + wavelength)
print("NA: " + NA)
print("Pixelsize XY: " + (parseFloat(pixelsizeXY)*1000000000.0))
print("Pixelsize XY v2: " + pixelWidth)
print("Z-step: " + (parseFloat(zStep)*1000000000.0))
print("Size X " + width + " Size Y " + height + " Size Z " + slices)
