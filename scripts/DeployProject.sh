echo "*** Deploying Source to Org ..."
sfdx force:source:deploy --targetusername MyComponents --sourcepath force-app
echo "*** Creating Package ..."
sfdx force:package:create --name "Demo Reset Tools" --packagetype Unmanaged --path "force-app" --targetdevhubusername MyComponents