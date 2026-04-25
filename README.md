
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

Run Navigation:

./scripts/run_03_nav2.sh

---

## Overview

This project builds a simulation pipeline step-by-step with explicit ROS2 nodes and topics:

```text
Gazebo (simulation)
    ↓
[ gazebo_ros / turtlebot3 nodes ]
    ↓ publish
/scan        /odom        /tf
    ↓
[ slam_toolbox node ]
    ↓ subscribe: /scan, /tf
    ↓ publish
/map
    ↓
[ nav2 (navigation stack) ]
    ↓ subscribe: /map, /odom, /tf
    ↓ publish
/cmd_vel
    ↓
[ robot controller ]
    ↓
Robot Movement
```

### Key Topics

- `/scan` → LiDAR sensor data  
- `/odom` → Odometry (robot position estimate)  
- `/tf` → Coordinate transforms  
- `/map` → Generated map from SLAM  
- `/cmd_vel` → Velocity command (linear / angular)

### Node Responsibilities

- **Gazebo / TurtleBot3**
  - Simulates robot and sensors
  - Publishes `/scan`, `/odom`, `/tf`

- **slam_toolbox**
  - Builds a map using LiDAR data
  - Subscribes to `/scan`, `/tf`
  - Publishes `/map`

- **Nav2 (Navigation2)**
  - Path planning and control
  - Subscribes to `/map`, `/odom`, `/tf`
  - Publishes `/cmd_vel`

- **Robot Controller**
  - Executes movement commands
  - Subscribes to `/cmd_vel`

## Project Structure

```text
hhjo_ros2_gazebo_tutorial/
├── launch/
│   └── gazebo.launch.py
├── scripts/
│   ├── env.sh
│   ├── run_01_gazebo.sh
│   └── run_02_slam.sh
│   └── run_03_nav2.sh
```

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
[ gazebo_ros / turtlebot3 nodes ]
    ↓ publish
/scan        /odom        /tf
    ↓
(available to other nodes)
```

#### Run

./scripts/run_01_gazebo.sh

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

```text
[ gazebo_ros ]
    ↓ publish
/scan        /tf
    ↓
[ slam_toolbox node ]
    ↓ subscribe: /scan, /tf
    ↓ publish
/map
```

#### Run

./scripts/run_02_slam.sh

#### Control (optional)

ros2 run teleop_twist_keyboard teleop_twist_keyboard

---

### 3. Navigation (Nav2)

- Goal-based autonomous navigation using Nav2
- Robot moves to target positions using `/cmd_vel`

Pipeline Structure:

```text
[ slam_toolbox ]
    ↓ publish
/map
    ↓
[ nav2 stack ]
    ↓ subscribe: /map, /odom, /tf
    ↓ publish
/cmd_vel
    ↓
[ robot controller ]
    ↓
Robot Movement
```

#### Run

```bash
./scripts/run_03_nav2.sh
```

---

## Visualization

### RViz Setup (SLAM + Nav2)

Fixed Frame → map

Add:
- Map → /map
- LaserScan → /scan
- TF
- RobotModel
- Path
- Global Costmap
- Local Costmap

Navigation:
- Use `2D Goal Pose` in RViz
- Select a target position on the map
- Nav2 generates a path and publishes `/cmd_vel`
- TurtleBot3 moves toward the goal

---

### 4. Save Map

- Saved the generated SLAM map to local files
- Separated map saving from SLAM execution because mapping is an interactive process
- Supports both quick testing and manual mapping with teleop
- Output files:
  - `maps/my_map.yaml`
  - `maps/my_map.pgm`

Pipeline Structure:

```text
slam_toolbox
    ↓ publish
/map
    ↓
map_saver_cli
    ↓ save
maps/my_map.yaml
maps/my_map.pgm
```

#### Run

First, run SLAM:

```bash
./scripts/run_02_slam.sh
```

Then choose one of the following options.

Option A: Quick test without manual movement

```text
In simple Gazebo worlds, a partial map may be generated from the initial LiDAR scan.
```

Option B: Move the robot with teleop

```bash
ros2 run teleop_twist_keyboard teleop_twist_keyboard
```

After the map is sufficiently generated, open another terminal and run:

```bash
./scripts/run_04_save_map.sh
```

---

## What You Learn

- Gazebo simulation with TurtleBot3
- ROS2 sensor topics and data flow
- SLAM (Simultaneous Localization and Mapping)
- Nav2 goal-based navigation
- RViz-based map and navigation visualization
- Relationship between `/map`, `/tf`, `/odom`, and `/cmd_vel`
- Basic autonomous robotics pipeline

---

## License

MIT License