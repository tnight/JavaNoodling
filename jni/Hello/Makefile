# Makefile by Daniel Lydiard for datarequest project
# note remove -g and add -O6 -s for final version

PROJECTS   = Hello


all: ${PROJECTS}

Hello: Hello.cc Hello.exp Hello.java HelloPrinter.h HelloPrinter.cc
	@echo "\n[Creating Java Class Hello]"
	javac Hello.java
	@echo "\n[Creating JNI header file]"
	javah -jni Hello
	@echo "\n[Creating Library Hello]"
	gcc -O6 -I/usr/WebSphere/AppServer/java/include -c Hello.cc HelloPrinter.cc
	ld -H512 -T512 -bhalt:4 -bM:SRE -bnoentry -bI:Hello.exp -o libHello.so Hello.o HelloPrinter.o -L. -lc -lgcc -lstdc++ -lm -bexpall -L/usr/local/lib/gcc-lib/powerpc-ibm-aix4.3.3.0/2.95.2

clean:
	@echo "\n[Cleaning up project...]"
	@rm -f core lib${PROJECTS}.so
	@rm -f *.o *.class
	@rm -f Hello.h

mrproper: clean ${PROJECTS}


# end of file
