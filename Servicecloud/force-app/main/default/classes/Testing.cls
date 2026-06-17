public class Testing {
    
    Integer Runs;
    String Name;
    Decimal Average;
    Decimal StrikeRate;
    
    Static Integer maxUsersAllowed=50;
    Static Date currentDate = System.today();
    
    
    Static List<String>Colors = new List<String>{'Orange','Black','Red'};
        
        
    
    Public Testing(Integer Runs, String Name){
        this.Runs=Runs;
        this.Name=Name;
    }
    Public Testing(Integer Runs, String Name, Decimal Average, Decimal StrikeRate){
        this.Runs = Runs;
        this.Name = Name;
        this.Average = Average;
        this.StrikeRate = StrikeRate;
    }
    
    public Static Decimal OverallScore(Integer Age){
        
        Testing t = new Testing(80,'Virat', 57.90, 98.35);
        
        Integer OverallAge = Age;
        
        Decimal OverallScore = t.Runs + (t.Average * t.StrikeRate) - OverallAge;
        
        return OverallScore;
        
        
    }
    

}