uint64_t x;

uint64_t main() {

  x = 0;

  thread();
  thread();

  x = x + 1;

  return x;

}
