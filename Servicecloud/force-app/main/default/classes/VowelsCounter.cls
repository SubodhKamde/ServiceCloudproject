public class VowelsCounter {
    
    public static List<Integer> ans = new List<Integer>();

    public static Integer Vowel(String b) {
        Integer ans = 0;
        Integer k = b.length();

        for (Integer i = 0; i < k; i++) {
            String ch = b.substring(i, i + 1); // Correct way to extract character as string

            if (
                ch.equalsIgnoreCase('a') ||
                ch.equalsIgnoreCase('e') ||
                ch.equalsIgnoreCase('i') ||
                ch.equalsIgnoreCase('o') ||
                ch.equalsIgnoreCase('u')
            ) {
                ans++;
            } 
        }

        return ans;
    }

    public static List<Integer> Counter(List<String> a) {
        ans.clear();
        for (Integer i = 0; i < a.size(); i++) {
            ans.add(Vowel(a.get(i)));
        }
        return ans;
    }
    
    public static void retreive() {
        System.debug(ans);
    }
}