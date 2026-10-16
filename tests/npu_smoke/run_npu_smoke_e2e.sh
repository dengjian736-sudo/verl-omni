#!/usr/bin/env bash

set -euo pipefail

export NPU_SMOKE_GROUP=e2e
source "$(dirname "${BASH_SOURCE[0]}")/lib_npu_smoke.sh" "$@"

print_header
run_test 1 "FlowGRPO trainer e2e" \
    env ASCEND_RT_VISIBLE_DEVICES="${ASCEND_RT_VISIBLE_DEVICES}" NUM_NPUS="${NUM_NPUS}" \
        DATA_DIR="${DATA_DIR:-${LOG_DIR}/test1_data}" \
    bash tests/special_e2e/run_flowgrpo_qwen_image_npu.sh
WAN22_MODEL_PATH="${WAN22_MODEL_PATH:-${HOME}/.cache/models/tiny-random/Wan2.2-TI2V-5B-Diffusers}"
WAN22_DATA_DIR="${WAN22_DATA_DIR:-${LOG_DIR}/test2_data}"
run_test 2 "DanceGRPO Wan2.2 trainer e2e" \
    env ASCEND_RT_VISIBLE_DEVICES="${ASCEND_RT_VISIBLE_DEVICES}" NUM_NPUS="${NUM_NPUS}" \
        MODEL_PATH="${WAN22_MODEL_PATH}" \
        TOKENIZER_PATH="${WAN22_TOKENIZER_PATH:-${WAN22_MODEL_PATH}/tokenizer}" \
        DATA_DIR="${WAN22_DATA_DIR}" \
        TRAIN_FILES="${WAN22_TRAIN_FILES:-${WAN22_DATA_DIR}/train.parquet}" \
        VAL_FILES="${WAN22_VAL_FILES:-${WAN22_DATA_DIR}/test.parquet}" \
    bash tests/special_e2e/run_dancegrpo_wan22_npu.sh
cleanup_runtime
print_summary
