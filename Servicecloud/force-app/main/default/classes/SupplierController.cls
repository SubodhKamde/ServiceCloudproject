public with sharing class SupplierController {
    
    @AuraEnabled(cacheable=true)
    public static List<Supplier__c> getSuppliers() {
        return [
            SELECT Id, Name, Category__c, Quality_Rating__c, 
                   Delivery_Rating__c, Performance_Score__c, Risk_Level__c
            FROM Supplier__c
            WHERE Status__c = 'Active'
            ORDER BY Performance_Score__c DESC
        ];
    }
}