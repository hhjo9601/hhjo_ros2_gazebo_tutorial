#!/usr/bin/env bash
set -e

colcon build --packages-select hhjo_ros2_gazebo_tutorial

source ./scripts/env.sh

LOG_DIR="./scripts/logs/run_02/run_02_$(date +%Y%m%d_%H%M_%S)"
mkdir -p "$LOG_DIR"

echo "[02] Running Gazebo + SLAM"
echo "[LOG] $LOG_DIR"

pids=()

run_node() {
    local name=$1
    shift

    echo "[RUN] $name"
    "$@" > "$LOG_DIR/${name}.log" 2>&1 &
    pids+=($!)
}

# ----------------------------------------------------------
# 1. Gazebo 실행
# ----------------------------------------------------------
run_node gazebo ros2 launch hhjo_ros2_gazebo_tutorial gazebo.launch.py

sleep 5

# ----------------------------------------------------------
# 2. SLAM 실행 (slam_toolbox)
# ----------------------------------------------------------
run_node slam ros2 launch slam_toolbox online_async_launch.py use_sim_time:=true

sleep 3

# ----------------------------------------------------------
# 3. RViz 실행 (OpenGL 오류 대응 포함)
# ----------------------------------------------------------
LIBGL_ALWAYS_SOFTWARE=1 rviz2 &
pids+=($!)

# ----------------------------------------------------------
# 안내 출력
# ----------------------------------------------------------
echo ""
echo "Running:"
echo " - Gazebo TurtleBot3 Waffle"
echo " - slam_toolbox"
echo " - RViz2"
echo ""
echo "Check:"
echo "  ros2 topic list | grep map"
echo "  ros2 topic echo /map --once"
echo ""
echo "Control (teleop):"
echo "  ros2 run teleop_twist_keyboard teleop_twist_keyboard"
echo ""
echo "RViz Setup:"
echo "  Fixed Frame → map"
echo "  Add → Map → Topic: /map"
echo "  Add → LaserScan → Topic: /scan"
echo "  Add → TF"
echo ""
echo "If RViz map rendering fails:"
echo "  LIBGL_ALWAYS_SOFTWARE=1 rviz2"
echo ""
echo "Logs:"
echo "  tail -f $LOG_DIR/*.log"
echo ""
echo "Press Ctrl+C to stop all"

# ----------------------------------------------------------
# 종료 처리
# ----------------------------------------------------------
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