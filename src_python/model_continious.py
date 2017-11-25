import model as m
import integrators as ig

class Model_continious(m.Model):
    def __init__(self,system_equations,g,step_size,integrator):
        super.__init__(system_equations,g,step_size)
        self._integrator=integrator

    def get_next_state(self,state,input):
        """ integrate the continous system with one step using the selected integrator """
        if (self._integrator == "RK"):
            system_equation = lambda state: super._system_equations(state, input)
            return ig.integrator_RK(state, self._step_size, system_equation)
        else:
            raise NotImplementedError

    @property
    def integrator(self):
        return self._integrator
    @integrator.setter
    def integrator(self, value):
        self._integrator = value