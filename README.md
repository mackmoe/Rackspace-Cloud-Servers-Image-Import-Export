# Rackspace-Cloud-Servers-Image-Import-Export
A simple Bash Script that allows you to Import/Export your Cloud Server images from one region to another

Example of it being Ran:

($:~) ./image-imp-and-exp.sh

Please bear in mind that the containers for import/export must already exist and be empty in the source and destination regions in order for this script to run successfully

Enter your mycloud username:

myclouduser

Enter mycloud account number:

123456

Enter your mycloud user APIKey:

e8fd796738be41e7a1164ba52389cf79

Enter the image UUID that you want to export:

146C1422-E43B-446D-8533-C43AB977532D

Enter the region where the image resides:[dfw,ord,iad,lon,syd,hkg]

dfw

Enter the name of the exsisting container you're exporting to:

DFW_Image_Export

Enter the name of the exsisting container you're importing to:

IAD_Image_Import

Enter the name of what you'd like to call the imported image:

tst_exp

The export task ID is 4b60d086-5a50-4dc6-8e2e-294a11dfc932

Image export is: processing

Image export is: processing

Image export is: processing

[... snip ...]

