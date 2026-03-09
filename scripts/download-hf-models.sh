#!/bin/bash

# Download Hugging Face CLI and selected models

ssh -t main@aipc.local " \
    echo 'Installing Hugging Face CLI and hf_transfer...' && \
    pip3 install huggingface_hub hf_transfer --break-system-packages && \
    echo 'Downloading Qwen3.5-122B-A10B-GGUF model from Hugging Face...' && \
    export HF_HUB_ENABLE_HF_TRANSFER=1 && \
    /home/main/.local/bin/hf download unsloth/Qwen3.5-122B-A10B-GGUF \
    --local-dir ~/models/Qwen3.5-122B-A10B-GGUF \
    --include Q4_K_M"