uint64_t x = 0;
uint64_t* memory;
uint64_t pid;
uint64_t* foo;

uint64_t main() {

 foo = "Hello World!    ";
 thread();

 x = x + 1;
 if (x == 1) {       // first thread
    lock();
     
     memory = malloc(1000);
     *(memory + 8) = -1;
     *(memory + 888) = 42;
     unlock();

   thread();
   thread();
   while (*(memory + 8) == -1) {
     x = 8;          // this should not change the value of x below
   }

   if (kill(fork()) != 0)
     return wait();  // should return 0 (no child)

   wait();           // waits for killed child process

 } else {            // second thread
   lock();
   unlock();

   pid = fork();     // pid of first child
   if (pid == 0) {   // child of second thread
     return wait();  // should not wait here -> this context does not have children
   } else {          // second thread

     x = 0;
     thread();

     x = x + 1;
     if (x == 1)
       return *(memory + 888);
     else
       *(memory + 8) = x;    // frees infinite loop

     return 77;
   }
 }

 if (kill(fork()) != 0)
   return wait();

 return wait() - 5 == pid;
}
