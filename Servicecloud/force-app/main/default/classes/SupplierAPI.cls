@RestResource(urlMapping='/api/suppliers/*')
global with sharing class SupplierAPI {
    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try {
            List<Supplier__c> listSup = [
                SELECT Id, Name, Supplier_Code__c, Quality_Rating__c, Delivery_Rating__c, Overall_Score__c, Risk_Level__c
                FROM Supplier__c
                WHERE Status__c = 'Active'
                LIMIT 50
            ];
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(listSup));
        } catch (Exception e) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(new Map<String,Object>{'success'=>false,'error'=>e.getMessage()}));
        }
    }

    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        try {
            String body = req.requestBody.toString();
            Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(body);
            Supplier__c sup = new Supplier__c();
            if (payload.containsKey('name')) sup.Name = (String) payload.get('name');
            if (payload.containsKey('code')) sup.Supplier_Code__c = (String) payload.get('code');
            if (payload.containsKey('category')) sup.Category__c = (String) payload.get('category');
            sup.Status__c = 'Active';
            insert sup;
            res.statusCode = 201;
            res.responseBody = Blob.valueOf(JSON.serialize(new Map<String,Object>{'success'=>true,'id'=>sup.Id}));
        } catch (DmlException dmle) {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(new Map<String,Object>{'success'=>false,'error'=>dmle.getMessage()}));
        } catch (Exception e) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(new Map<String,Object>{'success'=>false,'error'=>e.getMessage()}));
        }
    }
}