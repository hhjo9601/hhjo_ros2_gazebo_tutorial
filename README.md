
# ROS2 Gazebo Tutorial

This repository demonstrates how to run a TurtleBot3 simulation in Gazebo using ROS2 Humble.

---

## Prerequisites

install required packages:

```bash
sudo apt update

sudo apt install -y \
  ros-humble-gazebo-ros-pkgs \
  ros-humble-gazebo-ros2-control \
  ros-humble-turtlebot3* \
  ros-humble-slam-toolbox \
  ros-humble-navigation2 \
  ros-humble-nav2-bringup \
  ros-humble-rviz2 \
  ros-humble-rqt \
  ros-humble-rqt-image-view \
  ros-humble-tf2-tools \
  ros-humble-tf-transformations \
  ros-humble-ros2-control \
  ros-humble-ros2-controllers \
  python3-colcon-common-extensions \
  python3-rosdep \
  python3-vcstool
  ```

---

## Quick start

Run Gazebo simulation:

./scripts/run_01_gazebo.sh

Run SLAM (mapping):

./scripts/run_02_slam.sh

---

## Overview

This project builds a simulation pipeline step-by-step:

Gazebo → Sensor Data → SLAM → Map

## Project Structure

hhjo_ros2_gazebo_tutorial/
├── launch/
│   └── gazebo.launch.py
├── scripts/
│   ├── env.sh
│   ├── run_01_gazebo.sh
│   └── run_02_slam.sh

---

## Timeline

### 1. Gazebo Simulation

- Launched TurtleBot3 simulation in Gazebo
- Configured TurtleBot3 model (waffle)
- Verified core ROS2 topics from simulation
- Topics:
  - `/scan` (LiDAR)
  - `/odom` (Odometry)
  - `/tf`, `/tf_static` (Transforms)
  - `/cmd_vel` (Control command)

Pipeline Structure:

```text
Gazebo (TurtleBot3 Waffle)
            ↓
   Sensor Topics
 (/scan, /odom, /tf)
```

---

### 2. SLAM (Mapping)

- Integrated slam_toolbox
- Generated map (/map) from LiDAR data
- Visualized map in RViz
- Topics:
  - /scan → /map
  - /map
  - /map_metadata

Pipeline Structure:

Gazebo → /scan → slam_toolbox → /map

#### Run

./scripts/run_02_slam.sh

#### Control (optional)

ros2 run teleop_twist_keyboard teleop_twist_keyboard

---

## Visualization

### RViz Setup (SLAM)

Fixed Frame → map

Add:
- Map → /map
- LaserScan → /scan
- TF

---

## What You Learn

- Gazebo simulation with TurtleBot3
- ROS2 sensor topics and data flow
- SLAM (Simultaneous Localization and Mapping)
- RViz-based visualization
- Basic autonomous robotics pipeline

---

## License

MIT License