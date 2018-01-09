uint64_t* value;

uint64_t main() {


  value = malloc(64);
  *value = 42;

  thread();

  //BEGIN first case
  //this case prevents from race conditions
  while(compare_and_swap(value, 42, 1) == 1) {
    return 100;
  }
  //END first case

  //BEGIN second case
  //if i test it with this code with the x-Mipster (timeout = 1) i get as result four times 100,
  //which should not be the case, because the second thread should not enter this section because the value is set to 1.
  //if timeout is set to timeslice then it would work properly. so this case can cause race conditions.
  //while(*value == 42) {
    //*value = 1;
    //return 100;
  //}
  //END second case

  return 0;
}
