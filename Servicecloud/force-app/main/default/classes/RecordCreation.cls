public class RecordCreation {
    
    
    public static void Creation(String first, String last, String email){
			
        Contact  c = new Contact();
        
        c.firstname = first;
        c.lastname = last;
        
        c.email = email;
        
        
        Database.insert(c);
    
    }

}