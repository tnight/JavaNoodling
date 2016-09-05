public class Hello
{
    /**
     * The program entry point. Call it as: java
     * com.trendwest.terry.Hello with an optional numeric parameter 1
     * or higher for the total number of "Hello World" messages to
     * display.
     */
    public static void main( String args[] )
    {
        int count;
        try {
            if( (count = Integer.parseInt(args[0])) < 1 ) {
                count = 1;
            }
        }
        catch( Exception e ) {
            count = 1;
        }

        // Create a new Hello object (this same class) using the
        // default constructor (see below)
        Hello test = new Hello();
        for( int i=0; i<count; i++ ) {
            System.out.println( "{" + test + "}" );
        }
    }
  
    /**
     * Default constructor: calls the getHello() method which is
     * defined (below) as a native method!
     */
    public Hello()
    {
        super();                // always a good idea to call the
                                // super constructor
        ptr = constructHello(); // initialize the native class
    }

    /**
     * A convenient way of ensuring that the String representation of
     * this object is the Hello message itself. This makes for very
     * easy ways of printing the object's value (see the
     * main(java.lang.String[]) method above)
     */
    public String toString()
    {
        msg = getHello(ptr);    // call the native method
        return msg;
    }

    /**
     * Make sure the C++ class gets destructed to prevent memory
     * leaks.
     */
    protected void finalize()
    {
        destructHello(ptr);
    }

    /**
     * This is the defininition of our native method. NOTICE THAT IT
     * HAS NO BODY. The static block following it is executed as part
     * of the class construction.
     */
    private native int constructHello();
    private native String getHello(int ptr);
    private native void destructHello(int ptr);
    static
    {
        // Load a library whose "core" name is 'java-rlt-uuid'
        // Operating system specific stuff will be added to make from
        // this an actual filename: Under Unix this will become
        // libjava-rlt-hello.so while under Windows it will likely
        // become something like java-rlt-hello.DLL
        System.loadLibrary("Hello");
    }

    // the constructor stores here the result of the native method call
    private int ptr;
    private String msg;
}


