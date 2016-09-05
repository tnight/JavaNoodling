#include <string>

class HelloPrinter {
 public:
  HelloPrinter();
  string getHello();
  ~HelloPrinter();

 private:
  string msg;
  int count;
};
