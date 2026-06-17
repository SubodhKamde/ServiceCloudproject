@isTest
private class testclassapi {
    @isTest static void testGetSuppliers() {
        // create sample supplier
        insert new Supplier__c(Name='API Test', Supplier_Code__c='API001', Status__c='Active');
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/api/suppliers/';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        SupplierAPI.doGet();
        Test.stopTest();
        System.assertEquals(200, RestContext.response.statusCode);
    }

    @isTest static void testCreateSupplier() {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/api/suppliers/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(new Map<String,String>{'name'=>'API Create','code'=>'APIC01','category'=>'Components'}));
        RestContext.request = req;
        RestContext.response = res;
        SupplierAPI.doPost();
        Test.stopTest();
        System.assertEquals(201, RestContext.response.statusCode);
    }
}