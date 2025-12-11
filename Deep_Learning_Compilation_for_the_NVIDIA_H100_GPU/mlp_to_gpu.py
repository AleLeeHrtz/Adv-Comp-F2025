from mlir.ir import Context, Module
from mlir.passmanager import PassManager
from cuda import cuda
import sys

def detect_chip():
    try:
        err = cuda.cuInit(0)
        if err[0] != cuda.CUresult.CUDA_SUCCESS:
            print(f"CUDA initialization failed: {err}")
            return "sm_90"  # Default to H100
        
        err, dev = cuda.cuDeviceGet(0)
        if err != cuda.CUresult.CUDA_SUCCESS:
            print(f"Failed to get device: {err}")
            return "sm_90"
        
        err, major = cuda.cuDeviceGetAttribute(
            cuda.CUdevice_attribute.CU_DEVICE_ATTRIBUTE_COMPUTE_CAPABILITY_MAJOR, dev
        )
        err, minor = cuda.cuDeviceGetAttribute(
            cuda.CUdevice_attribute.CU_DEVICE_ATTRIBUTE_COMPUTE_CAPABILITY_MINOR, dev
        )
        
        chip = f"sm_{major}{minor}"
        return chip
    except Exception as e:
        print(f"Error detecting GPU: {e}")
        return "sm_90"  # Default to H100

def main():
    
    # Detect GPU architecture
    chip_type = detect_chip()
    print(f"\nDetected GPU architecture: {chip_type}")
    
    # Check if H100 or something else
    if chip_type == "sm_90":
        print("✓ Target: NVIDIA H100 (Hopper architecture)")
    else:
        print(f"⚠ Warning: Detected {chip_type}, but optimizing for H100 (sm_90)")
        chip_type = "sm_90"
    
    # Read the Linalg MLIR file
    input_file = "tiny_mlp_linalg.mlir"
    print(f"\nReading input file: {input_file}")
    
    try:
        with open(input_file, "r") as f:
            mlir_module_str = f.read()
        print(f"✓ Loaded {len(mlir_module_str):,} bytes")
    except FileNotFoundError:
        print(f"✗ ERROR: {input_file} not found!")
        sys.exit(1)
    
    print("\n" + "="*80)
    print("Applying MLIR transformation passes")
    print("="*80)
    
    with Context() as ctx:
        module = Module.parse(mlir_module_str)
        
        # Create pass manager
        pm = PassManager.parse(
            "builtin.module("
            "  canonicalize,"
            "  one-shot-bufferize{bufferize-function-boundaries function-boundary-type-conversion=identity-layout-map},"
            "  canonicalize,"
            "  convert-linalg-to-affine-loops,"
            "  func.func(affine-loop-invariant-code-motion),"
            "  func.func(convert-affine-for-to-gpu),"
            "  gpu-kernel-outlining,"
            "  lower-affine,"
            "  gpu-decompose-memrefs,"
            "  expand-strided-metadata,"
            "  normalize-memrefs,"
            f"  gpu.module(convert-gpu-to-nvvm{{index-bitwidth=0 use-bare-ptr-memref-call-conv}}),"
            f"  nvvm-attach-target{{chip={chip_type} features=+ptx80 O=3}},"
            "  convert-nvvm-to-llvm,"
            "  reconcile-unrealized-casts,"
            "  gpu-to-llvm{use-bare-pointers-for-host use-bare-pointers-for-kernels}"
            ")",
            context=ctx
        )
        
        # Enable IR printing to see transformations
        pm.enable_ir_printing()
        
        print("\nPass pipeline:")
        passes = [
            "1. canonicalize - Simplify IR",
            "2. one-shot-bufferize - Convert tensors to memrefs",
            "3. convert-linalg-to-affine-loops - Linalg -> Affine",
            "4. affine-loop-invariant-code-motion - Optimize loops",
            "5. convert-affine-for-to-gpu - Affine -> GPU kernels",
            "6. gpu-kernel-outlining - Extract GPU kernels",
            "7. lower-affine - Affine -> Standard",
            "8. gpu-decompose-memrefs - Prepare memory operations",
            "9. convert-gpu-to-nvvm - GPU dialect -> NVVM",
            f"10. nvvm-attach-target - Target {chip_type} with PTX 8.0",
            "11. convert-nvvm-to-llvm - NVVM -> LLVM IR",
            "12. gpu-to-llvm - Finalize GPU lowering"
        ]
        for p in passes:
            print(f"  {p}")
        
        print("\nRunning pass manager...")
        try:
            pm.run(module.operation)
            print("✓ All passes completed successfully!")
        except Exception as e:
            print(f"✗ ERROR during pass execution: {e}")
            import traceback
            traceback.print_exc()
            sys.exit(1)
        
        # Get final MLIR
        final_mlir = str(module)
        
        # Save to file
        output_file = "tiny_mlp_gpu.mlir"
        with open(output_file, "w") as f:
            f.write(final_mlir)
        
        print("\n" + "="*80)
        print("Output saved")
        print("="*80)
        print(f"✓ GPU-ready MLIR saved to: {output_file}")
        print(f"✓ File size: {len(final_mlir):,} bytes")
        
        # Show some statistics
        lines = final_mlir.split('\n')
        print(f"\nMLIR statistics:")
        print(f"  Total lines: {len(lines):,}")
        
        # Look for GPU kernels
        gpu_kernels = [l for l in lines if 'gpu.launch_func' in l or 'gpu.func' in l]
        print(f"  GPU kernel references: {len(gpu_kernels)}")
        
        # Look for NVVM/PTX indicators
        nvvm_ops = [l for l in lines if 'nvvm.' in l]
        print(f"  NVVM operations: {len(nvvm_ops)}")
        
        ptx_indicators = [l for l in lines if 'ptx' in l.lower()]
        print(f"  PTX indicators: {len(ptx_indicators)}")
        
        print("\n" + "="*80)
        
        # Print a sample of the output
        print("\n" + "="*80)
        print("Sample of final MLIR (first 30 lines):")
        print("="*80)
        for i, line in enumerate(lines[:30], 1):
            print(f"{i:3d}: {line}")
        if len(lines) > 30:
            print("...")
            print(f"({len(lines)-30} more lines)")

if __name__ == "__main__":
    main()
