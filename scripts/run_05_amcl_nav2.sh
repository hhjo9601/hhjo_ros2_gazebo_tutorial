#!/usr/bin/env bash
set -e

source ./scripts/env.sh

echo "[05] Running Nav2 with AMCL (static map)"

MAP_FILE=maps/my_map.yaml

# 1. Gazebo
echo "[05-1] Gazebo"
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py &

sleep 5

# 2. Nav2 (includes map_server + amcl)
echo "[05-2] Nav2 bringup"
ros2 launch nav2_bringup bringup_launch.py \
  map:=$MAP_FILE \
  use_sim_time:=True &

sleep 5

# 3. RViz
echo "[05-3] RViz"
rviz2 &

echo ""
echo "Navigation Ready"
echo "→ Use '2D Pose Estimate' to initialize robot"
echo "→ Use '2D Goal Pose' to send goal"
echo ""

wait