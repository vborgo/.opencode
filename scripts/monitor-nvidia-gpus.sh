#!/bin/bash

# NVIDIA GPU Monitoring Script for aipc.local
# Hardware: ASROCK TRX40, Threadripper 3960x, 128GB RAM, 2x RTX 3090 24GB
# Purpose: Monitor GPU utilization, memory usage, and temperature in real-time
# Usage: Run this script in the terminal to continuously monitor the GPUs

# Check if nvidia-smi is available
ssh -t main@aipc.local "watch -n 1 nvidia-smi"