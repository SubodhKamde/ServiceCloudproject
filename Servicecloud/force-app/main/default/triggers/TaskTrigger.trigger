trigger TaskTrigger on Task (before insert) {
    
    if(Trigger.isInsert && Trigger.isBefore){
        
        for(task t : Trigger.New){
            System.debug('Found the record');
            
            t.Priority = 'High';
        }
        
         

    }
    
    
    

}