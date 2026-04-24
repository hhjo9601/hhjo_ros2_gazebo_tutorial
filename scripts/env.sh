#!/usr/bin/env bash

# ===== ROS2 base =====
source /opt/ros/humble/setup.bash

# ===== Workspace =====
source ./install/setup.bash

# ===== TurtleBot3 model =====    
export TURTLEBOT3_MODEL=waffle

echo "[ENV] ROS2 + workspace + TurtleBot3(waffle) loaded"