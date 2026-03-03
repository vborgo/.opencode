#!/bin/bash

# Run docker on: ssh main@aipc.local
# Use: docker run -it vllm/vllm-openai:latest
# In Docker: vllm serve mistralai/Devstral-Small-2-24B-Instruct-2512 \
    # --max-model-len 262144 --tensor-parallel-size 2 \
    # --tool-call-parser mistral --enable-auto-tool-choice

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
    vllm/vllm-openai:latest \
    --model mistralai/Devstral-Small-2-24B-Instruct-2512 \
    --max-model-len 65536 \
    --max-num-batched-tokens 65536 \
    --tensor-parallel-size 2 \
    --tool-call-parser mistral \
    --enable-auto-tool-choice \
    --gpu-memory-utilization 0.92 \
    --max-num-seqs 1'