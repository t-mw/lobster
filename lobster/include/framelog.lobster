// Helper functions for Lobster's frame log functionality.

// Functions that take multiple frames to run.
// They return true if they ran this frame, to signal time based control structures.

// Run body f for seconds. Always runs once if seconds > 0, first called with time 0, last
// called with some time < seconds.
def time_for(seconds:float, f):
    time ?= 0.0
    start := time
    time += gl_deltatime()
    if start < seconds:
        f(start)
        true
    else:
        false

// If cond is true, start running f until it is done (signalled by its return value).
// If cond fires again while running f, this does not restart or abort f.
def time_if(cond, f):
    on ?= false
    if cond: on = true
    if on and !f(): on = false
    on

// If cond is true, start running f until it is done (signalled by its return value).
// If cond fires again while running f, f is stopped and restarted the next frame.
def time_fire(cond, f):
    on ?= false
    if cond:
        if !on:
            on = true
            if !f(): on = false
        // else: already on, don't run f() this frame to reset it.
    else:
        if on and !f(): on = false
    on

// Runs the first, followed by the second.
// (More syntactically convenient than using "or" directly).
def time_sequence(first, second):
    first() or second()
def time_sequence(first, second, third):
    first() or second() or third()
