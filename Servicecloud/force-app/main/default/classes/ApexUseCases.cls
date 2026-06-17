public class ApexUseCases{
    
    public static Integer counter = 1;
    
    public static void Easypeezy() {
        
        String ans = '';
        ans = apexUseCases.PasswordChecker('Subodh', 'Piyush');
        System.debug(ans);
        ans = apexUseCases.PasswordChecker('Subodh', 'Piyush');
        System.debug(ans);
        ans = apexUseCases.PasswordChecker('Subodh', 'Piyush');
        System.debug(ans);
        ans = apexUseCases.PasswordChecker('Subodh', 'Piyush');
        System.debug(ans);
        ans = apexUseCases.PasswordChecker('Subodh', 'Subodh');
        System.debug(ans);
        
        
    }
    
    public static string PasswordChecker(String Input, String Actual) {
        if (Input == Actual) {
            return 'Login Successful';
        } else {
            if (counter < 3) {
                counter++;
                return 'Try Again';
            } else {
                return 'limit Exceeded';
            }
        }
    }
}