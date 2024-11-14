#!/usr/bin/env python
import sys
import rospy
import time
import math
import numpy as np

sys.path.insert(1,'/home/jpedro/catkin_ws/src/niryo_one_python_api/src/niryo_one_python_api')

from niryo_one_api import*

rospy.init_node('niryo_one_example_python_api')

print(" --- Start ")

n = NiryoOne()
n.calibrate_auto()

print("Calibration finished \n")

#this function checks if the inputs of the angles are between the physical constrains of the robot
def check_angles(deg):
    
    ref = np.array([[-175, 175],
                    [-90, 36.7],
                    [-80, 90],
                    [-175, 175],
                    [-100, 110],
                    [-147.5, 147.5]])*math.pi/180

    for pos in range(6):
        if deg[pos] > ref[pos, 1]:
            deg[pos] = ref[pos, 1]
        elif deg[pos] < ref[pos, 0]:
            deg[pos] = ref[pos, 0]
    return deg

#given a vector of size 6 with each joint angle, this function will return a new vector of size 6
#with variation around the nominal values of each joint 
def noise(mu, s):
    noise = np.random.normal(mu, s)
    return noise
    
def current_milli_time():
    return round(time.time() * 1000)    

try:
    
    #middle positions between stack and objetive
    m0_sim = np.array([0.0, 0.640187, -1.397485, 0.0, 0.0, 0.0])
    m1_sim = np.array([-1.001819, 0.640187, -1.397485, 0.0, 0.0, 0.0])
    m2_sim = np.array([-1.001819, -0.400551, -0.684344, -0.131074, -0.282045, -0.919091])
    m3_sim = np.array([-0.476653, -0.589051, -0.750841, 0.452215, -0.184830, -0.919091])
    m4_sim = np.array([-0.074705, -0.717679, -0.769865, 0.773181, -0.106989, -0.919091])
    m5_sim = np.array([0.233874, -0.906175, -0.494626, 1.181763, -0.009774, -0.919091])
    
    #positions for each block in the stack
    stack_sim = np.array([[-1.001819, -0.563392, -0.684344, -0.131074, -0.282045, -0.919091],
                          [-1.014211, -0.731293, -0.642281, -0.131074, -0.223751, -0.919091],
                          [-1.014211, -0.903208, -0.589572, -0.131074, -0.087616, -0.919091],
                          [-1.014211, -1.070759, -0.513650, -0.131074, 0.009774, -0.919091]])
    
    #positions above blocks in the objetive
    finalu_sim = np.array([[0.233874, -0.906175, -0.494626, 1.181763, -0.009774, -0.919091],
                           [0.201586, -0.906175, -0.494626, 1.181763, -0.009774, -0.919091],
                           [0.379784, -0.906175, -0.494626, 0.889943, 0.025482, -0.481536],
                           [0.326202, -0.906175, -0.494626, 0.802328, -0.048694, -0.481536]])
    
    #final positions for each block               
    finald_sim = np.array([[0.233874, -1.077566, -0.465479, 1.181763, -0.009774, -0.919091],
                           [0.201586, -1.108459, -0.311716, 1.181763, -0.009774, -0.919091],
                           [0.379784, -1.085944, -0.421148, 0.889943, 0.025482, -0.481536],
                           [0.326202, -1.124865, -0.260054, 0.802328, -0.048694, -0.481536]])
    
    
    #Positions of the end-effector with added offsets for the real robot
    m0 = np.array([0.0, 0.640187, -1.397485, 0.0, 0.0, 0.0])
    m1 = np.array([-1.051037, 0.640187, -1.397485, 0.0, 0.0, 0.0])
    m2 = np.array([-1.051037, -0.428827, -0.667938, -0.131249, -0.434936, -0.988903])
    m3 = np.array([-0.476649, -0.589049, -0.750841, 0.452215, -0.184830, -0.919090])
    m4 = np.array([-0.074700, -0.717679, -0.769865, 0.773181, -0.106989, -0.919090])
    m5 = np.array([0.246615, -0.940383, -0.437729, 1.181937, -0.009774, -0.919090])
        
    stack = np.array([[-1.058542, -0.594808, -0.637045, -0.331089, -0.340339, -0.717156],
                      [-1.058542, -0.750666, -0.608422, -0.277158, -0.217119, -0.773181],
                      [-1.058542, -0.917694, -0.566534, -0.508589, -0.106291, -0.570897],
                      [-1.058542, -1.084722, -0.488518, -0.627271, -0.051662, -0.510683]])
       
    finalu = np.array([[0.246615, -0.940383, -0.437729, 1.181937, -0.009774, -0.919090],
                       [0.218166, -0.94038, -0.437729, 1.181937, -0.009774, -0.919090],
                       [0.397935, -0.940383, -0.437729, 1.181937, -0.009774, -0.919090],
                       [0.340339, -0.940383, -0.437729, 1.181937, -0.009774, -0.919090]])
                   
    finald = np.array([[0.246615, -1.086118, -0.437729, 1.181937, -0.009774, -0.919090],
                       [0.218166, -1.120501, -0.285710, 1.181937, -0.009774, -0.919090],
                       [0.397935, -1.100430, -0.398110, 1.181937, -0.009774, -0.919090],
                       [0.340339, -1.137606, -0.219388, 1.181937, -0.029147, -0.919090]])    
    
    w_t = 1  # waiting time in seconds
    
    time.sleep(w_t)  # waiting one second
    
    print "----\nSolution using simulation values"
    print "Added noise through normal distribution with sigma 0.01\n----\n"

    np.set_printoptions(suppress=True)
    np.set_printoptions(precision=3)    
    
    current_time = current_milli_time()    
    
    sigma = 0.01        
    print "time: ", current_milli_time()-current_time, ":", "n.calibrate_auto()"
    time.sleep(30) #give enough time for robot to calibrate
    
    print "time: ", current_milli_time()-current_time, ":", "n.set_arm_max_velocity(25)"
    n.set_arm_max_velocity(25)  # setting max limit at 25% of the maximum velocity    
    
    print "time: ", current_milli_time()-current_time, ":", m0_sim
    n.move_joints(m0_sim)
    time.sleep(w_t)
    print "time: ", current_milli_time()-current_time, ":", m1_sim    
    n.move_joints(m1_sim)
    time.sleep(w_t)
    print "time: ", current_milli_time()-current_time, ":", noise(m2_sim, sigma)
    n.move_joints(check_angles(noise(m2_sim, sigma)))
    time.sleep(w_t)
    
    for index in range(4):
        
        #grabbing the blocks from stack
        print "time: ", current_milli_time()-current_time, ":", "n.set_arm_max_velocity(5)"
        n.set_arm_max_velocity(5) #reduce speed when approaching the stack
        print "time: ", current_milli_time()-current_time, ":", noise(stack_sim[index], sigma)
        n.move_joints(check_angles(noise(stack_sim[index], sigma)))
        time.sleep(w_t)
        print "time: ", current_milli_time()-current_time, ":", noise(m2_sim, sigma)        
        n.move_joints(check_angles(noise(m2_sim, sigma)))
        time.sleep(w_t)
        print "time: ", current_milli_time()-current_time, ":", "n.set_arm_max_velocity(25)"
        n.set_arm_max_velocity(25) #return to normal speed
        
        #moving from the stack to final middle position
        print "time: ", current_milli_time()-current_time, ":", noise(m3_sim, sigma)
        n.move_joints(check_angles(noise(m3_sim, sigma)))
        time.sleep(w_t)
        print "time: ", current_milli_time()-current_time, ":", noise(m4_sim, sigma)
        n.move_joints(check_angles(noise(m4_sim, sigma)))
        time.sleep(w_t)
        
        #for the first block the final middle position (m5) and the position above it
        #are the same, so this move is redundant
        if index != 0:
            print "time: ", current_milli_time()-current_time, ":", noise(m5_sim, sigma)
            n.move_joints(check_angles(noise(m5_sim, sigma)))
            time.sleep(w_t)
        
        #placing the block in the final position
        print "time: ", current_milli_time()-current_time, ":", noise(finalu_sim[index], sigma)
        n.move_joints(check_angles(noise(finalu_sim[index], sigma)))        
        time.sleep(w_t)
        print "time: ", current_milli_time()-current_time, ":", "n.set_arm_max_velocity(5)"
        n.set_arm_max_velocity(5) #reduce speed when approaching the final position
        print "time: ", current_milli_time()-current_time, ":", noise(finald_sim[index], sigma)
        n.move_joints(check_angles(noise(finald_sim[index], sigma)))
        time.sleep(w_t)
        print "time: ", current_milli_time()-current_time, ":", noise(finalu_sim[index], sigma)        
        n.move_joints(check_angles(noise(finalu_sim[index], sigma)))
        time.sleep(w_t)
        print "time: ", current_milli_time()-current_time, ":", "n.set_arm_max_velocity(25)"
        n.set_arm_max_velocity(25) #return to normal speed
        
        #when the last block is in place the robot returns to initial position and stops
        if index == 3:
            print "time: ", current_milli_time()-current_time, ":", m0_sim
            n.move_joints(m0_sim)
            time.sleep(w_t)
            break
        
        #moving back to the stack to pick next block
        print "time: ", current_milli_time()-current_time, ":", m0_sim
        n.move_joints(check_angles(noise(m4_sim, sigma)))
        time.sleep(w_t)
        print "time: ", current_milli_time()-current_time, ":", noise(m3_sim, sigma)
        n.move_joints(check_angles(noise(m3_sim, sigma)))
        time.sleep(w_t)
        print "time: ", current_milli_time()-current_time, ":", noise(m2_sim, sigma)
        n.move_joints(check_angles(noise(m2_sim, sigma)))
        time.sleep(w_t)
    
    print "\n----\nSolution for the real robot"
    print "Added offsets to final position to compensate errors\n----\n"
        
    time.sleep(w_t)
    print "time: ", current_milli_time()-current_time, ":", "n.calibrate_auto()"
    time.sleep(30) #give enough time for robot to calibrate
    
    print "time: ", current_milli_time()-current_time, ":", "n.set_arm_max_velocity(25)"
    n.set_arm_max_velocity(25)  # setting max limit at 25% of the maximum velocity
    
    
    print "time: ", current_milli_time()-current_time, ":", m0
    n.move_joints(m0)
    time.sleep(w_t)
    print "time: ", current_milli_time()-current_time, ":", m1    
    n.move_joints(m1)
    time.sleep(w_t)
    print "time: ", current_milli_time()-current_time, ":", m2
    n.move_joints(m2)
    time.sleep(w_t)
    
    for index in range(4):
        
        #grabbing the blocks from stack
        print "time: ", current_milli_time()-current_time, ":", "n.set_arm_max_velocity(5)"
        n.set_arm_max_velocity(5) #reduce speed when approaching the stack
        print "time: ", current_milli_time()-current_time, ":", stack[index]
        n.move_joints(stack[index])
        time.sleep(w_t)
        print "time: ", current_milli_time()-current_time, ":", m2        
        n.move_joints(m2)
        time.sleep(w_t)
        print "time: ", current_milli_time()-current_time, ":", "n.set_arm_max_velocity(25)"
        n.set_arm_max_velocity(25) #return to normal speed
        
        #moving from the stack to final middle position
        print "time: ", current_milli_time()-current_time, ":", m3
        n.move_joints(m3)
        time.sleep(w_t)
        print "time: ", current_milli_time()-current_time, ":", m4
        n.move_joints(m4)
        time.sleep(w_t)
        
        #for the first block the final middle position (m5) and the position above it
        #are the same, so this move is redundant
        if index != 0:
            print "time: ", current_milli_time()-current_time, ":", m5
            n.move_joints(m5)
            time.sleep(w_t)
        
        #placing the block in the final position
        print "time: ", current_milli_time()-current_time, ":", finalu[index]
        n.move_joints(finalu[index])        
        time.sleep(w_t)
        print "time: ", current_milli_time()-current_time, ":", "n.set_arm_max_velocity(5)"
        n.set_arm_max_velocity(5) #reduce speed when approaching the final position
        print "time: ", current_milli_time()-current_time, ":", finald[index]
        n.move_joints(finald[index])
        time.sleep(w_t)
        print "time: ", current_milli_time()-current_time, ":", finalu[index]        
        n.move_joints(finalu[index])
        time.sleep(w_t)
        print "time: ", current_milli_time()-current_time, ":", "n.set_arm_max_velocity(25)"
        n.set_arm_max_velocity(25) #return to normal speed
        
        #when the last block is in place the robot returns to initial position and stops
        if index == 3:
            print "time: ", current_milli_time()-current_time, ":", m0
            n.move_joints(m0)
            time.sleep(w_t)
            break
        
        #moving back to the stack to pick next block
        print "time: ", current_milli_time()-current_time, ":", m4
        n.move_joints(m4)
        time.sleep(w_t)
        print "time: ", current_milli_time()-current_time, ":", m3
        n.move_joints(m3)
        time.sleep(w_t)
        print "time: ", current_milli_time()-current_time, ":", m2
        n.move_joints(m2)
        time.sleep(w_t)
        
except NiryoOneException as e:
    print(e)
