echo "*** Creating scratch org ..."
sfdx force:org:create -f config/project-scratch-def.json --setdefaultusername --setalias MyComponentsScratch -d 30
echo "*** Opening scratch org ..."
#sfdx force:org:open
echo "*** Pushing metadata to scratch org ..."
sfdx force:source:push
echo "*** Assigning permission set to your user ..."
sfdx force:user:permset:assign --permsetname Demo_Reset_Tools
sfdx force:user:permset:assign --permsetname Demo_Reset_Tools_Testing_Permission_Set
echo "*** Generating password for your user ..."
sfdx force:user:password:generate --targetusername MyComponentsScratch
echo "*** Creating data"
sfdx force:data:tree:import -f ./data/data-Account.json,./data/data-Contact.json,./data/data-Demo_Reset_Task__c.json -u MyComponentsScratch
