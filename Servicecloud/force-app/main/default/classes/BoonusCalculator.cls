public class BoonusCalculator {
    
    public static Integer Bonuss(String type){
        
        Integer ans;
        
        if(type == 'Regular'){
            
            ans=25000;

        }
        else if(type == 'Manager'){
            ans=30000;
        }
        else if(type =='Regional Head'){
            ans = 35000;
        }
        else if(type == 'SVP'){

			ans= 40000;            
        }
        else if(type == 'VP'){
            ans=50000;
        }
        else{
            
            ans=750000;

        }
        
        return ans;
        
    }

}