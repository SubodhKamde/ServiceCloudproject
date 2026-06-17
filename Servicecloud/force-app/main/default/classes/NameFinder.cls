public with sharing class NameFinder {
    public static String findName(String email) {
        Integer n = email.length();
        String ans = '';

        for (Integer i = 0; i < n; i++) {
            if (email.substring(i, i+1) != '@') {
                ans += email.substring(i, i+1);
            } else {
                break;
            }
        }

        ans = ans.replace('_', '');
        return ans;
    }
}