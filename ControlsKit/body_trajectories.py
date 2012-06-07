from ControlsKit import time_sources, leg_controller, leg_trajectories, leg_logger
from ControlsKit.leg_trajectories import TrapezoidalFootMove, Pause
from math_utils import NUM_LEGS
from scipy import zeros, append
from ControlsKit.math_utils import array

class TrapezoidalSitStand:
    """This trajectory moves the hexapod body straight up or down with a trapezoidal velocity profile
    """
    
    #TODO: check to make sure all legs are on the ground first
    
    def __init__(self, body_controller, final_height, max_velocity, acceleration):
        leg_logger.logger.info("New trajectory.", traj_name="TrapezoidalSitStand",
                    final_height=final_height, max_velocity=max_velocity,
                    acceleration=acceleration)
        
        self.body = body_controller
        self.final_foot_positions = zeros((3, NUM_LEGS))
        self.tfm = []
        
        current_positions = self.body.getFootPositions()
        for i in range (NUM_LEGS):
            self.final_foot_positions[2,i] = final_height
        for i in range (NUM_LEGS):
            self.tfm = append(self.tfm, TrapezoidalFootMove(self.body.getLegs()[i], self.final_foot_positions[:,i], max_velocity, acceleration))
            #self.tfm = append(self.tfm, Pause(self.body.getLegs()[i], 1))
            
        self.done = False
    
    def isDone(self):
        return self.done    
    
    def update(self):
        if not self.done:
            #logically and all of the isdone results from the trapezoidal foot move trajectories
            self.done = reduce(lambda x,y: x and y, map(TrapezoidalFootMove.isDone, self.tfm))
            #self.done = reduce(lambda x,y: x and y, map(Pause.isDone, self.tfm))
            return [self.tfm[i].update() for i in range (NUM_LEGS)]

class BodyPause:
    def __init__(self, body_controller, duration):
        self.body = body_controller
        self.initial_angles = self.body.getJointAngleMatrix()
        self.duration = duration
        self.sw = time_sources.StopWatch();
        self.done = False
    
    def isDone(self):
        return self.done
    
    def update(self):
        if not self.done():
            #logically and all of the isdone results from the trapezoidal foot move trajectories
            self.done = reduce(lambda x,y: x and y, map(TrapezoidalFootMove.isDone, self.tfm))
        return self.initial_angles