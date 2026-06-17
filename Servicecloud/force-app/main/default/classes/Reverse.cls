public with sharing class Reverse {
    

    Public Static String Reversing(String word){

        string ans = '';

        for(Integer i=word.length()-1; i>=0;i--){
            ans+=word.substring(i,i+1);
        }

        return ans;
    }
}