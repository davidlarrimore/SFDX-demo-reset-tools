//  Controller for the DemoResetTools Lightning component.
//  
//  This code is provided AS IS, with no warranty or guarantee of suitability for use.
//  Contact: john.meyer@salesforce.com


public without sharing class DemoResetTools {
    
    public class Toast {
        @AuraEnabled public String toastMessage;
        @AuraEnabled public String toastVariant;
        @AuraEnabled public String toastMode;
    }
    
    public class ResetTask {
        @AuraEnabled public Id itemId;
        @AuraEnabled public String itemDescription;
        @AuraEnabled public String itemLink;
        @AuraEnabled public Integer itemCount;
        @AuraEnabled public Boolean itemQueryError;
    }
    
    
    @AuraEnabled
    public static List<ResetTask> getResetTasks () {
        
        List<Demo_Reset_Task__c> demoResetTasks = [SELECT Description__c, Object_API_Name__c, SOQL_WHERE_Clause__c FROM Demo_Reset_Task__c WHERE Active__c = true ORDER BY Name ASC];
        
        if (demoResetTasks.IsEmpty())
            return null;
        else {
            List<ResetTask> resetTasks = new List<ResetTask>();
            for (Demo_Reset_Task__c resetItem : demoResetTasks) {
                ResetTask item = new ResetTask();
                item.itemId = resetItem.Id;
                item.itemLink = '/lightning/r/' + resetItem.Id + '/view';
                item.itemDescription = resetItem.Description__c;
                try {
                    String queryString = 'SELECT count() FROM ' + resetItem.Object_API_Name__c;
                    if (resetItem.SOQL_WHERE_Clause__c != null)
                        queryString += ' WHERE ' + resetItem.SOQL_WHERE_Clause__c;
                    item.itemCount = Database.countQuery(queryString);
                    item.itemQueryError = false;
                } catch (QueryException e) {
                    item.itemCount = 0;
                    item.itemQueryError = true;
                }
                resetTasks.add(item);
            }
            return resetTasks;
        }        
    }    
    
    
    //  Resets the demo by deleting superfluous records created during previous demo runs.
    
    @AuraEnabled
    public static List<Toast> demoReset (List<Id> taskItems, Boolean runApex) {
        
        List<Toast> toasts = new List<Toast>();
        
        if (!taskItems.IsEmpty()) {
            List<Demo_Reset_Task__c> demoResetTasks = [SELECT Object_API_Name__c, SOQL_WHERE_Clause__c FROM Demo_Reset_Task__c WHERE Id IN :taskItems AND Active__c = true ORDER BY Name ASC];           
            if (demoResetTasks.IsEmpty()) {
                Toast toast = new Toast();
                toast.toastMessage = 'No demo reset items were found.';
                toast.toastVariant = 'error';
                toast.toastMode = 'dismissable';
                toasts.add(toast);
            } else
                for (Demo_Reset_Task__c item : demoResetTasks)
                    toasts.add(deleteRecords(item.Object_API_Name__c, item.SOQL_WHERE_Clause__c));
        }
        if (runApex)
            toasts.addAll(DemoResetCustomApex.runCustomApex());
        
        return toasts;
    }
    
    
    //  Delete the records of the given object using the given criteria.
    //  
    //  The parameters represent:
    //  	sObjectName: the API name of the object whose records are to be deleted.
    //  	whereClause: the WHERE clause to use in the SOQL query to identify the records to be deleted.
    
    private static Toast deleteRecords (String sObjectAPIName, String whereClause) {
        
        Toast toast = new Toast();        
        List<sObject> records;
        String sObjectLabel = Schema.getGlobalDescribe().get(sObjectAPIName).getDescribe().getLabel().toLowerCase();
        
        String queryString = 'SELECT Id FROM ' + sObjectAPIName;				//  Build out the query string
        if (whereClause != null)
            queryString += ' WHERE ' + whereClause;
        
        //  Execute the query to locate the records identified.  This should be no problem since we checked this
        //  when we first refreshed the component in getResetTasks().
        
        try {
            records = Database.query(queryString);
        } catch (QueryException e) {
            toast.toastMessage = 'Could not query ' + sObjectLabel + ' records. See the system log for details.';
            toast.toastVariant = 'error';
            toast.toastMode = 'sticky';
            System.debug('Query "' + queryString + '" failed: ' + e.getMessage());
            return toast;
        }
        
        //  If we found records satisfying the criteria, go ahead and delete them.
        
        if (records.IsEmpty()) {
            toast.toastMessage = 'No ' + sObjectLabel + ' records need to be deleted.';
            toast.toastVariant = 'info';
            toast.toastMode = 'sticky';
        } else
            try {
                delete records;
                toast.toastMessage = records.size() + ' ' + sObjectLabel + '(s) were deleted.';
                toast.toastVariant = 'success';
                toast.toastMode = 'sticky';
            } catch (DMLException e) {
                toast.toastMessage = 'Could not delete ' + records.size() + ' ' + sObjectLabel + ' record(s). Check the system debug log for details.';
                toast.toastVariant = 'error';
                toast.toastMode = 'sticky';
                System.debug('Could not delete ' + records.size() + ' ' + sObjectLabel + ' record(s): ' + e.getMessage());
            }
        
        return toast;
    }    
}