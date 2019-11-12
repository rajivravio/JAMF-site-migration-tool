AUTHOR: Rajiv Ravishankar / rajivravio@gmail.com / rrs@northwestern.edu
DATE: 10NOV2019
VER: 1.0

This tool is designed to automate moving JAMF resources accross sites within the same JAMF instance. Specifically built to move JAMF resources
from the main JAMF site to a subsite that are not natively supported through the web UI. These resources include:

 	1. computer static and smart groups
 	2. mobile device static and smart groups
 	3. computer policies
 	4. computer config profiles
 	5. mobile device config profiles
 	6. mobile apps

Depending on your setup, JAMF may also contain provisioning profiles, mac apps and more that need to be moved. The same template used for the 
other six resource types can be duplicated if needed.

Moving these resources is not a built in function of JAMF but moving computer and device objects are supported through the web UI. Ensure you 
move these objects first so that the scopes and group memberships are not lost. Please see JAMF documentation on how to best do this. The 
sequence to follow would be:

	1. move computer objects
	2. move device objects
	3. run script (which moves groups, then policies, then profiles, then mobile apps) 

Before running the script, you will need to ensure all the dependencies are in place 

	1. XML Updates:
	These would include the target changes we will be pushing. To set these up correctly, look in the /xml_updates folder for the different 
	templates by resource type. The tool requires XML files for each resource type moved that has the target site information. You can generate 
	new ones for different tags than the ones in the template by navigating to https://jamf.url.com:8443/api 

		1. targetComputerGroupSiteField.xml 			---> Which Site would you like to move the computer groups to?
		2. targetDeviceGroupSiteField.xml 				---> Which Site would you like to move the device groups to?
		3. targetComputerPolicySiteField.xml 			---> Which Site would you like to move the computer policies to?
		4. targetComputerConfigProfileSiteField.xml 	---> Which Site would you like to move the computer config profiles to?
		5. targetDeviceConfigProfileSiteField.xml 		---> Which Site would you like to move the device config profiles to?
		6. targetMobileAppsSiteField.xml 				---> Which Site would you like to move the mobile apps to?

	WARNING: Changes made here will be applied to the JAMF database. Edit with caution. 
	
	2. Resource IDs:
	These are the policy IDs, group IDs, app IDs of resources that need to be moved. You will need to fill in the resource IDs in column 2 of 
	the appropriate resource data file in /resource_data. Column 1 is reserved to enter the resource name but the script does not need this 
	information to function. 

		1. computerConfigProfilesToMove.csv
		2. computerGroupsToMove.csv
		3. computerPoliciesToMove.csv
		4. deviceConfigProfilesToMove.csv
		5. mobileAppsToMove.csv
		6. mobileDeviceGroupsToMove.csv

	WARNING: Ensure you do not have any commas in the resource names. This will cause the text parsing to contain errors.

	3. OPTIONAL: If you want to pull resource ID data quickly, /resource_queries contails SQL commands you can run against the jamfsoftware 
	database for polling numbers by resource type.

		1. mobile_device_groups.sql
		2. computer_config_profiles.sql
		3. computer_groups.sql
		4. computer_policies.sql
		5. mobile_device_apps.sql
		6. mobile_device_config_profiles.sql

Once dependency setup is complete, run update the following fields in migrateResourcesToNewSite.sh:

	apiUsername="<jamf_api_username>"
	apiPassword="<jamf_api_password>"
	jssServer="<https://jamf.instance.url:8443>"
	pathToXMLFolder="/path/to/folder/xml_updates"
	pathToResourceIDs="/path/to/folder/resource_data"
 
The API user needs admin access to the full site in order for this to work. The script will output errors in migration if authentication or 
pre-reqs fail. Read through these after migration to ensure there isn't anything broken after. 







