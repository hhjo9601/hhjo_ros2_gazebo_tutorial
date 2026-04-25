#!/usr/bin/env bash
set -e

colcon build --packages-select hhjo_ros2_gazebo_tutorial

source ./scripts/env.sh

LOG_DIR="./scripts/logs/run_03/run_03_$(date +%Y%m%d_%H%M_%S)"
mkdir -p "$LOG_DIR"

echo "[03] Running Gazebo + SLAM + Nav2"
echo "[LOG] $LOG_DIR"

pids=()

run_node() {
    local name=$1
    shift

    echo "[RUN] $name"
    "$@" > "$LOG_DIR/${name}.log" 2>&1 &
    pids+=($!)
}

# Gazebo
run_node gazebo ros2 launch hhjo_ros2_gazebo_tutorial gazebo.launch.py

sleep 5

# SLAM
run_node slam ros2 launch slam_toolbox online_async_launch.py use_sim_time:=true

sleep 5

# Nav2
run_node nav2 ros2 launch nav2_bringup navigation_launch.py use_sim_time:=true

sleep 5

# RViz
LIBGL_ALWAYS_SOFTWARE=1 rviz2 &
pids+=($!)

echo ""
echo "Running:"
echo " - Gazebo TurtleBot3 Waffle"
echo " - slam_toolbox"
echo " - Nav2"
echo " - RViz2"
echo ""
echo "Control:"
echo "  Use RViz → 2D Goal Pose"
echo ""
echo "RViz Setup:"
echo "  Fixed Frame → map"
echo "  Add → Map → /map"
echo "  Add → TF"
echo "  Add → RobotModel"
echo ""
echo "Logs:"
echo "  tail -f $LOG_DIR/*.log"
echo ""
echo "Press Ctrl+C to stop all"

cleanup() {
    echo "Stopping..."
    for pid in "${pids[@]}"; do
        kill "$pid" 2>/dev/null || true
    done
    exit 0
}

trap cleanup SIGINT SIGTERM
wait