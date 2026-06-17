public with sharing class QualityInspectionHandler {

    // -------------------
    // 1️⃣ Update Supplier Ratings
    // -------------------
    public static void updateSupplierRating(List<Quality_Inspection__c> inspections) {
        if (inspections == null || inspections.isEmpty()) return;

        Set<Id> supplierIds = new Set<Id>();
        for (Quality_Inspection__c qi : inspections) {
            if (qi.Supplier__c != null) {
                supplierIds.add(qi.Supplier__c);
            }
        }

        if (supplierIds.isEmpty()) return;
        calculateAndUpdateQualityRating(supplierIds);
    }

    private static void calculateAndUpdateQualityRating(Set<Id> supplierIds) {
        List<Supplier__c> suppliersToUpdate = new List<Supplier__c>();

        for (Id suppId : supplierIds) {
            List<Quality_Inspection__c> inspections = [
                SELECT Defect_Rate__c, Inspection_Date__c
                FROM Quality_Inspection__c
                WHERE Supplier__c = :suppId
                  AND Defect_Rate__c != null
                ORDER BY Inspection_Date__c DESC
                LIMIT 10
            ];

            if (inspections.isEmpty()) continue;

            Decimal totalDefectRate = 0;
            Integer count = 0;

            for (Quality_Inspection__c qi : inspections) {
                if (qi.Defect_Rate__c != null) {
                    totalDefectRate += qi.Defect_Rate__c;
                    count++;
                }
            }

            if (count == 0) continue;

            Decimal avgDefectRate = totalDefectRate / count;
            Decimal qualityRating = 100 - avgDefectRate;
            qualityRating = Math.max(0, Math.min(100, qualityRating)); // Clamp between 0–100

            suppliersToUpdate.add(new Supplier__c(
                Id = suppId,
                Quality_Rating__c = qualityRating.setScale(2)
            ));
        }

        if (!suppliersToUpdate.isEmpty()) {
            try {
                update suppliersToUpdate;
            } catch (DmlException e) {
                System.debug('Error updating supplier ratings: ' + e.getMessage());
            }
        }
    }

    // -------------------
    // 2️⃣ Send Failure Alerts
    // -------------------
    @InvocableMethod(label='Send Failure Alerts')
    public static void sendAlertForFailures(List<Id> inspectionIds) {
        if (inspectionIds == null || inspectionIds.isEmpty()) return;

        List<Quality_Inspection__c> inspections = [
            SELECT Id, Name, Supplier__c, Defect_Rate__c, Status__c
            FROM Quality_Inspection__c
            WHERE Id IN :inspectionIds
        ];

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Quality_Inspection__c qi : inspections) {
            if (qi.Status__c == 'Fail' && qi.Defect_Rate__c != null && qi.Defect_Rate__c > 5) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                // 👇 Replace with your actual email (or dynamic supplier contact if available)
                mail.setToAddresses(new String[]{'subodhkamde12@gmail.com'});

                mail.setSubject('⚠️ Quality Alert: Inspection ' + (qi.Name != null ? qi.Name : qi.Id));
                mail.setPlainTextBody(
                    'Inspection ' + (qi.Name != null ? qi.Name : qi.Id) + 
                    ' failed with a defect rate of ' + qi.Defect_Rate__c + '%.\n' +
                    'Supplier Id: ' + qi.Supplier__c +
                    '\n\nPlease review immediately.'
                );

                emails.add(mail);
            }
        }

        if (!emails.isEmpty()) {
            try {
                Messaging.sendEmail(emails);
            } catch (Exception e) {
                System.debug('Error sending email alerts: ' + e.getMessage());
            }
        }
    }
}