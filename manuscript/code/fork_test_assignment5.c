uint64_t a;

uint64_t main() {
 a = 0;
  while(a <= 5) {
    fork();
    a = a + 1;
  }
  return fork();
}
