/*
 * See http://www.blackdown.org/java-linux/faq/FAQ-java-linux.html
 * for more information.
 *
 * $Id: HelloNativeWorldCPP.java,v 1.1.1.1 2003/03/03 22:34:04 terryn Exp $
 */

package example;

public class HelloNativeWorldCPP 
{
    static {
    	System.loadLibrary("hello");
    }
    
    private native void print();

    public static void main(String[] args) 
    {
	new HelloNativeWorldCPP().print();
    }
}
