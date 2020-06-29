
echo "*** Deploying Source to Org ..."
sfdx force:source:deploy --targetusername MyComponents --sourcepath force-app
<<<<<<< HEAD

#No Longer Needed
#echo "*** Creating Managed Package ..."
##sfdx force:package:create --name "Demo Reset Tools" --packagetype Managed --path "force-app" --targetdevhubusername MyComponents

#echo "*** Creating Unlocked Package ..."
##sfdx force:package:create --name "Demo Reset Tools" --packagetype Unlocked --path "force-app" --targetdevhubusername MyComponents


echo "*** Creating Package Version..."
sfdx force:package:version:create --package "Demo Reset Tools" --installationkey test1234 --wait 10

echo "*** Promoting Package ..."
sfdx force:package:version:promote -p "Demo Reset Tools@0.1.0-4"


echo "*** Pushing Package to Package Manager Org ..."
#sfdx force:package:install --package "Expense Manager@0.1.0-1" --targetusername MyPackageManager --installationkey test1234 -wait 10 --publishwait 10

