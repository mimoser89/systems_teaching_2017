uint64_t x;

uint64_t main() {

  x = 0;

  thread();
  lock();
  x = x + 1;
  unlock();

  return x;

}
