
# ROS2 Gazebo Tutorial (hhjo_ros_gazebo_tutorial)

This repository demonstrates how to run a TurtleBot3 simulation in Gazebo using ROS2 Humble.


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


