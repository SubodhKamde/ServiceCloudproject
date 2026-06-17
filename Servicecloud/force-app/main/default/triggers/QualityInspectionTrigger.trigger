trigger QualityInspectionTrigger on Quality_Inspection__c (after insert, after update) {
    if (Trigger.isAfter) {
        // 1️⃣ Update Supplier Ratings
        if (Trigger.isInsert || Trigger.isUpdate) {
            QualityInspectionHandler.updateSupplierRating(Trigger.new);
        }

        // 2️⃣ Identify Failed Inspections (for email alerts)
        Set<Id> failedIds = new Set<Id>();
        for (Quality_Inspection__c qi : Trigger.new) {
            // ensure the record exists and meets failure conditions
            if (qi != null && qi.Status__c == 'Fail' && qi.Defect_Rate__c != null && qi.Defect_Rate__c > 5) {
                failedIds.add(qi.Id);
            }
        }

        // 3️⃣ Send Email Alerts for Failed Inspections
        if (!failedIds.isEmpty()) {
            QualityInspectionHandler.sendAlertForFailures(new List<Id>(failedIds));
        }
    }
}