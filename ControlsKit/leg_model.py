import sys
sys.path.append('..')
from ConfigParser import ConfigParser
from math_utils import *
from filters import HighPassFilter
import math
from UI import logger
from os import path
from SimulationKit.helpers import *

class LegModel:
    def __init__(self, config_file="leg_model.conf", section="LegModel"):
        c = ConfigParser()
        if not path.exists(path.abspath(config_file)):
            print 'Config file %s not found!'%config_file
            raise IOError
        c.read(config_file)
        
        # Link lengths
        self.YAW_LEN = c.getfloat(section, "yaw_len")
        self.THIGH_LEN = c.getfloat(section, "thigh_len")
        self.CALF_LEN = c.getfloat(section, "calf_len")
        
        self.YAW_COM_COORD = [c.getfloat(section, "yaw_com_x"), c.getfloat(section, "yaw_com_y"), c.getfloat(section, "yaw_com_z")]
        self.THIGH_COM_COORD = [c.getfloat(section, "thigh_com_x"), c.getfloat(section, "thigh_com_y"), c.getfloat(section, "thigh_com_z")]
        self.CALF_COM_COORD = [c.getfloat(section, "calf_com_x"), c.getfloat(section, "calf_com_y"), c.getfloat(section, "calf_com_z")]
        
        self.YAW_MASS = c.getfloat(section, "yaw_mass")
        self.THIGH_MASS = c.getfloat(section, "thigh_mass")
        self.CALF_MASS = c.getfloat(section, "calf_mass")
        self.FOOT_MASS = c.getfloat(section, "foot_mass")
        self.LEG_MASS = self.YAW_MASS+self.THIGH_MASS+self.CALF_MASS+self.FOOT_MASS

        # Actuator soft bounds
        soft_stops_section = 'SoftStops'
        self.SOFT_MINS=array(
                [c.getfloat(soft_stops_section,'yaw_stop_low'),
                c.getfloat(soft_stops_section,'pitch_stop_low'),
                c.getfloat(soft_stops_section,'knee_stop_low')])
        self.SOFT_MAXES=array(
                [c.getfloat(soft_stops_section,'yaw_stop_high'),
                c.getfloat(soft_stops_section,'pitch_stop_high'),
                c.getfloat(soft_stops_section,'knee_stop_high') ])

        # State
        vel_corner = 100.0  # rad/s
        self.jv_filter = HighPassFilter(vel_corner, vel_corner)  # band limited differentiator
        self.setSensorReadings(self.SOFT_MINS[0], self.SOFT_MINS[1], self.SOFT_MINS[2], 0.0)

        # Events
        self.SHOCK_DEPTH_THRESHOLD_LOW = c.getfloat(section, "shock_depth_threshold_low")
        self.SHOCK_DEPTH_THRESHOLD_HIGH = c.getfloat(section, "shock_depth_threshold_high")
        self.foot_on_ground = False

    # Store sensor readings
    def setSensorReadings(self, yaw, hip_pitch, knee_pitch, shock_depth):
        self.joint_angles = array([yaw, hip_pitch, knee_pitch])
        
        #throw errors if measured joint angles are NaN, out of bounds, etc
        for angle, soft_min, soft_max in zip(self.joint_angles, self.SOFT_MINS, self.SOFT_MAXES):
            if math.isnan(angle):
                logger.error("LegModel.setSensorReadings: NaN where aN expected!",
                            angle=angle,
                            angle_index=self.joint_angles.searchsorted(angle),
                            yaw=yaw,
                            hip_pitch=hip_pitch,
                            knee_pitch=knee_pitch,
                            shock_depth=shock_depth,
                            bad_value="angle")
                raise ValueError("LegModel: Measured angle cannot be NaN.")
                
            if (soft_min > angle) or (angle > soft_max):
                logger.error("LegModel: Measured position outside of soft range!",
                        angle=angle,
                        angle_index=self.joint_angles.searchsorted(angle),
                        yaw=yaw,
                        hip_pitch=hip_pitch,
                        knee_pitch=knee_pitch,
                        shock_depth=shock_depth,
                        soft_min=soft_min,
                        soft_max=soft_max,
                        bad_value="angle")
                print soft_min
                print soft_max
                print angle
                raise ValueError("LegModel: Measured angle out of soft range!")
        self.shock_depth = shock_depth
        self.joint_velocities = self.jv_filter.update(self.joint_angles)        

    # Access state
    def getJointAngles(self):
        return self.joint_angles
    def getJointVelocities(self):
        return self.joint_velocities
    def getShockDepth(self):
        return self.shock_depth
    def getLegState(self):
        return [self.getJointAngles(), self.getShockDepth()]

    # Kinematics
    def getFootPos(self):
        return self.footPosFromLegState(self.getLegState())
    def footPosFromLegState(self, leg_state):
        pos = array([self.CALF_LEN - leg_state[1], 0.0, 0.0])
        pos = rotateY(pos, leg_state[0][KP])
        pos[X] += self.THIGH_LEN
        pos = rotateY(pos, leg_state[0][HP])
        pos[X] += self.YAW_LEN
        return rotateZ(pos, leg_state[0][YAW])
    def jointAnglesFromFootPos(self, pos, shock_depth=0.0):
        # Calculate hip yaw
        hip_yaw_angle   = atan2( pos[1], pos[0] )
        # Calculate hip yaw offset
        hip_p = norm2( (pos[0], pos[1]) )
        hip_p = (self.YAW_LEN*hip_p[0], self.YAW_LEN*hip_p[1], 0.0)
        # Calculate leg length
        leg_l                    = dist3( pos, hip_p )
        # Use law of cosines on leg length to calculate knee angle 
        knee_angle               = pi-thetaFromABC( self.THIGH_LEN,\
            self.CALF_LEN-shock_depth, leg_l )
        # Calculate hip pitch
        hip_offset_angle         = thetaFromABC( self.THIGH_LEN, leg_l,
            self.CALF_LEN-shock_depth )
        target_p                 = sub3(pos, hip_p)
        hip_depression_angle     = atan2( -target_p[2], len2((target_p[0], target_p[1])) )
        hip_pitch_angle          = hip_depression_angle - hip_offset_angle
        return (hip_yaw_angle, hip_pitch_angle, knee_angle)

    def posIsPossible(self, pos, lower_limits, upper_limits):
        ikSolution = self.jointAnglesFromFootPos(pos)
        for i in range(len(pos)):
            if lower_limits[i] > pos[i] or pos[i] > upper_limits[i]:
                return False
        return True

    # Touch-down detection
    def isFootOnGround(self):
        return self.foot_on_ground
    def updateFootOnGround(self):
        sd = self.getShockDepth()
        if sd < self.SHOCK_DEPTH_THRESHOLD_LOW:
            self.foot_on_ground = False
        elif sd > self.SHOCK_DEPTH_THRESHOLD_HIGH:
            self.foot_on_ground = True
    
    def isMoving(self, tolerance=0.001):
        return (abs(self.joint_velocities) >= tolerance).any()
    
    def getCOM(self):
        """ This function returns the COM of the leg given its current joint positions.
        """
        joint_angles = self.getJointAngles()
        # Calculate Yaw position
        yaw_pos = rotateZ(self.YAW_COM_COORD, joint_angles[YAW])
        # Calculate Thigh position
        thigh_pos = rotateY(self.THIGH_COM_COORD, joint_angles[HP])
        thigh_pos[X] += self.YAW_LEN
        thigh_pos = rotateZ(thigh_pos, joint_angles[YAW])
        # Calculate Calf position
        calf_pos = rotateY(self.CALF_COM_COORD, joint_angles[KP])
        calf_pos[X] += self.THIGH_LEN
        calf_pos = rotateY(calf_pos, joint_angles[HP])
        calf_pos[X] += self.YAW_LEN
        calf_pos = rotateZ(calf_pos, joint_angles[YAW])
        # Calculate Foot position
        foot_pos = self.getFootPos()
        
        COM_pos = (yaw_pos*self.YAW_MASS+thigh_pos*self.THIGH_MASS+calf_pos*self.CALF_MASS+foot_pos*self.FOOT_MASS)/(self.LEG_MASS)
        return COM_pos