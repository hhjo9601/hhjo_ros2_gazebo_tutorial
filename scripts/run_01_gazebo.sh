#!/usr/bin/env bash
set -e

colcon build --packages-select hhjo_ros2_gazebo_tutorial

source ./scripts/env.sh

LOG_DIR="./scripts/logs/run_01/run_01_$(date +%Y%m%d_%H%M_%S)"
mkdir -p "$LOG_DIR"

echo "[01] Running Gazebo with TurtleBot3 Waffle"
echo "[LOG] $LOG_DIR"

pids=()

run_node() {
    local name=$1
    shift

    echo "[RUN] $name"
    "$@" > "$LOG_DIR/${name}.log" 2>&1 &
    pids+=($!)
}

# Gazebo 실행
run_node gazebo ros2 launch hhjo_ros2_gazebo_tutorial gazebo.launch.py

echo ""
echo "Running:"
echo " - Gazebo TurtleBot3 Waffle"
echo ""
echo "Check:"
echo "  ros2 topic list"
echo ""
echo "Important Topics:"
echo "  /scan"
echo "  /odom"
echo "  /tf"
echo "  /cmd_vel"
echo ""
echo "RViz Setup:"
echo "  Fixed Frame → base_scan"
echo "  Add → LaserScan → Topic: /scan"
echo "  Add → TF"
echo ""
echo "Optional:"
echo "  ros2 run rqt_image_view rqt_image_view"
echo "  Select topic → /camera/image_raw"
echo ""
echo "Logs:"
echo "  tail -f $LOG_DIR/*.log"
echo ""
echo "Press Ctrl+C to stop all"

cleanup() {
    echo "Stopping..."

    for pid in "${pids[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid"
        fi
    done

    exit 0
}

trap cleanup SIGINT SIGTERM

wait