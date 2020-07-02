public with sharing class VersionHelper {
    
    public String getCurrentVersion(){
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
                if(fieldName.contains('Demo Reset Tools Unlocked@')){
                    latestVersion = fieldName;
                }
            }
            System.debug('Latest Version of "Demo Reset Tools Unlocked" is: ' + latestVersion + ' (' + packages.get(latestVersion) + ')');
        }
        return latestVersion; 
    }

    public String getInstalledVersion(){

        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        request.setHeader('Content-Type', 'application/json');
        String SFdomainUrl=URL.getSalesforceBaseUrl().toExternalForm();
        String query='SELECT+Id+,SubscriberPackageId+,SubscriberPackageVersionId+,SubscriberPackage.Name+FROM+InstalledSubscriberPackage';
        //string query='SELECT+Id+FROM+InstalledSubscriberPackage';
        request.setEndpoint(SFdomainUrl+'/services/data/v48.0/tooling/query/?q='+query);
        
        request.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(request);
        //system.debug(response.getBody());
        
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        
        List<Object> records = (List<Object>) results.get('records');
        system.debug('Records:' + records);
        for(Object thisRecord: records){
            SFDXPackage newPackage = new SFDXPackage();
            Map<String, Object> SFDXPackage = (Map<String, Object>) thisRecord;
            Map<String, Object> SFDXSubscriberPackage = (Map<String, Object>) SFDXPackage.get('SubscriberPackage');

            newPackage.PackageId = (String)SFDXPackage.get('Id');
            newPackage.SubscriberPackageVersionId = (String)SFDXPackage.get('SubscriberPackageVersionId');
            newPackage.SubscriberPackageId = (String)SFDXPackage.get('SubscriberPackageId');
            newPackage.SubscriberPackageId = (String)SFDXPackage.get('SubscriberPackageId');
            newPackage.SubscriberPackageName = (String)SFDXSubscriberPackage.get('Name');               
            
            system.debug('Record:' + thisRecord);
            system.debug('PackageId = ' + newPackage.PackageId); 
            system.debug('PackageName = ' + newPackage.SubscriberPackageName); 
            system.debug('SubscriberPackageVersionId = ' + newPackage.SubscriberPackageVersionId); 
            system.debug('SubscriberPackageId = ' + newPackage.SubscriberPackageId); 
        
        }          
        
        System.debug(records);
        

        return '';

    }

}