trigger CaseTriggee on Case (before insert) {
    
    if(Trigger.isinsert && Trigger.isbefore){
        
        
        for(Case c : Trigger.NEW){
            
            if(c.Origin =='Phone'){
                c.priority = 'High';
            }
            else{
                c.priority = 'Low';
            }
        }
    }

}