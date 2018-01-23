// global variable for pointing to the "Hello World!    " string
uint64_t* foo;
uint64_t unixPID;

uint64_t main() {

  // point to the "Hello World!    " string
  foo = "Hello World!    ";
  unixPID = fork();
  // as long as there are characters print them
  lock();
  while (*foo != 0) {
    // 1 means that we print to the console
    // foo points to a chunk of 8 characters
    // 8 means that we print 8 characters
    write(1, foo, 8);
    // go to the next chunk of 8 characters
    foo = foo + 1;
  }
  unlock();

  return unixPID;
}
