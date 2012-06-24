from ControlsKit import time_sources, leg_logger
from ControlsKit.math_utils import normalize, norm, arraysAreEqual, rotateZ, array
from numpy import arctan2, sign, pi, cos, sin

class RotateFootAboutOrigin:
    """This is a trapezoidal speed ramp, where speed is derivative foot position WRT time.
        NOTE: Max velocity and acceleration are required to be in angular rates.
    """
    def __init__(self, body_model, leg_index, leg_model, limb_controller, delta_angle, max_velocity, acceleration):
        leg_logger.logger.info("New path.", path_name="RotateFootAboutOrigin",
                    delta_angle=delta_angle, max_velocity=max_velocity,
                    acceleration=acceleration)
        
        self.body_model = body_model
        self.leg_index = leg_index
        self.leg_model = leg_model
        self.controller = limb_controller
        self.target_foot_pos = self.leg_model.getFootPos()
        self.delta_angle = delta_angle
        self.max_ang_vel = max_velocity
        self.ang_vel = 0.0
        self.ang_acc = acceleration
        
        self.body_coord = body_model.transformLeg2Body(self.leg_index, self.target_foot_pos)
        self.init_angle = arctan2(self.body_coord[1], self.body_coord[0])
        self.last_commanded_angle = self.init_angle
        self.target_angle = self.init_angle
        self.radius = norm([self.body_coord[0],self.body_coord[1]])
        self.init_height = self.body_coord[2]
        
        # Unit vector pointing towards the destination
        self.dir = sign(self.delta_angle)
        self.done = False
     
        self.sw = time_sources.StopWatch()
        self.sw.smoothStart(1)#self.accel_duration)
        # FIXME:the above line should have accel_duration reinstated.

    def isDone(self):
        return self.done

    def update(self):
        if not self.isDone():
            delta = time_sources.global_time.getDelta()
            # if the remaining distance <= the time it would take to slow
            # down times the average speed during such a deceleration (ie
            # the distance it would take to stop)
            
            #self.body_coord = [self.radius*cos(self.last_commanded_angle), self.radius*sin(self.last_commanded_angle), self.init_height]
            self.target_angle = self.last_commanded_angle
            remaining_angle = self.delta_angle + self.init_angle - self.target_angle
            
            if norm(remaining_angle) <= .5 * self.ang_vel**2 / self.ang_acc:
                self.ang_vel -= self.ang_acc * delta
            else:
                self.ang_vel += self.ang_acc * delta
                self.ang_vel = min(self.ang_vel, self.max_ang_vel)
            self.target_angle += self.dir * self.ang_vel * delta
            self.last_commanded_angle = self.target_angle
            self.target_foot_pos = [self.radius*cos(self.target_angle), self.radius*sin(self.target_angle), self.init_height]

            if not sign(remaining_angle) == self.dir:
                self.done = True
                #self.target_foot_pos = self.final_foot_pos
        a = self.body_model.transformBody2Leg(self.leg_index, self.target_foot_pos)
        if self.leg_index == 0:
            print("target angle", self.target_angle)
            print("body_frame radius", norm([self.body_coord[0],self.body_coord[1]]))
            print("stored radius value", self.radius)
            print("target frame radius", norm([self.target_foot_pos[0],self.target_foot_pos[1]]))
            print("transformed radius", norm([a[0],a[1]]))
            print("---")
        return self.leg_model.jointAnglesFromFootPos(a)
