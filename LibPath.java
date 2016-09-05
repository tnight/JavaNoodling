public class LibPath {
    public static void main(String[] args) {
        String libPath = java.lang.System.getProperty("java.library.path");
        System.out.println("Library path = [" + libPath + "]");
    }
}
