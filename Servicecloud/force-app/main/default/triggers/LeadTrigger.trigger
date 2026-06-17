trigger LeadTrigger on Lead (before update) {
    
    if(Trigger.isupdate && Trigger.isbefore){
        
        for(Lead l : Trigger.NEW){
            l.Status = 'Working-Contacted';
        }
        
    }

}