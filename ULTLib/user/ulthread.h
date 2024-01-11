#ifndef __UTHREAD_H__
#define __UTHREAD_H__

#include <stdbool.h>

#define MAXULTHREADS 100

enum ulthread_state {
  FREE,
  RUNNABLE,
  YIELD,
  RUNNING,
};

enum ulthread_scheduling_algorithm {
  ROUNDROBIN,
  PRIORITY,   
  FCFS,         // first-come-first serve
};

// Saved registers for thread context switches.
struct thrd_context {
  uint64 ra;
  uint64 sp;

  // callee-saved
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;

  // Function Arguments
  uint64 a0;
  uint64 a1;
  uint64 a2;
  uint64 a3;
  uint64 a4;
  uint64 a5;
  uint64 a6;
  uint64 a7;
};

struct thrd {
  int tid; // thread id of thread
  enum ulthread_state state; // indicate the current state of user thread
  int t_priority; // priority of the thread
  struct thrd_context context; // context to save during context switch
};

#endif

void ulthread_schedule(void);
