#!/bin/bash

# Hardware: ASROCK TRX40, Threadripper 3960x, 128GB RAM, 2x RTX 3090 24GB
# Install and build llama.cpp with CUDA and OpenBLAS optimizations for ASROCK TRX40, Threadripper 3960x, 128GB RAM, 2x RTX 3090 24GB

# Build with all optimizations
ssh -t main@aipc.local " \
    echo 'Installing dependencies...' && \
    sudo apt-get install build-essential cmake curl libcurl4-openssl-dev libssl-dev libopenblas-dev ccache -y && \
    echo '>> Cloning and building llama.cpp...' && \
    rm -rf llama.cpp && git clone https://github.com/ggml-org/llama.cpp && \
    echo 'Building llama.cpp with CUDA and OpenBLAS optimizations...' && \
    cmake llama.cpp -B llama.cpp/build \
        -DBUILD_SHARED_LIBS=OFF \
        -DGGML_CUDA=ON \
        -DGGML_NATIVE=ON \
        -DGGML_BLAS=ON \
        -DGGML_BLAS_VENDOR=OpenBLAS \
        -DLLAMA_OPENSSL=ON \
        -DCMAKE_BUILD_TYPE=Release && \
    echo '>> Compiling llama-server...' && \
    cmake --build llama.cpp/build --config Release \
        -j24 --clean-first \
        --target llama-server && \
    echo '>> Copying llama-server to /usr/local/bin...' && \
    sudo cp llama.cpp/build/bin/llama-server /usr/local/bin/"