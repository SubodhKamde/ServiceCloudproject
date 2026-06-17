public class KheckAttendance {
      
    public static Integer Active(List<Integer>a) {
        Integer ans = 0;
        for(Integer i = 0; i < a.size(); i++) {
            if(a[i] == 1) {
                ans++;
            }
        }
        return ans;
    }
    
    
}