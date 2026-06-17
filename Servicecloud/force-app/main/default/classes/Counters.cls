public class Counters {
    
    public Static Integer Count(List<String>s){
        
        Integer ans=0;
        
        for(String a : s){
            
            
            if(a=='Makes Sense'){
                ans++;
            }
        }
        
        return ans;
    }

}