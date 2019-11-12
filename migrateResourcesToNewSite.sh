##################################################################################################################
# This script is designed to automate moving JAMF resources accross sites. Specifically built to move IT resources
# from the main JAMF site to a subsite.
#
# Moving these resources is not a built in function but moving computer and device objects are supported through 
# the web UI. Ensure you move these object first so that the scopes and group members ships are not lost.
# 
# The api user needs admin access to the full site in order for this to work. The script will output errors in 
# migration if authentication or pre-reqs fail. Read through these after migration to ensure there isn't anything
# broken after. 
#
# The script requires xml files for each resource type moved that has the target site information. You can generate
# these by navigating to https://jamf.qatar.northwestern.edu:8443/api
#
# For the purposes of this move, I have created the following xml dependencies:
#	1. targetComputerGroupSiteField.xml
#	2. targetDeviceGroupSiteField.xml
#	3. targetComputerPolicySiteField.xml
#	4. targetComputerConfigProfileSiteField.xml
#	5. targetDeviceConfigProfileSiteField.xml
#	6. targetMobileAppsSiteField.xml
#
# Once you have identified the ID of each resource in each resource type, update them in the script below so they
# are moved when run.	
#
# AUTHOR: Rajiv Ravishankar / rajivravio@gmail.com / rrs@northwestern.edu
# DATE: 10NOV2019
# VER: 1.0
##################################################################################################################

#/bin/bash

apiUsername="<jamf_api_username>"
apiPassword="<jamf_api_password>"
jssServer="<https://jamf.instance.url:8443>"
pathToXMLFolder="/path/to/folder/xml_updates"
pathToResourceIDs="/path/to/folder/resource_data"

# Fill in these arrays with the appropriate IDs. Queries to pull this from the jamfsoftware database is included in
# the resource_queries folder

# This will include static and smart computer group IDs
computerGroupsToMove=( $(cut -d ',' -f2 "${pathToResourceIDs}"/computerGroupsToMove.csv ) )

# This will include static and smart mobile device group IDs
mobileDeviceGroupsToMove=( $(cut -d ',' -f2 "${pathToResourceIDs}"/mobileDeviceGroupsToMove.csv ) )

# This will include computer policy IDs
computerPoliciesToMove=( $(cut -d ',' -f2 "${pathToResourceIDs}"/computerPoliciesToMove.csv ) )

# This will include OSX configuration profile IDs
computerConfigProfilesToMove=( $(cut -d ',' -f2 "${pathToResourceIDs}"/computerConfigProfilesToMove.csv ) )

# This will include mobile device configuration profile IDs
deviceConfigProfilesToMove=( $(cut -d ',' -f2 "${pathToResourceIDs}"/deviceConfigProfilesToMove.csv ) )

# This will include mobile apps (in-house, self-service)
# Note that if the provisioning profile of an app is not baked into the .ipa, a seperate move of the provisioning 
# profiles must be added to the script
mobileAppsToMove=( $(cut -d ',' -f2 "${pathToResourceIDs}"/mobileAppsToMove.csv ) )

# WARNING: Ensure you have manually migrated the computer and mobile device objects from within the JAMF web UI before running this script

# Migrate Computer Groups
xmlComputerGroupFile="${pathToXMLFolder}/targetComputerGroupSiteField.xml"
for computerGroupID in "${computerGroupsToMove[@]}"
do
	echo "working on computer group ID #: ${computerGroupID}"
	curl -s -k -u "${apiUsername}:${apiPassword}" -H "Content-Type: application/xml" -X "PUT" -d "@${xmlComputerGroupFile}" "${jssServer}/JSSResource/computergroups/id/${computerGroupID}"
done

# Migrate Mobile Device Groups
xmlMobileDeviceGroupFile="${pathToXMLFolder}/targetDeviceGroupSiteField.xml"
for mobileDeviceGroupID in "${mobileDeviceGroupsToMove[@]}"
do
	echo "working on mobile device group ID #: ${mobileDeviceGroupID}"
	curl -s -k -u "${apiUsername}:${apiPassword}" -H "Content-Type: application/xml" -X "PUT" -d "@${xmlMobileDeviceGroupFile}" "${jssServer}/JSSResource/mobiledevicegroups/id/${mobileDeviceGroupID}"
done

# Migrate Computer Policies
xmlPolicyFile="${pathToXMLFolder}/targetComputerPolicySiteField.xml"
for policyID in "${computerPoliciesToMove[@]}"
do
	echo "working on policy ID #: ${policyID}"
	curl -s -k -u "${apiUsername}:${apiPassword}" -H "Content-Type: application/xml" -X "PUT" -d "@${xmlPolicyFile}" "${jssServer}/JSSResource/policies/id/${policyID}"
done

# Migrate Computer Configuration Profiles
xmlComputerConfigProfileFile="${pathToXMLFolder}/targetComputerConfigProfileSiteField.xml"
for computerConfigProfileID in "${computerConfigProfilesToMove[@]}"
do
	echo "working on computer config profile ID #: ${computerConfigProfileID}"
	curl -s -k -u "${apiUsername}:${apiPassword}" -H "Content-Type: application/xml" -X "PUT" -d "@${xmlComputerConfigProfileFile}" "${jssServer}/JSSResource/policies/id/${computerConfigProfileID}"
done

# Migrate Mobile Device Configuration Profiles
xmlDeviceConfigProfileFile="${pathToXMLFolder}/targetDeviceConfigProfileSiteField.xml"
for deviceConfigProfileID in "${deviceConfigProfilesToMove[@]}"
do
	echo "working on mobile device config profile ID #: ${deviceConfigProfileID}" 
	curl -s -k -u "${apiUsername}:${apiPassword}" -H "Content-Type: application/xml" -X "PUT" -d "@${xmlDeviceConfigProfileFile}" "${jssServer}/JSSResource/policies/id/${deviceConfigProfileID}"
done

# Migrate Mobile Apps
xmlMobileAppFile="${pathToXMLFolder}/targetMobileAppSiteField.xml"
for mobileAppID in "${mobileAppsToMove[@]}"
do
	echo "working on mobile app ID #: ${mobileAppID}"
	curl -s -k -u "${apiUsername}:${apiPassword}" -H "Content-Type: application/xml" -X "PUT" -d "@${xmlMobileAppFile}" "${jssServer}/JSSResource/policies/id/${mobileAppID}"
done
