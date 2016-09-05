#include <stdlib.h>
#include "Hello.h"
#include "HelloPrinter.h"

extern "C" {
JNIEXPORT jint JNICALL Java_Hello_constructHello
  (JNIEnv *env, jobject thisObj)
{
  HelloPrinter *hp = new HelloPrinter();
  return (jint)hp;
}

JNIEXPORT jstring JNICALL Java_Hello_getHello
  (JNIEnv *env, jobject thisObj, jint ptr)
{
  char buf[100];                // working buffer
  jstring value;                // the return value
  HelloPrinter *hp = (HelloPrinter *)ptr;

  /* Copy our message to our working buffer.
   */
  strcpy(buf, hp->getHello().c_str());

  /* Create a Java-native UTF-8(?) string (java.lang.String) and
   * return that as the fruit of our labors.  
   */
  value = env->NewStringUTF(buf);
  return value;
}

JNIEXPORT void JNICALL Java_Hello_destructHello
  (JNIEnv *env, jobject thisObj, jint ptr)
{
  delete (HelloPrinter *)ptr;
}

}
