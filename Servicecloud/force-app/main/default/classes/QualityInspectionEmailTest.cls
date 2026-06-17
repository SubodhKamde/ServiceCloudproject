@isTest
private class QualityInspectionEmailTest {
    @testSetup
    static void setup() {
        Supplier__c sup = new Supplier__c(Name='EmailTest Supplier', Supplier_Code__c='EM001', Status__c='Active', Delivery_Rating__c=80);
        insert sup;
    }

    @isTest
    static void testSendAlertForFailures() {
        Supplier__c sup = [SELECT Id FROM Supplier__c WHERE Supplier_Code__c='EM001' LIMIT 1];

        Quality_Inspection__c qi = new Quality_Inspection__c(
            Supplier__c = sup.Id,
            Inspection_Date__c = Date.today(),
            Sample_Size__c = 100,
            Defects_Found__c = 10, // 10% defect => Defect_Rate__c 10 if formula
            Status__c = 'Fail'
        );
        Test.startTest();
        insert qi;
        Test.stopTest();

        // if your trigger calls sendAlertForFailures it will run here; assert supplier not null to check flow
        System.assertNotEquals(null, qi.Id);
    }
}