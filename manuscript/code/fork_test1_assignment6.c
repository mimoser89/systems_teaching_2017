uint64_t main() {
  uint64_t firstPID;
  uint64_t temp;

  firstPID = fork();


  if (firstPID == 0) {
    while (1) {
      // first child -> infinite loop
    }
  } else {
    if (fork() == 0)
      return 8;                 // second child -> zombie at this point
    else {
      
      kill((wait() - 1)); // kill infinite loop child -> zombie and delete second child
      return wait()-firstPID;  // deletes first child and returns its pid
    }
  }

  return 42;
}
