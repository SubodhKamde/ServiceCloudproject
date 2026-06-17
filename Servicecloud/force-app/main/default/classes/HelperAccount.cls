public class HelperAccount {
    
    
    public static void helper(List<Account>r,Map<ID,Account>b){
        
        for(Account a : r){
            
            if(a.Industry == 'Agriculture' && a.type == 'Appareal'){
                
                if((b.get(a.Id).Ownership != a.Ownership) && a.Ownership =='Private'){
                    a.addError('this is not permitted');
                }
                
                
                
            }
        }
        
    }

}