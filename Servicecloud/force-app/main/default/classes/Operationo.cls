public class Operationo {
    
  

    public static void createAccounts() {
        List<Account> a = new List<Account>();

        Account a1 = new Account();
        a1.Name = 'Naval';

        Account a2 = new Account();
        a2.Name = 'Ravikant';

        a.add(a1);
        a.add(a2);

        Database.insert(a,false);
    }
    
    public Static void upp(String status){
        
        List<Case>c= new List<Case>();
        
        List<Case>s = [Select id  From Case WHERE Status =:'status'];
        
        for(Case r : s){
            
            r.Status = 'Closed';
            c.add(r);
        }
        
        Database.update(c,false);
        
        
        
    }


    
    
    
}