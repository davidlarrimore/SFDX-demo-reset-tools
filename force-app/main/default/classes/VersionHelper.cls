public with sharing class VersionHelper {
    
    public List<String> getGithubSubscriberPackageVersions(String packageName){
        List<String> versions = new List<String>();
        string latestVersion = '';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://raw.githubusercontent.com/davidlarrimore/SFDX-demo-reset-tools/master/sfdx-project.json');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'animals' key as a list
            System.debug(results);
            Map<String,Object> packages = (Map<String,Object>) results.get('packageAliases');
            System.debug(packages);
           
            for (String fieldName : packages.keySet()){
                System.debug('field name is ' + fieldName);
                //PackageName = 'Demo Reset Tools Unlocked@'
                if(fieldName.contains(packageName)){
                    latestVersion = fieldName;
                }
                versions.add((String)packages.get(fieldName));
            }
            System.debug('Latest Version of "Demo Reset Tools Unlocked" is: ' + latestVersion + ' (' + packages.get(latestVersion) + ')');
        }
        System.debug('Returning SubscriberPackageVersions: ' + versions);
        return versions; 
    }

    public List<SFDXPackage> getInstalledVersions(){

        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        request.setHeader('Content-Type', 'application/json');
        String SFdomainUrl=URL.getSalesforceBaseUrl().toExternalForm();
        String query='SELECT+Id+,SubscriberPackage.Name+,SubscriberPackage.Id+,SubscriberPackage.NamespacePrefix+,SubscriberPackageVersion.Name+,SubscriberPackageVersion.BuildNumber+,SubscriberPackageVersion.Id+,SubscriberPackageVersion.MajorVersion+,SubscriberPackageVersion.MinorVersion+,SubscriberPackageVersion.PatchVersion+FROM+InstalledSubscriberPackage';
        //string query='SELECT+Id+FROM+InstalledSubscriberPackage';
        request.setEndpoint(SFdomainUrl+'/services/data/v48.0/tooling/query/?q='+query);
        
        request.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(request);
        //system.debug(response.getBody());
        
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        
        List<Object> records = (List<Object>) results.get('records');
        system.debug('Records:' + records);
        List<SFDXPackage> SFDXPackages = new List<SFDXPackage>();

        for(Object thisRecord: records){
            SFDXPackage newSFDXPackage = new SFDXPackage();
            Map<String, Object> ThisPackage = (Map<String, Object>) thisRecord;
            Map<String, Object> ThisSubscriberPackage = (Map<String, Object>) ThisPackage.get('SubscriberPackage');
            Map<String, Object> ThisSubscriberPackageVersion = (Map<String, Object>) ThisPackage.get('SubscriberPackageVersion');

            newSFDXPackage.PackageId = (String)ThisPackage.get('Id');
            newSFDXPackage.SubscriberPackageVersionId = (String)ThisPackage.get('SubscriberPackageVersionId');
            newSFDXPackage.SubscriberPackageId = (String)ThisPackage.get('SubscriberPackageId');
            newSFDXPackage.SubscriberPackageName = (String)ThisSubscriberPackage.get('Name');               
            
            system.debug('Record:' + thisRecord);
            system.debug('PackageId = ' + newSFDXPackage.PackageId); 
            system.debug('PackageName = ' + newSFDXPackage.SubscriberPackageName); 
            system.debug('SubscriberPackageVersionId = ' + newSFDXPackage.SubscriberPackageVersionId); 
            system.debug('SubscriberPackageId = ' + newSFDXPackage.SubscriberPackageId); 
            
            SFDXPackages.add(newSFDXPackage);
        }          
        
        System.debug(records);
        

        return SFDXPackages;

    }

}