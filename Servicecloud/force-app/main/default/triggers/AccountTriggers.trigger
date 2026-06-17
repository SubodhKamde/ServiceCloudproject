trigger AccountTriggers on Account (before insert, before update, after insert, after update) {
    
    // Before triggers
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            AccountHandler.beforeInsert(Trigger.new);
        }
        if(Trigger.isUpdate) {
            AccountHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
    
    // After triggers
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            AccountHandler.afterInsert(Trigger.new);
        }
        if(Trigger.isUpdate) {
            AccountHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}