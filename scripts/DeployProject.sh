
echo "*** Deploying Source to Org ..."
sfdx force:source:deploy --targetusername MyComponents --sourcepath force-app

echo "*** Run Test Cases W\Coverage ..."
sfdx force:apex:test:run -c -u MyComponents -r human

#No Longer Needed
#echo "*** Creating Managed Package ..."
##sfdx force:package:create --name "Demo Reset Tools" --packagetype Managed --path "force-app" --targetdevhubusername MyComponents

#echo "*** Creating Unlocked Package ..."
##sfdx force:package:create --name "Demo Reset Tools Unlocked" --packagetype Unlocked --path "force-app" --targetdevhubusername MyComponents


echo "*** Creating Package Version..."
sfdx force:package:version:create --package "Demo Reset Tools" --skipvalidation -k test1234 --wait 10 


echo "*** Creating Unlocked Package Version..."
sfdx force:package:version:create --package "Demo Reset Tools Unlocked" --skipvalidation -k test1234 --wait 10 


echo "*** Promoting Package ..."
sfdx force:package:version:promote -p "Demo Reset Tools@0.1.0-6"


echo "*** Pushing Package to Package Manager Org ..."
#sfdx force:package:install --package "Demo Reset Tools@0.1.0-6" --targetusername PackageManager --installationkey test1234