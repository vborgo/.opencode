#!/bin/bash

# Hardware: ASROCK TRX40, Threadripper 3960x, 128GB RAM, 2x RTX 3090 24GB

# Run docker on: ssh main@aipc.local
# Use: docker run -it vllm/vllm-openai:nightly
# In Docker: vllm serve Qwen/Qwen3.5-27B --port 8000 --tensor-parallel-size 8 --max-model-len 262144 --reasoning-parser qwen3 --enable-auto-tool-choice --tool-call-parser qwen3_coder


ssh -t main@aipc.local ' \
    echo "Stopping any existing container on port 8000..." && \
    if docker ps -q --filter publish=8000 | grep -q .; then \
        docker stop $(docker ps -q --filter publish=8000); \
    fi && \
    echo "Starting new container with VLLM..." && \
    docker run --gpus all --ipc=host \
    -v /home/main/.cache/huggingface:/root/.cache/huggingface \
    -p 8000:8000 \
    -e VLLM_LOGGING_LEVEL=DEBUG \
    -e PYTORCH_ALLOC_CONF=expandable_segments:True \
    vllm/vllm-openai:nightly \
    --model Qwen/Qwen3.5-27B-FP8 \
    --tensor-parallel-size 2 \
    --max-model-len 131072 \
    --max-num-batched-tokens 32768 \
    --reasoning-parser qwen3 \
    --enable-auto-tool-choice \
    --tool-call-parser qwen3_coder \
    --language-model-only \
    --kv-cache-dtype fp8 \
    --gpu-memory-utilization 0.92 \
    --max-num-seqs 1'