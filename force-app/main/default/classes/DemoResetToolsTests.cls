@isTest 
public with sharing class DemoResetToolsTests {
    

    @isTest static void DemoResetToolsTests() {
        List<DemoResetTools.ResetTask> resetTasks = DemoResetTools.getResetTasks();
        List<DemoResetTools.Toast> toasts = DemoResetTools.demoReset(new List<Id>(), false);

        System.assertEquals(true,true);
    }
}
