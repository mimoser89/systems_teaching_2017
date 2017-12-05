void print(uint64_t* string);
uint64_t* smalloc(uint64_t size);

uint64_t start;

uint64_t main() {
  uint64_t pid;
  uint64_t* shared;

  initLibrary();

  pid = fork();

  if (pid == 0) {
    start = 100;

  } else if (pid > 0) {
    start = 0;

  } else {
    return -1;
  }

  shared = smalloc(8);

  thread();
  thread();

  lock();
unlock();

  *shared = start;

  shared = smalloc(8);

  if (pid == 0) {
    *shared = *(shared - 1) + start - 1;
      start = start - 10;

  } else if (pid > 0) {
    *shared = *(shared - 1)  + start + 1;
    start = start + 10;

  } else {
    return -1;
  }

  return *shared;
}
