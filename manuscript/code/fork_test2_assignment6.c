uint64_t* foo ;

uint64_t main() {
uint64_t pid;
pid = fork();
foo = "hello World!    ";

wait();
while (*foo != 0) {
  write(1, foo, 8);
  foo = foo + 1;
}


if(pid > 0){
kill(pid);
}

return pid;
}
