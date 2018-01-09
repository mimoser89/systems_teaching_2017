# Compiler flags
CFLAGS := -w -O3 -fno-strict-overflow -m64 -D'main(a,b)=main(int argc, char** argv)' -Duint64_t='unsigned long long'

# Compile selfie.c into selfie executable
selfie: selfie.c
	$(CC) $(CFLAGS) $< -o $@

# Consider these targets as targets, not files
.PHONY : test sat all clean

# Test self-compilation, self-execution, and self-hosting
test: selfie
	./selfie -c selfie.c -o selfie1.m -s selfie1.s -m 4 -c selfie.c -o selfie2.m -s selfie2.s
	diff -q selfie1.m selfie2.m
	diff -q selfie1.s selfie2.s
	./selfie -c selfie.c -o selfie.m -m 6 -l selfie.m -m 1
	./selfie -c selfie.c -o selfie3.m -s selfie3.s -m 16 -l selfie3.m -y 8 -l selfie3.m -y 8 -c selfie.c -o selfie4.m -s selfie4.s
	diff -q selfie3.m selfie4.m
	diff -q selfie3.s selfie4.s
	diff -q selfie1.m selfie3.m
	diff -q selfie1.s selfie3.s
	./selfie -c selfie.c -m 4 -c manuscript/code/hello-world.c -x 2
	./selfie -c selfie.c -m 4 -c manuscript/code/hello-world.c -z 2
	./selfie -c manuscript/code/thread.c -m 2 | grep 'exit code 2'
	./selfie -c selfie.c -m 4 -c manuscript/code/thread.c -m 2 | grep 'exit code 2' # exits with exit code 1 and 2
	./selfie -c selfie.c -m 4 -c manuscript/code/thread.c -y 2 | grep 'exit code 2' # exits with exit code 1 and 2
	./selfie -c selfie.c -m 4 -c manuscript/code/thread.c -x 2 | grep 'exit code 1' # exits with exit code 1 1 1 1
	./selfie -c selfie.c -m 4 -c manuscript/code/thread.c -z 2 | grep 'exit code 2' # exits with exit code 2 2 2 2
	./selfie -c manuscript/code/thread_with_lock.c -m 2 | grep 'exit code 2' #bonus, prevent from race conditions with syscall lock
	./selfie -c selfie.c -m 4 -c manuscript/code/thread_with_lock.c -m 2 | grep 'exit code 2' #bonus, prevent from race conditions with syscall lock
	./selfie -c manuscript/code/test_compare_and_swap.c -m 2
	./selfie -c manuscript/code/test_compare_and_swap.c -x 2

test1: selfie
	./selfie -c selfie.c -m 4 -c manuscript/code/fork_test1_assignment6.c -y 2 #should return 8 and 0
test2: selfie
	./selfie -c manuscript/code/fork_test1_assignment6.c -m 2 #the same as one
test3: selfie
	./selfie -c selfie.c -m 16 -c manuscript/code/fork_test1_assignment6.c -z 4 #should not work endless loop
test4: selfie
	./selfie -c selfie.c -x 16 -c manuscript/code/fork_test1_assignment6.c -m 4 #takes too much time with TIMESLICE
test5: selfie
	./selfie -c selfie.c -x 16 -c manuscript/code/fork_test1_assignment6.c -y 4 #works
test6: selfie
	./selfie -c selfie.c -x 16 -c manuscript/code/fork_test1_assignment6.c -x 4 #should not work endless loop
test7: selfie
	./selfie -c manuscript/code/fork_test1_assignment6.c -x 4 #should not work endless loop
test8: selfie
	./selfie -c selfie.c -m 4 -c manuscript/code/fork_test2_assignment6.c -y 2 #works
test9: selfie
	./selfie -c manuscript/code/fork_test2_assignment6.c -m 2 #works
test10: selfie
	./selfie -c manuscript/code/fork_test2_assignment6.c -x 2 #works
test11: selfie
	./selfie -c selfie.c -m 16 -c manuscript/code/fork_test2_assignment6.c -z 4 #works
test12: selfie
	./selfie -c selfie.c -x 16 -c manuscript/code/fork_test2_assignment6.c -m 4 #works
test13: selfie
	./selfie -c selfie.c -x 16 -c manuscript/code/fork_test2_assignment6.c -y 4 #works
test14: selfie
	./selfie -c selfie.c -x 16 -c manuscript/code/fork_test2_assignment6.c -x 4 #works
test15: selfie
	./selfie -c manuscript/code/fork_test2_assignment6.c -x 4 #works
test16: selfie
	./selfie -c selfie.c -m 32 -c manuscript/code/fork_test_assignment5.c -m 4 #works
test17: selfie
	./selfie -c manuscript/code/fork_test_assignment5.c -m 4 #works
test18: selfie
	./selfie -c selfie.c -m 16 -c manuscript/code/fork_test_assignment5.c -y 4 #works
test19: selfie
	./selfie -c selfie.c -m 16 -c manuscript/code/fork_test_assignment5.c -x 8 #works
test20: selfie
	./selfie -c manuscript/code/fork_test_assignment5.c -x 4 #works not
test21: selfie
	./selfie -c selfie.c -m 32 -c manuscript/code/fork_test_assignment5.c -z 8 #works
test22: selfie
	./selfie -c selfie.c -x 16 -c manuscript/code/fork_test_assignment5.c -m 4 #works
test23: selfie
	./selfie -c selfie.c -x 16 -c manuscript/code/fork_test_assignment5.c -y 8 #works
test24: selfie
	./selfie -c selfie.c -x 16 -c manuscript/code/fork_test_assignment5.c -x 8 #works
test25: selfie
	./selfie -c selfie.c -x 32 -c manuscript/code/fork_test_assignment5.c -z 16 #works very slow
test26: selfie
	./selfie -c selfie.c -m 4 -c manuscript/code/thread.c -m 2 #works
test27: selfie
	./selfie -c selfie.c -m 4 -c manuscript/code/thread.c -y 2 #works
test28: selfie
	./selfie -c selfie.c -m 4 -c manuscript/code/thread.c -x 2 #works
test29: selfie
	./selfie -c selfie.c -m 4 -c manuscript/code/thread.c -z 2 #works
test30: selfie
	./selfie -c selfie.c -x 8 -c manuscript/code/thread.c -m 4 #works
test31: selfie
	./selfie -c selfie.c -x 8 -c manuscript/code/thread.c -y 4 #works
test32: selfie
	./selfie -c selfie.c -x 8 -c manuscript/code/thread.c -x 4 #works
test33: selfie
	./selfie -c selfie.c -x 8 -c manuscript/code/thread.c -z 4 #works
test34: selfie
	./selfie -c manuscript/code/thread.c -m 2  #works
test35: selfie
	./selfie -c manuscript/code/thread.c -x 2 #works
test36: selfie
	./selfie -c manuscript/code/thread1.c -m 2 #works
test37: selfie
	./selfie -c selfie.c -m 4 -c manuscript/code/thread1.c -y 2 #works
test38: selfie
	./selfie -c manuscript/code/thread3.c -m 4 #works
test39: selfie
	./selfie -c selfie.c -m 4 -c manuscript/code/thread3.c -y 2 #works
test40: selfie
	./selfie -c manuscript/code/thread4.c -m 4 #works
test41: selfie
	./selfie -c selfie.c -m 4 -c manuscript/code/thread4.c -y 2 #works
test42: selfie
	./selfie -c manuscript/code/thread_with_lock.c -m 2
test43: selfie
	./selfie -c selfie.c -m 4 -c manuscript/code/thread_with_lock.c -m 2

# Test SAT solver
sat: selfie
	./selfie -sat manuscript/cnfs/rivest.cnf
	./selfie -c selfie.c -m 1 -sat manuscript/cnfs/rivest.cnf

# Test everything
all: test sat

# Clean up
clean:
	rm -rf *.m
	rm -rf *.s
	rm -rf selfie
	rm -rf selfie.exe
