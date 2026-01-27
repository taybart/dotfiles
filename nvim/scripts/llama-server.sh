#!/usr/bin/env zsh
# llama-server \
#     -hf ggml-org/Qwen2.5-Coder-3B-Q8_0-GGUF \
#     --port 8012 -ngl 99 -fa -ub 1024 -b 1024 \
#     --ctx-size 0 --cache-reuse 256
    # -hf ggml-org/Qwen2.5-Coder-3B-Q8_0-GGUF \
    # -hf ggml-org/Qwen2.5-Coder-1.5B-Q8_0-GGUF \
# llama-server --fim-qwen-1.5b-default
llama-server --fim-qwen-3b-default
