#!/usr/bin/env bash
set -e

source ./scripts/env.sh

# ----------------------------------------------------------
# 04. Save Map
# ----------------------------------------------------------
#
# This script saves the current SLAM map to local files.
#
# This script does NOT launch SLAM automatically.
#
# Reason:
# - SLAM is an interactive mapping process.
# - The user should decide when the map is good enough to save.
# - If SLAM and map saving are combined in one script, the map may be saved
#   too early before the environment is sufficiently mapped.
#
# Recommended workflow:
#
# 1. Run SLAM first:
#      ./scripts/run_02_slam.sh
#
# 2. Build the map.
#
#    Option A: No manual movement
#      - In simple Gazebo worlds, a partial map may be generated from the
#        initial LiDAR scan without moving the robot.
#      - This is enough for a quick test.
#
#    Option B: Move the robot with teleop
#      - Recommended for building a more complete map.
#      - Run this in another terminal:
#
#          ros2 run teleop_twist_keyboard teleop_twist_keyboard
#
#      - Move the robot around until the map looks complete in RViz.
#
# 3. Save the map by running this script in another terminal:
#      ./scripts/run_04_save_map.sh
#
# Output:
# - maps/my_map.yaml
# - maps/my_map.pgm
#
# ----------------------------------------------------------

mkdir -p maps

echo "[04] Saving map to maps/my_map"

ros2 run nav2_map_server map_saver_cli -f maps/my_map

echo "[04] Map saved:"
echo " - maps/my_map.yaml"
echo " - maps/my_map.pgm"