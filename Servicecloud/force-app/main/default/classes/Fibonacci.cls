public with sharing class Fibonacci {

    public static List<Integer> Series(Integer n) {
        List<Integer> series = new List<Integer>();
        Integer a = 0, b = 1, c;

        if (n == 0) return series;

        series.add(a);

        if (n == 1) return series;

        series.add(b);

        for (Integer i = 2; i < n; i++) {
            c = a + b;
            series.add(c);
            a = b;
            b = c;
        }

        return series;
    }
}