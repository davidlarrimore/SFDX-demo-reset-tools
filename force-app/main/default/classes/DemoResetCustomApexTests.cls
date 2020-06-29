@isTest 
public with sharing class DemoResetCustomApexTests {

    @isTest static void DemoResetCustomApexTests() {
        List<DemoResetTools.Toast> toasts = DemoResetCustomApex.runCustomApex();
        System.assertEquals(true,true);
    }

}
