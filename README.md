# Rackspace-Cloud-Servers-Image-Import-Export
This script was written to solve a common problem with transfering an image from a datacenter in one region to another... for noobs :)

## What you'll need in order to run this script
* Rackspace Cloud Account
* A valid useraname and API key tied to that user
* A saved image under 40GB (why 40GB? because limits...) that you wish to use in some other regin than where it currently resides
* An empty Cloud Files EXPORT container, created in the region where the image resides
* An empty Cloud Files IMPORT container, created in the region where you'd like to transfer the image to
* The UUID of the server image you'd like to transfer

## Usage
Either download or copy/paste this script into a file. Make that file executable (ex: ``chmod u+x $script``)
and run it from your home directory

### Example usage and output
```sh
($:~) chmod u+x image-imp-and-exp.sh
($:~) ./image-imp-and-exp.sh

Please bear in mind that the containers for import/export must already exist in the source and destination regions in order for this script to run successfully

Please also bear in mind that the image upload does have a hard set limit of 40GB, in other words if the size of image you are attempting to transfer is greater than 40GB, this will fail
Enter your mycloud username:
myclouduser
Enter mycloud account number:
123546
Enter your mycloud user APIKey:
e8fd796738be41e7a1164ba52389cf79
Enter the image UUID that you want to export:
146C1422-E43B-446D-8533-C43AB977532D
Enter the region where the image resides:[dfw,ord,iad,lon,syd,hkg]
iad
Enter the name of the container you're EXPORTING the image to:
IAD_Export_Container
If there are any errors, use the following task id at https://pitchfork.cloudapi.co/images/#get_task_details-images for more details
Task id: 160a143f-3948-4130-ae7e-0ee9618ecbd1
Image export is: processing
Image export is: processing
Image export is: processing
Image export is: processing
Image export is: processing
Image export is: processing
Image export is: processing
Image export is: processing
Image Export process complete! Now Begining the Image Import process
Enter the region you want to transfer the image to:[dfw,ord,iad,lon,syd,hkg]
ord
Enter the name of the exsisting container you're IMPORTING to:
ORD_Import_Container

Downloading the exported image locally now, so that it can be uploaded to the export container
This may take quite a bit of time depending on how large the image is

% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
25 1965M   25  503M    0     0  2353k      0  0:14:15  0:03:38  0:10:37 2098k

The image is finished downloading
Now beginigng the upload to the IMPORT continer in the destination region
Uploading the image to the it's final destination
Again, this may take some time depending on how large the image is
% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
25 1965M   25  503M    0     0  2353k      0  0:14:15  0:03:38  0:10:37 2098k
HTTP/1.1 100 Continue
HTTP/1.1 201 Created
Last-Modified: Tue, 16 Aug 2016 05:05:17 GMT
Content-Length: 0
Etag: 6cf0c43c268cacb9f1e30c2b483d2eaa
Content-Type: text/html; charset=UTF-8
X-Trans-Id: txa445ee6d0da64ca687d87-0057b29f0cord1
Date: Tue, 16 Aug 2016 05:05:53 GMT

Please name the image you want to transfer
raxtst-iad2ord-imgxfer
If there are any errors, use the following task id at https://pitchfork.cloudapi.co/images/#get_task_details-images for more details
Task id: 8578ce78-295d-4c7e-a7a9-2f84050ce54d
Image import is: processing
Image import is: processing
Image import is: processing
Image import is: processing
Image import is: processing
Image import is: processing
Image import is: processing
Image import is: processing
echo "Image import complete! The image can now be used to build a server in the new region."
```
