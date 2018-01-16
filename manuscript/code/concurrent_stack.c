//Treiber stack
//Michael Moser, 01521295

void initLibrary();
void printInteger(uint64_t n);
void println();
void print(uint64_t* s);

//declare new procedures for Treiber stack
void push(uint64_t item);
uint64_t pop(uint64_t* value);

//global stack pointer
uint64_t* top_global_stack_pointer;

//procedure which pushes an element on the stack
void push(uint64_t item) {

  uint64_t* newHead;
  uint64_t* oldHead;

  uint64_t doWhileHelper;

  //creates new head of the stack
  newHead =  malloc(16);
  *(newHead + 1) = item;

  //this is for creating a do-While loop
  doWhileHelper = 1;

  while(doWhileHelper) {
    //gets the actual top pointer of the stack
    oldHead = (uint64_t*) *top_global_stack_pointer;
    //sets the new Head of the stack
    *newHead = (uint64_t) oldHead;

    //sets the new top pointer of the stack, with compare and swap
    if(compare_and_swap(top_global_stack_pointer, (uint64_t) oldHead, (uint64_t) newHead))
      doWhileHelper = 0;

  }
}

//procedure which pops an element from the stack
//return 1 if success, 0 otherwise
uint64_t pop(uint64_t* value) {

  uint64_t* oldHead;
  uint64_t* newHead;
  uint64_t doWhileHelper;

  //this is for creating a do-While loop
  doWhileHelper = 1;

  while(doWhileHelper) {
    //gets the actual top pointer of the stack
    oldHead = (uint64_t*) *top_global_stack_pointer;
      //returns 0 if the stack is empty
      if(oldHead == (uint64_t*) 0) {
        return 0;
      }

    //sets to new Head of stack
    newHead = (uint64_t*) *oldHead;

    //sets the new top pointer of the stack, with compare and swap
    if(compare_and_swap(top_global_stack_pointer, (uint64_t) oldHead, (uint64_t) newHead)) {
      doWhileHelper = 0;
      *value = *(oldHead + 1);
    }
  }
  return 1;
}

uint64_t sum;

//this is a test procedure which increments a sum and decrements it,
//depending on values on the stack;
//so the last thread should return 0
uint64_t main() {

  uint64_t* value;
  uint64_t i;

  sum = 0;
  i = 0;

  initLibrary();

  top_global_stack_pointer = malloc(8);
  value = malloc(8);

  while(i < 5) {
    thread();
    i = i + 1;
  }

  lock();
  sum = sum + 10;
  unlock();

  push(10);

  pop(value);

  lock();
  sum = sum - *value;
  unlock();

  //should return 0 when the last thread ends
  return sum;
}
