#include "./python_interface/timer.h"
#define real_t double

// void simulation_init();
// void simulation_cleanup();
// static struct Panoc_time* time_difference;

// int get_last_full_solution(real_t* output);
// struct Panoc_time* simulate_nmpc_panoc(real_t* current_state,real_t* optimal_inputs,
//                                         real_t* state_reference,real_t* input_reference);
// int simulation_set_buffer_solution(real_t value, int index);

/*
 * Simulates the controller and fill optimal_input with the optimal input.
 * -> returns the time till convergence
 */
void simulation_init();
struct Panoc_time* simulate_nmpc_panoc( real_t* current_state,
                                        real_t* optimal_inputs,
                                        real_t* state_reference,
                                        real_t* input_reference
                                        );

int get_last_full_solution(real_t* output);
void simulation_cleanup();
real_t simulation_get_weight_obstacles(int index_obstacle);
int simulation_set_weight_obstacles(int index_obstacle,real_t weight);
int simulation_set_buffer_solution(real_t value, int index);