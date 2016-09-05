# 
# 
# See http://www.blackdown.org/java-linux/faq/FAQ-java-linux.html
# for more information.
#
# $Id: Makefile,v 1.1.1.1 2003/03/03 22:34:04 terryn Exp $
#

### JAVA_HOME=/usr/local/java/jdk
# this is can be overriden on the command line, e.g. 
# 'make JAVA_HOME=/home/kreilede/local/jdk1.2.2'

# The java tools:
JAVAC=$(JAVA_HOME)/bin/javac
JAVA=$(JAVA_HOME)/bin/java
JAVAH=$(JAVA_HOME)/bin/javah

INCLUDES=-I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux

# The recommended c compiler flags
CFLAGS=-D_REENTRANT -D_GNU_SOURCE

# The java source code
JAVA_SRC = example/HelloNativeWorldCPP.java
# The java class files
JAVA_CLASSES = $(JAVA_SRC:%.java=%.class)

all: libhello.so run

libhello.so: helloworld.o
	$(CXX) -shared -o $@ $?

helloworld.o: HelloNativeWorld.cpp helloworld.h 
	$(CXX) $(CFLAGS) $(INCLUDES) -c -o $@ $<

helloworld.h: example/HelloNativeWorldCPP.class
	$(JAVAH) -jni -o $@ example.HelloNativeWorldCPP

run:
	LD_LIBRARY_PATH=. $(JAVA) example.HelloNativeWorldCPP
# For 1.2.2 the recommened way is:
# $(JAVA) -Djava.library.path=. example.HelloNativeWorldCPP

example/%.class: example/%.java
	${JAVA_HOME}/bin/javac $<

clean:
	$(RM) example/*.class example/*~ core *.o *.so *~ *.h
