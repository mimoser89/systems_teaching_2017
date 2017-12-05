uint64_t x;
uint64_t pid;
uint64_t pid1;

uint64_t main() {


  pid = fork();
  if(pid == 0) {
    thread();
    thread();
  }
  else {
    pid1 = fork();
    if(pid1 == 0) {
      lock();
      while(1) {}
      unlock();
    }
    else {
      wait(kill(3));
    }
  }


  x = 0;


  return x;

}
