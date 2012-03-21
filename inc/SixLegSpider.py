from MultiBody import MultiBody
from helpers import *
import ode
import collections

class Controller():
    def __init__( self ):
        self.input_callbacks  = {}
        self.output_callbacks = {}
    def setInputCallback( self, name, callback ):
        if not (isinstance(callback, collections.Callable) \
             or isinstance(callback, Callback)):
            raise
        self.input_callbacks[name] = callback
    def setOutputCallback( self, name, callback ):
        if not (isinstance(callback, collections.Callable) \
             or isinstance(callback, Callback)):
            raise
        if self.output_callbacks.has_key(name):
            raise
        self.output_callbacks[name] = callback
    def getInput( self, name, *args, **kwargs ):
        callback = self.input_callbacks[name]
        if isinstance(callback, Callback):
            return callback.call( *args, **kwargs )
        # Assume it's a function
        return callback(*args, **kwargs)
    def setOutput( self, name, *args, **kwargs ):
        callback = self.output_callbacks[name]
        if isinstance( callback, Callback ):
            return callback.call( *args, **kwargs )
        # Assume it's a function
        return callback(*args, **kwargs)
    def update( self, dt ):
        pass

BODY_W  = 0.4
BODY_T  = 0.3
YAW_L   = 0.3
YAW_W   = 0.1
THIGH_L = 1.83 # 6 feet
THIGH_W = 0.125
CALF_L  = 2.44  # 8 feet
CALF_W  = 0.1

BODY_M  = 454  # 1000 lbs
YAW_M   = 10.0 # 22 lbs
THIGH_M = 36.3 # 80 lbs
CALF_M  = 36.3 # 80 lbs

class SixLegSpider(MultiBody):
    def buildBody( self ):
        """ Build an equilateral hexapod """
        # These are the rotation matrices we will use
        r_30z = calcRotMatrix( (0,0,1), pi/6.0 )
        r_60z = calcRotMatrix( (0,0,1), pi/3.0 )
        r_90z = calcRotMatrix( (0,0,1), pi/2.0 )
        # p_hip is the point where the hip is located.
        # We want to start it 30 degrees into a rotation around Z
        p_hip = (BODY_W/2.0, 0, 0)
        #p_hip = rotate3( r_30z, p_hip )
        self.core = [0,0,0]
        self.core[0] = self.addBody( p_hip, mul3(p_hip, -1), BODY_T, mass=BODY_M )

        # publisher is used to register all the variables we will want to track and chart
        global publisher

        # The core of the body is now complete.  Now we start on the legs.
        # Start another rotation
        p = (1, 0, 0)
        p = rotate3( r_30z, p )
        self.legs                  = [0,0,0,0,0,0]
        for i in range(6):
            yaw_p  = mul3( p, (BODY_W/2.0) )
            hip_p  = mul3( p, (BODY_W/2.0)+YAW_L )
            knee_p = mul3( p, (BODY_W/2.0)+YAW_L+THIGH_L )
            foot_p = mul3( p, (BODY_W/2.0)+YAW_L+THIGH_L+CALF_L )
            # Add hip yaw
            yaw_link = self.addBody( \
                p1     = yaw_p, \
                p2     = hip_p, \
                radius = YAW_W, \
                mass   = YAW_M )
            hip_yaw = self.addControlledHingeJoint( \
                body1        = self.core[0], \
                body2        = yaw_link, \
                anchor       = yaw_p, \
                axis         = (0,0,1), \
                torque_limit = 6.0e3, \
                gain         = 10.0)

            # Add thigh and hip pitch
            # Calculate the axis of rotation for hip pitch
            axis = rotate3( r_90z, p )
            thigh = self.addBody(\
                p1     = hip_p, \
                p2     = knee_p, \
                radius = THIGH_W, \
                mass   = THIGH_M )
            hip_pitch = self.addControlledHingeJoint( \
                body1        = yaw_link, \
                body2        = thigh, \
                anchor       = hip_p, \
                axis         = axis, \
                torque_limit = 10.0e3, \
                gain         = 10.0)

            # Add calf and knee bend
            calf = self.addBody( \
                p1     = knee_p, \
                p2     = foot_p, \
                radius = CALF_W, \
                mass   = CALF_M )
            knee_pitch = self.addControlledHingeJoint( \
                body1        = thigh, \
                body2        = calf, \
                anchor       = knee_p, \
                axis         = axis, \
                torque_limit = 6.0e3, \
                gain         = 10.0)

            d                 = {}
            d['hip_yaw']      = hip_yaw
            d['hip_pitch']    = hip_pitch
            d['knee_pitch']   = knee_pitch
            d['hip_yaw_link'] = yaw_link
            d['thigh']        = thigh
            d['calf']         = calf
            self.legs[i]      = d

            p = rotate3( r_60z, p )

    
    def getKneeAngle(self, n):
        return self.knee_angles[n]
    def getHipPitchAngle(self, n):
        return self.hip_pitch_angles[n]
    def getHipYawAngle(self, n):
        return self.hip_yaw_angles[n]


    def setDesiredFootPositions( self, positions ):
        """
        positions should be an iterable of 6 positions relative to the body
        """
        # FIXME:  THIS FUNCTION DOES NOT YET INCLUDE A HIPYAW LINK
        # These are the rotation matrices we will use
        r_30z = calcRotMatrix( (0,0,1), pi/6.0 )
        r_60z = calcRotMatrix( (0,0,1), pi/3.0 )
        r_90z = calcRotMatrix( (0,0,1), pi/2.0 )
        p = (1,0,0)
        p = rotate3( r_30z, p )

        i = 0


        for target_p in positions:
            yaw_p = mul3(p, (BODY_W/2))
            # Calculate hip yaw
            hip_yaw_offset_angle     = atan2(yaw_p[1], yaw_p[0])
            hip_yaw_angle            = atan2( target_p[1], target_p[0] ) - hip_yaw_offset_angle
            yaw_link_offset = mul3(p, YAW_L)
            yaw_link_offset = ( yaw_link_offset[0]*cos(hip_yaw_angle),\
                                yaw_link_offset[1]*sin(hip_yaw_angle),\
                                0)
            hip_p = add3(yaw_p, yaw_link_offset)
            # Assign outputs
            # Calculate leg length
            leg_l                    = dist3( target_p, hip_p )
            # Use law of cosines on leg length to calculate knee angle 
            knee_angle               = pi-thetaFromABC( THIGH_L, CALF_L, leg_l )
            # Calculate target point relative to hip origin
            target_p                 = sub3( target_p, hip_p )
            # Calculate hip pitch
            hip_offset_angle         = -thetaFromABC( THIGH_L, leg_l,  CALF_L )
            hip_depression_angle     = -atan2( target_p[2], len3((target_p[0], target_p[1], 0)) )
            hip_pitch_angle          = hip_offset_angle + hip_depression_angle
            self.legs[i]['hip_yaw'   ].setAngleTarget( -hip_yaw_angle   )
            self.legs[i]['hip_pitch' ].setAngleTarget( -hip_pitch_angle )
            self.legs[i]['knee_pitch'].setAngleTarget( -knee_angle      )
            # Calculate the hip base point for the next iteration
            p                    = rotate3( r_60z, p )
            i+=1

    def getBodyHeight( self ):
        return self.core[0].getPosition()[2]
    def getPosition( self ):
        return self.core[0].getPosition()
    def getVelocity( self ):
        return self.core[0].getLinearVel()
    def update( self ):
        global global_dt
        for joint in self.joints:
            joint.update()