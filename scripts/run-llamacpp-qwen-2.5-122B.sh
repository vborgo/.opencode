#!/bin/bash

# Run llama.cpp server with Qwen3.5-122B-A10B-GGUF model on ASROCK TRX40, Threadripper 3960x, 128GB RAM, 2x RTX 3090 24GB
# When running, it will use the GPU as much as possible, but use the RAM to be able to load the whole model.

ssh -t main@aipc.local '
    echo "Running Qwen3.5-122B-A10B model ..." &&
    LLAMA_CACHE=/home/main/models llama-server \
    -hf unsloth/Qwen3.5-122B-A10B-GGUF:Q4_K_M \
    --alias "unsloth/Qwen3.5-122B-A10B" \
    -ngl 999 \
    --override-tensor "blk\..*\.ffn_(up|gate|down)_exps\.weight=CPU" \
    --tensor-split 22,22 \
    --ctx-size 262144 \
    --batch-size 1024 \
    --ubatch-size 512 \
    --threads 24 \
    --temp 0.6 \
    --top-p 0.95 \
    --top-k 20 \
    --min-p 0.00 \
    --presence-penalty 0.0 \
    --flash-attn on \
    --jinja \
    --chat-template-kwargs "{\"enable_thinking\":true}" \
    --host 0.0.0.0 \
    --port 8000'