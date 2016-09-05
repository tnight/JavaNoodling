/*
 * See http://www.blackdown.org/java-linux/faq/FAQ-java-linux.html
 * for more information.
 *
 * $Id: HelloNativeWorld.cpp,v 1.1.1.1 2003/03/03 22:34:04 terryn Exp $
 */

#include <iostream>
#include "helloworld.h"

JNIEXPORT void JNICALL
Java_example_HelloNativeWorldCPP_print(JNIEnv *env, jobject obj) 
{
    cout << "Hello World!" << endl;
}
