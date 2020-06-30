@isTest 
public with sharing class DemoResetCustomApexTests {

    @isTest static void DemoResetCustomApexTests() {
        List<DemoResetTools.Toast> toasts = DemoResetCustomApex.runCustomApex();
        Integer v1 = 1;

        System.assertEquals(toasts.size(),v1);

    }

}
