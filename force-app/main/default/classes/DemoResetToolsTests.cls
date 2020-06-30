@isTest 
public with sharing class DemoResetToolsTests {
    

    @isTest static void DemoResetToolsTests() {

        List<DemoResetTools.ResetTask> resetTasks = DemoResetTools.getResetTasks();
        System.assertEquals(null, resetTasks);

        List<DemoResetTools.Toast> toasts = DemoResetTools.demoReset(new List<Id>(), false);
        System.assertEquals(0, toasts.size());

        Demo_Reset_Task__c newResetTask = new Demo_Reset_Task__c();
        newResetTask.Active__c = true;
        newResetTask.Description__c = 'Delete all but Test User';
        newResetTask.Object_API_Name__c = 'Contact';
        newResetTask.SOQL_WHERE_Clause__c = 'FirstName = \'David\'';
        insert newResetTask;

        Contact newContact = new Contact();
        newContact.FirstName = 'John';
        newContact.LastName = 'Smith';
        newContact.Email = 'john.Smith.demo@mailinator.com';
        newContact.Phone = '5555555555';
        newContact.Title = 'Developer';      
        insert newContact;

        List<Id> badIdList = new List<Id>();
        badIdList.add(newContact.id);
        toasts = DemoResetTools.demoReset(badIdList, false);
        System.assertEquals(1, toasts.size());

        List<Id> idList = new List<Id>();
        idList.add(newResetTask.id);


        newContact = new Contact();
        newContact.FirstName = 'David';
        newContact.LastName = 'Smith';
        newContact.Email = 'David.Smith.demo@mailinator.com';
        newContact.Phone = '5555555555';
        newContact.Title = 'Developer';      
        insert newContact;

        resetTasks = DemoResetTools.getResetTasks();
        toasts = DemoResetTools.demoReset(idList, true);
        


        System.assertEquals(1, resetTasks.size());
        System.assertEquals(2, toasts.size());
    }



    @isTest static void DemoResetToolsDeleteTests() {

        Demo_Reset_Task__c newResetTask = new Demo_Reset_Task__c();
        
        newResetTask.Active__c = true;
        newResetTask.Description__c = 'Delete all but Test User';
        newResetTask.Object_API_Name__c = 'Contact';
        newResetTask.SOQL_WHERE_Clause__c = 'First_Name__c = \'David\'';

        insert newResetTask;
        
        List<Id> idList = new List<Id>();
        idList.add(newResetTask.id);

        List<DemoResetTools.Toast> toasts = DemoResetTools.demoReset(idList, true);
        
        Contact newContact = new Contact();
        
        newContact.FirstName = 'David';
        newContact.LastName = 'Smith';
        newContact.Email = 'david.larrimore.demo@mailinator.com';
        newContact.Phone = '5555555555';
        newContact.Title = 'Developer';      

        insert newContact;

        System.assertEquals(2, toasts.size());
    }    
}
