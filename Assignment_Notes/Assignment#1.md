Changes due to Assignment #1:

procedure:
uint64_t selfie() {
  .
  .
  else if (stringCompare(option, (uint64_t*) "-x"))
    return selfie_run(DOUBLEMIPSTER);
  .
  .
}
changes:
added the -x option

procedure:
uint64_t selfie_run(uint64_t machine) {
  .
  .
    if (machine == MIPSTER)
      exitCode = mipster(currentContext);
    else if (machine == DOUBLEMIPSTER) {
      COUNTER_RUNNING_MIPSTER = 2;

      createContext(MY_CONTEXT,0);

      //make cycle, used context is always the last created context
      setNextContext(currentContext, usedContexts);

      currentContext = getNextContext(currentContext);

      up_loadBinary(currentContext);

      setArgument(binaryName);

      up_loadArguments(currentContext, numberOfRemainingArguments(), remainingArguments());

      exitCode = doubleMipster(currentContext);
    }

  .
  .
}
changes:
if the machine is doubleMipster, then create the same context again and make sure to setNextContext. This is because then you can go with getNextContext from the last do the first. Also set the COUNTER_RUNNING_MIPSTER to 2.

procedure:
uint64_t doubleMipster(uint64_t* toContext) {

  uint64_t timeout;
  uint64_t* fromContext;
  uint64_t tempHandleSystemCall;

  print((uint64_t*) "double_mipster");
  println();

  //debug_switch shows the context change at the console
  debug_switch = 1;

  // only one instruction per context will be executed
  timeout = 1;

  while (1) {
    //first time switches to the self context
    fromContext = mipster_switch(toContext, timeout);

    if (getParent(fromContext) != MY_CONTEXT) {
      // switch to parent which is in charge of handling exceptions
      toContext = getParent(fromContext);

      timeout = TIMEROFF;
    } else {
       // we are the parent in charge of handling exceptions

      if (getException(fromContext) == EXCEPTION_PAGEFAULT){
        // TODO: use this table to unmap and reuse frames
        mapPage(fromContext, getFaultingPage(fromContext), (uint64_t) palloc());
      }

      else {

        tempHandleSystemCall = handleSystemCalls(fromContext);

        //checks if all contexts exited
        if(tempHandleSystemCall == EXIT)
          return getExitCode(fromContext);
        //checks if only one context exited
        else if(tempHandleSystemCall == EXIT_ONE_CONTEXT){
          COUNTER_RUNNING_MIPSTER = COUNTER_RUNNING_MIPSTER - 1;
          //should we print every exit?
          implementExit(fromContext);
        }

      }

      setException(fromContext, EXCEPTION_NOEXCEPTION);

      //set next context
      toContext = getNextContext(fromContext);

      timeout = 1;
    }
  }
}
changes:
added this procedure

procedure:
uint64_t handleSystemCalls(uint64_t* context) {
  .
  .

    else if (v0 == SYSCALL_EXIT) {

      //if there are more then one contexts running
      //return the new variable EXIT_ONE_CONTEXT
      if(COUNTER_RUNNING_MIPSTER > 1) {
        return EXIT_ONE_CONTEXT;
      }
      implementExit(context);

      return EXIT;
    } else {
      print(selfieName);
      print((uint64_t*) ": unknown system call ");
      printInteger(v0);
      println();

      setExitCode(context, EXITCODE_UNKNOWNSYSCALL);

      return EXIT;
    }
  .
  .
}

changes:
checks if there is more then one context running
created a global Variable COUNTER_RUNNING_MIPSTER and EXIT_ONE_CONTEXT to handle this.
