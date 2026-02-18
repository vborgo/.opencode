#!/bin/bash

# Ollama Model Setup Script for aipc.local
# Hardware: ASROCK TRX40, Threadripper 3960x, 128GB RAM, 2x RTX 3090 24GB
# Strategy: Use quantized models (Q4_K_M) to keep multiple agents loaded simultaneously
# This eliminates loading delays and enables instant agent switching

set -e

# Point ollama commands to remote server
OLLAMA_HOST="http://aipc.local:11434"

echo "🚀 Setting up Ollama models on aipc.local..."
echo "Remote host: $OLLAMA_HOST"
echo "Hardware: 2x RTX 3090 (48GB VRAM), 128GB RAM, Threadripper 3960x"
echo "Strategy: Quantized models for multi-agent concurrency"
echo ""

# Always loaded:
PRIMARY_CODING_MODEL="qwen3-vl:32b"
FAST_CODING_MODEL="rnj-1:8b" # Instruction tunned by default

# Frequently used:
REASONING_MODEL="gpt-oss:20b"
#CODE_EXPLORATION_MODEL="devstral-small-2:24b" # Using PRIMARY_CODING_MODEL for code exploration

# On-demand loading:
FRONTEND_MODEL="codestral:22b"
#DOCUMENTATION_MODEL="qwen2.5:7b-instruct" # Lets use REASONING_MODEL for documentation
MULTIMODAL_MODEL="llava-phi3:3.8b" # Instruct by default

# Function to create optimized modelfile
create_optimized_model() {
    local base_model=$1
    local custom_name=$2
    local gpu_layers=$3
    local context_size=$4
    local description=$5
    
    echo "📥 Pulling $base_model ..."
    OLLAMA_HOST=$OLLAMA_HOST ollama pull $base_model

    echo "📦 Creating optimized model: $custom_name"
    
    cat > /tmp/Modelfile << EOF
FROM $base_model

# $description
PARAMETER num_ctx $context_size
PARAMETER num_gpu $gpu_layers
PARAMETER num_thread 24
PARAMETER num_batch 512

# More deterministic for PCB design accuracy
PARAMETER repeat_penalty 1.2
PARAMETER temperature 0.3
PARAMETER top_p 0.85
PARAMETER top_k 30

# System message for coding tasks
SYSTEM You are a highly skilled AI assistant specialized in software development and coding tasks.
EOF
    OLLAMA_HOST=$OLLAMA_HOST ollama create "$base_model-optimized" -f /tmp/Modelfile
    OLLAMA_HOST=$OLLAMA_HOST ollama create $custom_name -f /tmp/Modelfile
    
    echo "✅ Created: $custom_name" with $base_model"-optimized"
    echo ""
}

# create_optimized_model "base_model" "custom_name" "gpu_layers" "context_size" "description"
# Tier 1: Always loaded (most frequently used)
create_optimized_model "$PRIMARY_CODING_MODEL" "primary-coding-model" "100" "98304" "Sisyphus - Primary coding agent"
create_optimized_model "$FAST_CODING_MODEL"    "fast-coding-model"    "100" "32768" "Librarian - Fast code organization"

# Tier 2: Frequently used
create_optimized_model "$REASONING_MODEL"        "reasoning-model"        "100" "65536" "Oracle - Advanced reasoning"
#create_optimized_model "$CODE_EXPLORATION_MODEL" "code-exploration-model" "100" "98304" "Explore - Code exploration with large context"

# Tier 3: Load on-demand
create_optimized_model "$FRONTEND_MODEL"      "frontend-model"      "100" "32768" "Frontend UI/UX Engineer - Specialized frontend"
#create_optimized_model "$DOCUMENTATION_MODEL" "documentation-model" "100" "32768" "Document Writer - Efficient documentation"
create_optimized_model "$MULTIMODAL_MODEL"    "multimodal-model"    "100" "16384" "Multimodal Looker - Vision and image understanding"