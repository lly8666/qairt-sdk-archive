#!/usr/bin/env bash
set -euo pipefail

: "${FOUNDATION_ROOT:?FOUNDATION_ROOT required}"
: "${MATRIX_ROOT:?MATRIX_ROOT required}"

export QNN_SDK_ROOT="$FOUNDATION_ROOT/qairt"
export QNN_BIN="$QNN_SDK_ROOT/bin/x86_64-linux-clang"
export QNN_LIB="$QNN_SDK_ROOT/lib/x86_64-linux-clang"
export PY310="$FOUNDATION_ROOT/python/bin/python3.10"
export PYTHONPATH="$FOUNDATION_ROOT/site-packages:$QNN_SDK_ROOT/lib/python${PYTHONPATH:+:$PYTHONPATH}"
export LD_LIBRARY_PATH="$FOUNDATION_ROOT/cxx:$FOUNDATION_ROOT/python/lib:$QNN_SDK_ROOT/bin/lib:$QNN_LIB${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export PATH="$QNN_BIN:$PATH"

case_dir() {
  case "$1" in
    A) echo "$MATRIX_ROOT/A_dynamic_erf" ;;
    B) echo "$MATRIX_ROOT/B_staticT4_erf" ;;
    C) echo "$MATRIX_ROOT/C_dynamic_canonicalGelu" ;;
    D) echo "$MATRIX_ROOT/D_staticT4_canonicalGelu" ;;
    *) return 2 ;;
  esac
}

run_case() {
  local id="$1" c dynamic=false
  c="$(case_dir "$id")"
  [ "$id" = A ] || [ "$id" = C ] || dynamic=true
  # Correct the boolean above: A/C are dynamic.
  if [ "$id" = A ] || [ "$id" = C ]; then dynamic=true; else dynamic=false; fi

  echo "=== QAIRT CASE $id dynamic=$dynamic ==="
  rm -rf "$c/model-lib" "$c/qnn_cpu" "$c/saver_capture" "$c/saver_run"
  rm -f "$c/model.cpp" "$c/model.bin" "$c/model_nosimp.cpp" "$c/model_nosimp.bin"

  local dyn_args=()
  if [ "$dynamic" = true ]; then
    dyn_args=(-d preact 1,4,1536 -d residual 1,320,4)
  fi

  set +e
  pushd "$c" >/dev/null
  "$PY310" "$QNN_BIN/qnn-onnx-converter" --input_network model.onnx --output_path model.cpp "${dyn_args[@]}" 2>&1 | tee converter.log
  local converter_rc=${PIPESTATUS[0]}
  popd >/dev/null
  set -e

  local converter_pass=false model_lib_pass=false cpu_pass=false saver_pass=false
  local nosimp_attempted=false nosimp_pass=false nosimp_rc=-1
  local model_so=""
  if [ "$converter_rc" -eq 0 ] && [ -s "$c/model.cpp" ]; then
    converter_pass=true
    local bin_args=(-c model.cpp -o model-lib -t x86_64-linux-clang)
    [ ! -s "$c/model.bin" ] || bin_args+=(-b model.bin)
    set +e
    pushd "$c" >/dev/null
    ( "$QNN_BIN/qnn-model-lib-generator" "${bin_args[@]}" || "$PY310" "$QNN_BIN/qnn-model-lib-generator" "${bin_args[@]}" ) 2>&1 | tee model-lib.log
    local lib_rc=${PIPESTATUS[0]}
    popd >/dev/null
    set -e
    if [ "$lib_rc" -eq 0 ]; then
      model_so="$(find "$c/model-lib" -type f -name '*.so' -print -quit || true)"
      if [ -n "$model_so" ]; then
        model_lib_pass=true
        model_so="$(realpath "$model_so")"
        set +e
        pushd "$c" >/dev/null
        "$QNN_BIN/qnn-net-run" --backend "$QNN_LIB/libQnnCpu.so" --model "$model_so" --input_list input_list.txt --output_dir qnn_cpu 2>&1 | tee qnn-cpu.log
        local cpu_rc=${PIPESTATUS[0]}
        popd >/dev/null
        set -e
        if [ "$cpu_rc" -eq 0 ] && [ "$(find "$c/qnn_cpu" -type f -name '*.raw' 2>/dev/null | wc -l)" -gt 0 ]; then
          cpu_pass=true
        fi

        set +e
        pushd "$c" >/dev/null
        QNN_SAVER_OUTPUT_DIR="$c/saver_capture" "$QNN_BIN/qnn-net-run" --backend "$QNN_LIB/libQnnSaver.so" --model "$model_so" --input_list input_list.txt --output_dir saver_run 2>&1 | tee saver.log
        local saver_rc=${PIPESTATUS[0]}
        popd >/dev/null
        set -e
        if [ "$saver_rc" -eq 0 ] && [ -s "$c/saver.log" ] && [ "$(find "$c/saver_capture" -type f 2>/dev/null | wc -l)" -gt 0 ]; then
          saver_pass=true
        fi
      fi
    fi
  else
    # Diagnostic-only secondary probe. It never upgrades the default-converter qualification.
    "$PY310" "$QNN_BIN/qnn-onnx-converter" --help > "$c/converter-help.txt" 2>&1 || true
    if grep -Fq -- '--no_simplification' "$c/converter-help.txt"; then
      nosimp_attempted=true
      set +e
      pushd "$c" >/dev/null
      "$PY310" "$QNN_BIN/qnn-onnx-converter" --input_network model.onnx --output_path model_nosimp.cpp --no_simplification "${dyn_args[@]}" 2>&1 | tee converter-nosimp.log
      nosimp_rc=${PIPESTATUS[0]}
      popd >/dev/null
      set -e
      if [ "$nosimp_rc" -eq 0 ] && [ -s "$c/model_nosimp.cpp" ]; then nosimp_pass=true; fi
    fi
  fi

  export CASE_ID="$id" CASE_DIR="$c" DYNAMIC_CASE="$dynamic"
  export CONVERTER_RC="$converter_rc" CONVERTER_PASS="$converter_pass"
  export MODEL_LIB_PASS="$model_lib_pass" CPU_PASS="$cpu_pass" SAVER_PASS="$saver_pass"
  export NOSIMP_ATTEMPTED="$nosimp_attempted" NOSIMP_PASS="$nosimp_pass" NOSIMP_RC="$nosimp_rc"
  "$PY310" - <<'PY'
import hashlib,json,os,pathlib,re
c=pathlib.Path(os.environ['CASE_DIR'])
def sha(p):
    if not p.is_file(): return None
    h=hashlib.sha256();
    with p.open('rb') as f:
        for b in iter(lambda:f.read(1<<20),b''): h.update(b)
    return h.hexdigest()
def text(p): return p.read_text(errors='replace') if p.is_file() else ''
conv=text(c/'converter.log'); nconv=text(c/'converter-nosimp.log')
needle="KeyError: '/backbone/convnext.4/Add_2_output_0'"
reason_lines=[]
for line in conv.splitlines():
    if any(k in line for k in ('KeyError','Erf','Cannot get shape','ERROR','Error')):
        reason_lines.append(line[-1200:])
status={
 'schema':4,
 'case':os.environ['CASE_ID'],
 'dynamic_case':os.environ['DYNAMIC_CASE']=='true',
 'converter_default_rc':int(os.environ['CONVERTER_RC']),
 'converter_default_pass':os.environ['CONVERTER_PASS']=='true',
 'converter_default_model_cpp':(c/'model.cpp').is_file() and (c/'model.cpp').stat().st_size>0,
 'converter_matmul_to_fc_keyerror':needle in conv,
 'converter_mentions_erf':'Erf' in conv or 'erf' in conv,
 'converter_mentions_cannot_get_shape':'Cannot get shape' in conv,
 'converter_reason_lines':reason_lines[:80],
 'no_simplification_attempted':os.environ['NOSIMP_ATTEMPTED']=='true',
 'no_simplification_rc':int(os.environ['NOSIMP_RC']),
 'no_simplification_pass':os.environ['NOSIMP_PASS']=='true',
 'no_simplification_matmul_to_fc_keyerror':needle in nconv,
 'model_lib_pass':os.environ['MODEL_LIB_PASS']=='true',
 'qnn_cpu_pass':os.environ['CPU_PASS']=='true',
 'qnn_cpu_raw_count':len(list((c/'qnn_cpu').rglob('*.raw'))) if (c/'qnn_cpu').exists() else 0,
 'saver_pass':os.environ['SAVER_PASS']=='true',
 'saver_capture_file_count':len([p for p in (c/'saver_capture').rglob('*') if p.is_file()]) if (c/'saver_capture').exists() else 0,
 'sha256':{k:sha(c/v) for k,v in {
   'model_onnx':'model.onnx','converter_log':'converter.log','converter_nosimp_log':'converter-nosimp.log',
   'model_cpp':'model.cpp','model_bin':'model.bin','model_lib_log':'model-lib.log','qnn_cpu_log':'qnn-cpu.log','saver_log':'saver.log'
 }.items()},
}
(c/'QAIRT_STATUS.json').write_text(json.dumps(status,indent=2,sort_keys=True)+'\n')
print('CASE_STATUS',status)
PY
}

for id in A B C D; do
  run_case "$id"
done

echo REV46_BLOCK4_GELU_2X2_QAIRT_CASES_COMPLETE
