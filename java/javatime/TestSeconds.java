import java.lang.System;

public class TestSeconds {
    public static void main(String[] args) {
        int toggle = (int) ( (System.currentTimeMillis() / 1000) % 2 );
        System.out.println("Value of toggle is: " + toggle);
    }
}
