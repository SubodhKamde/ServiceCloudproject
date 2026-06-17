@isTest
private class QualityInspectionHandlerTest {

    @testSetup
    static void setupData() {
        Supplier__c sup = new Supplier__c(
            Name = 'Test Supplier',
            Supplier_Code__c = 'TSUP001',
            Status__c = 'Active',
            Quality_Rating__c = 0,
            Delivery_Rating__c = 0,
            Email__c = 'test@supplier.com',     
        Phone__c = '9876543210'             
        );
        insert sup;
    }

    @isTest
    static void testQualityRatingUpdate_singleInsert() {
        Supplier__c sup = [
            SELECT Id FROM Supplier__c 
            WHERE Supplier_Code__c = 'TSUP001' LIMIT 1
        ];

        List<Quality_Inspection__c> insList = new List<Quality_Inspection__c>();
        for (Integer i = 0; i < 5; i++) {
            insList.add(new Quality_Inspection__c(
                Supplier__c = sup.Id,
                Inspection_Date__c = Date.today().addDays(-i),
                Sample_Size__c = 100,
                Defects_Found__c = 5,
                Status__c = 'Pass'
            ));
        }

        Test.startTest();
        insert insList;
        Test.stopTest();

        Supplier__c result = [
            SELECT Quality_Rating__c FROM Supplier__c 
            WHERE Id = :sup.Id LIMIT 1
        ];

        System.assertEquals(95.00, result.Quality_Rating__c.setScale(2));
    }

    @isTest
    static void testQualityRating_updateInspections_changesCalculation() {
        Supplier__c sup = [
            SELECT Id FROM Supplier__c 
            WHERE Supplier_Code__c = 'TSUP001' LIMIT 1
        ];

        List<Quality_Inspection__c> insList = new List<Quality_Inspection__c>();
        for (Integer i = 0; i < 10; i++) {
            Integer defects = 10 + i;
            insList.add(new Quality_Inspection__c(
                Supplier__c = sup.Id,
                Inspection_Date__c = Date.today().addDays(-i),
                Sample_Size__c = 100,
                Defects_Found__c = defects,
                Status__c = 'Pass'
            ));
        }

        Test.startTest();
        insert insList;
        Test.stopTest();

        Supplier__c result = [
            SELECT Quality_Rating__c FROM Supplier__c 
            WHERE Id = :sup.Id LIMIT 1
        ];

        Decimal expected = 100 - 14.5;
        System.assertEquals(expected.setScale(2), result.Quality_Rating__c.setScale(2));
    }
}