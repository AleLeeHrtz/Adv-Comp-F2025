module attributes {gpu.container_module} {
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.mlir.global private constant @__constant_2xf32(dense_resource<torch_tensor_2_torch.float32> : tensor<2xf32>) {addr_space = 0 : i32, alignment = 64 : i64} : !llvm.array<2 x f32>
  llvm.mlir.global private constant @__constant_2x8xf32(dense_resource<torch_tensor_2_8_torch.float32> : tensor<2x8xf32>) {addr_space = 0 : i32, alignment = 64 : i64} : !llvm.array<2 x array<8 x f32>>
  llvm.mlir.global private constant @__constant_8x4xf32(dense_resource<torch_tensor_8_4_torch.float32> : tensor<8x4xf32>) {addr_space = 0 : i32, alignment = 64 : i64} : !llvm.array<8 x array<4 x f32>>
  llvm.mlir.global private constant @__constant_8xf32(dense_resource<torch_tensor_8_torch.float32> : tensor<8xf32>) {addr_space = 0 : i32, alignment = 64 : i64} : !llvm.array<8 x f32>
  llvm.func @main(%arg0: !llvm.ptr) -> !llvm.ptr {
    %0 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %2 = llvm.insertvalue %arg0, %1[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %3 = llvm.mlir.constant(0 : index) : i64
    %4 = llvm.insertvalue %3, %2[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %5 = llvm.mlir.constant(1 : index) : i64
    %6 = llvm.insertvalue %5, %4[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %7 = llvm.mlir.constant(4 : index) : i64
    %8 = llvm.insertvalue %7, %6[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %9 = llvm.mlir.constant(4 : index) : i64
    %10 = llvm.insertvalue %9, %8[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %11 = llvm.mlir.constant(1 : index) : i64
    %12 = llvm.insertvalue %11, %10[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %13 = llvm.mlir.constant(2 : index) : i64
    %14 = llvm.mlir.constant(8 : index) : i64
    %15 = llvm.mlir.constant(1 : index) : i64
    %16 = llvm.mlir.constant(4 : index) : i64
    %17 = llvm.mlir.constant(0 : index) : i64
    %18 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %19 = llvm.mlir.constant(8 : index) : i64
    %20 = llvm.mlir.constant(1 : index) : i64
    %21 = llvm.mlir.zero : !llvm.ptr
    %22 = llvm.getelementptr %21[%19] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %23 = llvm.ptrtoint %22 : !llvm.ptr to i64
    %24 = llvm.mlir.addressof @__constant_8xf32 : !llvm.ptr
    %25 = llvm.getelementptr %24[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<8 x f32>
    %26 = llvm.mlir.constant(3735928559 : index) : i64
    %27 = llvm.inttoptr %26 : i64 to !llvm.ptr
    %28 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %29 = llvm.insertvalue %27, %28[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %30 = llvm.insertvalue %25, %29[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %31 = llvm.mlir.constant(0 : index) : i64
    %32 = llvm.insertvalue %31, %30[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %33 = llvm.insertvalue %19, %32[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %34 = llvm.insertvalue %20, %33[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %35 = llvm.mlir.constant(8 : index) : i64
    %36 = llvm.mlir.constant(4 : index) : i64
    %37 = llvm.mlir.constant(1 : index) : i64
    %38 = llvm.mlir.constant(32 : index) : i64
    %39 = llvm.mlir.zero : !llvm.ptr
    %40 = llvm.getelementptr %39[%38] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %41 = llvm.ptrtoint %40 : !llvm.ptr to i64
    %42 = llvm.mlir.addressof @__constant_8x4xf32 : !llvm.ptr
    %43 = llvm.getelementptr %42[0, 0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<8 x array<4 x f32>>
    %44 = llvm.mlir.constant(3735928559 : index) : i64
    %45 = llvm.inttoptr %44 : i64 to !llvm.ptr
    %46 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %47 = llvm.insertvalue %45, %46[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %48 = llvm.insertvalue %43, %47[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %49 = llvm.mlir.constant(0 : index) : i64
    %50 = llvm.insertvalue %49, %48[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %51 = llvm.insertvalue %35, %50[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %52 = llvm.insertvalue %36, %51[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %53 = llvm.insertvalue %36, %52[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %54 = llvm.insertvalue %37, %53[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %55 = llvm.mlir.constant(2 : index) : i64
    %56 = llvm.mlir.constant(8 : index) : i64
    %57 = llvm.mlir.constant(1 : index) : i64
    %58 = llvm.mlir.constant(16 : index) : i64
    %59 = llvm.mlir.zero : !llvm.ptr
    %60 = llvm.getelementptr %59[%58] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %61 = llvm.ptrtoint %60 : !llvm.ptr to i64
    %62 = llvm.mlir.addressof @__constant_2x8xf32 : !llvm.ptr
    %63 = llvm.getelementptr %62[0, 0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<2 x array<8 x f32>>
    %64 = llvm.mlir.constant(3735928559 : index) : i64
    %65 = llvm.inttoptr %64 : i64 to !llvm.ptr
    %66 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %67 = llvm.insertvalue %65, %66[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %68 = llvm.insertvalue %63, %67[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %69 = llvm.mlir.constant(0 : index) : i64
    %70 = llvm.insertvalue %69, %68[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %71 = llvm.insertvalue %55, %70[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %72 = llvm.insertvalue %56, %71[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %73 = llvm.insertvalue %56, %72[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %74 = llvm.insertvalue %57, %73[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %75 = llvm.mlir.constant(2 : index) : i64
    %76 = llvm.mlir.constant(1 : index) : i64
    %77 = llvm.mlir.zero : !llvm.ptr
    %78 = llvm.getelementptr %77[%75] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %79 = llvm.ptrtoint %78 : !llvm.ptr to i64
    %80 = llvm.mlir.addressof @__constant_2xf32 : !llvm.ptr
    %81 = llvm.getelementptr %80[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<2 x f32>
    %82 = llvm.mlir.constant(3735928559 : index) : i64
    %83 = llvm.inttoptr %82 : i64 to !llvm.ptr
    %84 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %85 = llvm.insertvalue %83, %84[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %86 = llvm.insertvalue %81, %85[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %87 = llvm.mlir.constant(0 : index) : i64
    %88 = llvm.insertvalue %87, %86[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %89 = llvm.insertvalue %75, %88[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %90 = llvm.insertvalue %76, %89[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %91 = llvm.mlir.constant(4 : index) : i64
    %92 = llvm.mlir.constant(8 : index) : i64
    %93 = llvm.mlir.constant(1 : index) : i64
    %94 = llvm.mlir.constant(32 : index) : i64
    %95 = llvm.mlir.zero : !llvm.ptr
    %96 = llvm.getelementptr %95[%94] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %97 = llvm.ptrtoint %96 : !llvm.ptr to i64
    %98 = llvm.mlir.constant(64 : index) : i64
    %99 = llvm.add %97, %98 : i64
    %100 = llvm.call @malloc(%99) : (i64) -> !llvm.ptr
    %101 = llvm.ptrtoint %100 : !llvm.ptr to i64
    %102 = llvm.mlir.constant(1 : index) : i64
    %103 = llvm.sub %98, %102 : i64
    %104 = llvm.add %101, %103 : i64
    %105 = llvm.urem %104, %98 : i64
    %106 = llvm.sub %104, %105 : i64
    %107 = llvm.inttoptr %106 : i64 to !llvm.ptr
    %108 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %109 = llvm.insertvalue %100, %108[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %110 = llvm.insertvalue %107, %109[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %111 = llvm.mlir.constant(0 : index) : i64
    %112 = llvm.insertvalue %111, %110[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %113 = llvm.insertvalue %91, %112[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %114 = llvm.insertvalue %92, %113[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %115 = llvm.insertvalue %92, %114[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %116 = llvm.insertvalue %93, %115[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %117 = llvm.extractvalue %54[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %118 = llvm.extractvalue %116[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    gpu.launch_func  @main_kernel::@main_kernel blocks in (%16, %15, %15) threads in (%14, %15, %15) : i64 args(%17 : i64, %17 : i64, %117 : !llvm.ptr, %118 : !llvm.ptr)
    %119 = llvm.mlir.constant(1 : index) : i64
    %120 = llvm.mlir.constant(8 : index) : i64
    %121 = llvm.mlir.constant(1 : index) : i64
    %122 = llvm.mlir.constant(8 : index) : i64
    %123 = llvm.mlir.zero : !llvm.ptr
    %124 = llvm.getelementptr %123[%122] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %125 = llvm.ptrtoint %124 : !llvm.ptr to i64
    %126 = llvm.mlir.constant(64 : index) : i64
    %127 = llvm.add %125, %126 : i64
    %128 = llvm.call @malloc(%127) : (i64) -> !llvm.ptr
    %129 = llvm.ptrtoint %128 : !llvm.ptr to i64
    %130 = llvm.mlir.constant(1 : index) : i64
    %131 = llvm.sub %126, %130 : i64
    %132 = llvm.add %129, %131 : i64
    %133 = llvm.urem %132, %126 : i64
    %134 = llvm.sub %132, %133 : i64
    %135 = llvm.inttoptr %134 : i64 to !llvm.ptr
    %136 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %137 = llvm.insertvalue %128, %136[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %138 = llvm.insertvalue %135, %137[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %139 = llvm.mlir.constant(0 : index) : i64
    %140 = llvm.insertvalue %139, %138[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %141 = llvm.insertvalue %119, %140[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %142 = llvm.insertvalue %120, %141[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %143 = llvm.insertvalue %120, %142[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %144 = llvm.insertvalue %121, %143[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %145 = llvm.extractvalue %144[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    gpu.launch_func  @main_kernel_0::@main_kernel blocks in (%15, %15, %15) threads in (%14, %15, %15) : i64 args(%17 : i64, %17 : i64, %18 : f32, %145 : !llvm.ptr)
    %146 = llvm.extractvalue %12[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %147 = llvm.extractvalue %116[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %148 = llvm.extractvalue %144[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    gpu.launch_func  @main_kernel_1::@main_kernel blocks in (%15, %15, %15) threads in (%14, %15, %15) : i64 args(%17 : i64, %17 : i64, %146 : !llvm.ptr, %147 : !llvm.ptr, %148 : !llvm.ptr)
    %149 = llvm.extractvalue %144[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %150 = llvm.extractvalue %34[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    gpu.launch_func  @main_kernel_2::@main_kernel blocks in (%15, %15, %15) threads in (%14, %15, %15) : i64 args(%17 : i64, %17 : i64, %149 : !llvm.ptr, %150 : !llvm.ptr)
    %151 = llvm.extractvalue %144[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    gpu.launch_func  @main_kernel_3::@main_kernel blocks in (%15, %15, %15) threads in (%14, %15, %15) : i64 args(%17 : i64, %17 : i64, %151 : !llvm.ptr, %18 : f32)
    %152 = llvm.mlir.constant(8 : index) : i64
    %153 = llvm.mlir.constant(2 : index) : i64
    %154 = llvm.mlir.constant(1 : index) : i64
    %155 = llvm.mlir.constant(16 : index) : i64
    %156 = llvm.mlir.zero : !llvm.ptr
    %157 = llvm.getelementptr %156[%155] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %158 = llvm.ptrtoint %157 : !llvm.ptr to i64
    %159 = llvm.mlir.constant(64 : index) : i64
    %160 = llvm.add %158, %159 : i64
    %161 = llvm.call @malloc(%160) : (i64) -> !llvm.ptr
    %162 = llvm.ptrtoint %161 : !llvm.ptr to i64
    %163 = llvm.mlir.constant(1 : index) : i64
    %164 = llvm.sub %159, %163 : i64
    %165 = llvm.add %162, %164 : i64
    %166 = llvm.urem %165, %159 : i64
    %167 = llvm.sub %165, %166 : i64
    %168 = llvm.inttoptr %167 : i64 to !llvm.ptr
    %169 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %170 = llvm.insertvalue %161, %169[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %171 = llvm.insertvalue %168, %170[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %172 = llvm.mlir.constant(0 : index) : i64
    %173 = llvm.insertvalue %172, %171[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %174 = llvm.insertvalue %152, %173[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %175 = llvm.insertvalue %153, %174[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %176 = llvm.insertvalue %153, %175[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %177 = llvm.insertvalue %154, %176[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %178 = llvm.extractvalue %74[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %179 = llvm.extractvalue %177[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    gpu.launch_func  @main_kernel_4::@main_kernel blocks in (%14, %15, %15) threads in (%13, %15, %15) : i64 args(%17 : i64, %17 : i64, %178 : !llvm.ptr, %179 : !llvm.ptr)
    %180 = llvm.mlir.constant(1 : index) : i64
    %181 = llvm.mlir.constant(2 : index) : i64
    %182 = llvm.mlir.constant(1 : index) : i64
    %183 = llvm.mlir.constant(2 : index) : i64
    %184 = llvm.mlir.zero : !llvm.ptr
    %185 = llvm.getelementptr %184[%183] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %186 = llvm.ptrtoint %185 : !llvm.ptr to i64
    %187 = llvm.mlir.constant(64 : index) : i64
    %188 = llvm.add %186, %187 : i64
    %189 = llvm.call @malloc(%188) : (i64) -> !llvm.ptr
    %190 = llvm.ptrtoint %189 : !llvm.ptr to i64
    %191 = llvm.mlir.constant(1 : index) : i64
    %192 = llvm.sub %187, %191 : i64
    %193 = llvm.add %190, %192 : i64
    %194 = llvm.urem %193, %187 : i64
    %195 = llvm.sub %193, %194 : i64
    %196 = llvm.inttoptr %195 : i64 to !llvm.ptr
    %197 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %198 = llvm.insertvalue %189, %197[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %199 = llvm.insertvalue %196, %198[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %200 = llvm.mlir.constant(0 : index) : i64
    %201 = llvm.insertvalue %200, %199[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %202 = llvm.insertvalue %180, %201[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %203 = llvm.insertvalue %181, %202[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %204 = llvm.insertvalue %181, %203[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %205 = llvm.insertvalue %182, %204[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %206 = llvm.extractvalue %205[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    gpu.launch_func  @main_kernel_5::@main_kernel blocks in (%15, %15, %15) threads in (%13, %15, %15) : i64 args(%17 : i64, %17 : i64, %18 : f32, %206 : !llvm.ptr)
    %207 = llvm.extractvalue %144[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %208 = llvm.extractvalue %177[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %209 = llvm.extractvalue %205[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    gpu.launch_func  @main_kernel_6::@main_kernel blocks in (%15, %15, %15) threads in (%13, %15, %15) : i64 args(%17 : i64, %17 : i64, %207 : !llvm.ptr, %208 : !llvm.ptr, %209 : !llvm.ptr)
    %210 = llvm.extractvalue %205[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %211 = llvm.extractvalue %90[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    gpu.launch_func  @main_kernel_7::@main_kernel blocks in (%15, %15, %15) threads in (%13, %15, %15) : i64 args(%17 : i64, %17 : i64, %210 : !llvm.ptr, %211 : !llvm.ptr)
    %212 = llvm.extractvalue %205[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.return %212 : !llvm.ptr
  }
  gpu.module @main_kernel [#nvvm.target<O = 3, chip = "sm_90", features = "+ptx80">] {
    llvm.func @main_kernel(%arg0: i64, %arg1: i64, %arg2: !llvm.ptr, %arg3: !llvm.ptr) attributes {gpu.kernel, nvvm.kernel} {
      %0 = llvm.mlir.constant(8 : index) : i64
      %1 = llvm.mlir.constant(4 : index) : i64
      %2 = nvvm.read.ptx.sreg.ctaid.x : i32
      %3 = llvm.sext %2 : i32 to i64
      %4 = nvvm.read.ptx.sreg.tid.x : i32
      %5 = llvm.sext %4 : i32 to i64
      %6 = llvm.add %arg0, %3 : i64
      %7 = llvm.add %arg1, %5 : i64
      %8 = llvm.mul %7, %1 overflow<nsw, nuw> : i64
      %9 = llvm.add %8, %6 overflow<nsw, nuw> : i64
      %10 = llvm.getelementptr inbounds|nuw %arg2[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %11 = llvm.load %10 : !llvm.ptr -> f32
      %12 = llvm.mul %6, %0 overflow<nsw, nuw> : i64
      %13 = llvm.add %12, %7 overflow<nsw, nuw> : i64
      %14 = llvm.getelementptr inbounds|nuw %arg3[%13] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %11, %14 : f32, !llvm.ptr
      llvm.return
    }
  }
  gpu.module @main_kernel_0 [#nvvm.target<O = 3, chip = "sm_90", features = "+ptx80">] {
    llvm.func @main_kernel(%arg0: i64, %arg1: i64, %arg2: f32, %arg3: !llvm.ptr) attributes {gpu.kernel, nvvm.kernel} {
      %0 = llvm.mlir.constant(8 : index) : i64
      %1 = nvvm.read.ptx.sreg.ctaid.x : i32
      %2 = llvm.sext %1 : i32 to i64
      %3 = nvvm.read.ptx.sreg.tid.x : i32
      %4 = llvm.sext %3 : i32 to i64
      %5 = llvm.add %arg0, %2 : i64
      %6 = llvm.add %arg1, %4 : i64
      %7 = llvm.mul %5, %0 overflow<nsw, nuw> : i64
      %8 = llvm.add %7, %6 overflow<nsw, nuw> : i64
      %9 = llvm.getelementptr inbounds|nuw %arg3[%8] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %arg2, %9 : f32, !llvm.ptr
      llvm.return
    }
  }
  gpu.module @main_kernel_1 [#nvvm.target<O = 3, chip = "sm_90", features = "+ptx80">] {
    llvm.func @main_kernel(%arg0: i64, %arg1: i64, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr) attributes {gpu.kernel, nvvm.kernel} {
      %0 = llvm.mlir.constant(4 : index) : i64
      %1 = llvm.mlir.constant(8 : index) : i64
      %2 = llvm.mlir.constant(1 : index) : i64
      %3 = llvm.mlir.constant(0 : index) : i64
      %4 = builtin.unrealized_conversion_cast %2 : i64 to index
      %5 = builtin.unrealized_conversion_cast %0 : i64 to index
      %6 = builtin.unrealized_conversion_cast %3 : i64 to index
      %7 = nvvm.read.ptx.sreg.ctaid.x : i32
      %8 = llvm.sext %7 : i32 to i64
      %9 = nvvm.read.ptx.sreg.tid.x : i32
      %10 = llvm.sext %9 : i32 to i64
      %11 = llvm.add %arg0, %8 : i64
      %12 = llvm.add %arg1, %10 : i64
      scf.for %arg5 = %6 to %5 step %4 {
        %13 = builtin.unrealized_conversion_cast %arg5 : index to i64
        %14 = llvm.mul %11, %0 overflow<nsw, nuw> : i64
        %15 = llvm.add %14, %13 overflow<nsw, nuw> : i64
        %16 = llvm.getelementptr inbounds|nuw %arg2[%15] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %17 = llvm.load %16 : !llvm.ptr -> f32
        %18 = llvm.mul %13, %1 overflow<nsw, nuw> : i64
        %19 = llvm.add %18, %12 overflow<nsw, nuw> : i64
        %20 = llvm.getelementptr inbounds|nuw %arg3[%19] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %21 = llvm.load %20 : !llvm.ptr -> f32
        %22 = llvm.mul %11, %1 overflow<nsw, nuw> : i64
        %23 = llvm.add %22, %12 overflow<nsw, nuw> : i64
        %24 = llvm.getelementptr inbounds|nuw %arg4[%23] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %25 = llvm.load %24 : !llvm.ptr -> f32
        %26 = llvm.fmul %17, %21 : f32
        %27 = llvm.fadd %25, %26 : f32
        %28 = llvm.mul %11, %1 overflow<nsw, nuw> : i64
        %29 = llvm.add %28, %12 overflow<nsw, nuw> : i64
        %30 = llvm.getelementptr inbounds|nuw %arg4[%29] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        llvm.store %27, %30 : f32, !llvm.ptr
      }
      llvm.return
    }
  }
  gpu.module @main_kernel_2 [#nvvm.target<O = 3, chip = "sm_90", features = "+ptx80">] {
    llvm.func @main_kernel(%arg0: i64, %arg1: i64, %arg2: !llvm.ptr, %arg3: !llvm.ptr) attributes {gpu.kernel, nvvm.kernel} {
      %0 = llvm.mlir.constant(8 : index) : i64
      %1 = nvvm.read.ptx.sreg.ctaid.x : i32
      %2 = llvm.sext %1 : i32 to i64
      %3 = nvvm.read.ptx.sreg.tid.x : i32
      %4 = llvm.sext %3 : i32 to i64
      %5 = llvm.add %arg0, %2 : i64
      %6 = llvm.add %arg1, %4 : i64
      %7 = llvm.mul %5, %0 overflow<nsw, nuw> : i64
      %8 = llvm.add %7, %6 overflow<nsw, nuw> : i64
      %9 = llvm.getelementptr inbounds|nuw %arg2[%8] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %10 = llvm.load %9 : !llvm.ptr -> f32
      %11 = llvm.getelementptr inbounds|nuw %arg3[%6] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %12 = llvm.load %11 : !llvm.ptr -> f32
      %13 = llvm.fadd %10, %12 : f32
      %14 = llvm.mul %5, %0 overflow<nsw, nuw> : i64
      %15 = llvm.add %14, %6 overflow<nsw, nuw> : i64
      %16 = llvm.getelementptr inbounds|nuw %arg2[%15] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %13, %16 : f32, !llvm.ptr
      llvm.return
    }
  }
  gpu.module @main_kernel_3 [#nvvm.target<O = 3, chip = "sm_90", features = "+ptx80">] {
    llvm.func @main_kernel(%arg0: i64, %arg1: i64, %arg2: !llvm.ptr, %arg3: f32) attributes {gpu.kernel, nvvm.kernel} {
      %0 = llvm.mlir.constant(8 : index) : i64
      %1 = nvvm.read.ptx.sreg.ctaid.x : i32
      %2 = llvm.sext %1 : i32 to i64
      %3 = nvvm.read.ptx.sreg.tid.x : i32
      %4 = llvm.sext %3 : i32 to i64
      %5 = llvm.add %arg0, %2 : i64
      %6 = llvm.add %arg1, %4 : i64
      %7 = llvm.mul %5, %0 overflow<nsw, nuw> : i64
      %8 = llvm.add %7, %6 overflow<nsw, nuw> : i64
      %9 = llvm.getelementptr inbounds|nuw %arg2[%8] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %10 = llvm.load %9 : !llvm.ptr -> f32
      %11 = llvm.fcmp "ugt" %10, %arg3 : f32
      %12 = llvm.select %11, %10, %arg3 : i1, f32
      %13 = llvm.mul %5, %0 overflow<nsw, nuw> : i64
      %14 = llvm.add %13, %6 overflow<nsw, nuw> : i64
      %15 = llvm.getelementptr inbounds|nuw %arg2[%14] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %12, %15 : f32, !llvm.ptr
      llvm.return
    }
  }
  gpu.module @main_kernel_4 [#nvvm.target<O = 3, chip = "sm_90", features = "+ptx80">] {
    llvm.func @main_kernel(%arg0: i64, %arg1: i64, %arg2: !llvm.ptr, %arg3: !llvm.ptr) attributes {gpu.kernel, nvvm.kernel} {
      %0 = llvm.mlir.constant(2 : index) : i64
      %1 = llvm.mlir.constant(8 : index) : i64
      %2 = nvvm.read.ptx.sreg.ctaid.x : i32
      %3 = llvm.sext %2 : i32 to i64
      %4 = nvvm.read.ptx.sreg.tid.x : i32
      %5 = llvm.sext %4 : i32 to i64
      %6 = llvm.add %arg0, %3 : i64
      %7 = llvm.add %arg1, %5 : i64
      %8 = llvm.mul %7, %1 overflow<nsw, nuw> : i64
      %9 = llvm.add %8, %6 overflow<nsw, nuw> : i64
      %10 = llvm.getelementptr inbounds|nuw %arg2[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %11 = llvm.load %10 : !llvm.ptr -> f32
      %12 = llvm.mul %6, %0 overflow<nsw, nuw> : i64
      %13 = llvm.add %12, %7 overflow<nsw, nuw> : i64
      %14 = llvm.getelementptr inbounds|nuw %arg3[%13] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %11, %14 : f32, !llvm.ptr
      llvm.return
    }
  }
  gpu.module @main_kernel_5 [#nvvm.target<O = 3, chip = "sm_90", features = "+ptx80">] {
    llvm.func @main_kernel(%arg0: i64, %arg1: i64, %arg2: f32, %arg3: !llvm.ptr) attributes {gpu.kernel, nvvm.kernel} {
      %0 = llvm.mlir.constant(2 : index) : i64
      %1 = nvvm.read.ptx.sreg.ctaid.x : i32
      %2 = llvm.sext %1 : i32 to i64
      %3 = nvvm.read.ptx.sreg.tid.x : i32
      %4 = llvm.sext %3 : i32 to i64
      %5 = llvm.add %arg0, %2 : i64
      %6 = llvm.add %arg1, %4 : i64
      %7 = llvm.mul %5, %0 overflow<nsw, nuw> : i64
      %8 = llvm.add %7, %6 overflow<nsw, nuw> : i64
      %9 = llvm.getelementptr inbounds|nuw %arg3[%8] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %arg2, %9 : f32, !llvm.ptr
      llvm.return
    }
  }
  gpu.module @main_kernel_6 [#nvvm.target<O = 3, chip = "sm_90", features = "+ptx80">] {
    llvm.func @main_kernel(%arg0: i64, %arg1: i64, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr) attributes {gpu.kernel, nvvm.kernel} {
      %0 = llvm.mlir.constant(8 : index) : i64
      %1 = llvm.mlir.constant(2 : index) : i64
      %2 = llvm.mlir.constant(1 : index) : i64
      %3 = llvm.mlir.constant(0 : index) : i64
      %4 = builtin.unrealized_conversion_cast %2 : i64 to index
      %5 = builtin.unrealized_conversion_cast %0 : i64 to index
      %6 = builtin.unrealized_conversion_cast %3 : i64 to index
      %7 = nvvm.read.ptx.sreg.ctaid.x : i32
      %8 = llvm.sext %7 : i32 to i64
      %9 = nvvm.read.ptx.sreg.tid.x : i32
      %10 = llvm.sext %9 : i32 to i64
      %11 = llvm.add %arg0, %8 : i64
      %12 = llvm.add %arg1, %10 : i64
      scf.for %arg5 = %6 to %5 step %4 {
        %13 = builtin.unrealized_conversion_cast %arg5 : index to i64
        %14 = llvm.mul %11, %0 overflow<nsw, nuw> : i64
        %15 = llvm.add %14, %13 overflow<nsw, nuw> : i64
        %16 = llvm.getelementptr inbounds|nuw %arg2[%15] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %17 = llvm.load %16 : !llvm.ptr -> f32
        %18 = llvm.mul %13, %1 overflow<nsw, nuw> : i64
        %19 = llvm.add %18, %12 overflow<nsw, nuw> : i64
        %20 = llvm.getelementptr inbounds|nuw %arg3[%19] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %21 = llvm.load %20 : !llvm.ptr -> f32
        %22 = llvm.mul %11, %1 overflow<nsw, nuw> : i64
        %23 = llvm.add %22, %12 overflow<nsw, nuw> : i64
        %24 = llvm.getelementptr inbounds|nuw %arg4[%23] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        %25 = llvm.load %24 : !llvm.ptr -> f32
        %26 = llvm.fmul %17, %21 : f32
        %27 = llvm.fadd %25, %26 : f32
        %28 = llvm.mul %11, %1 overflow<nsw, nuw> : i64
        %29 = llvm.add %28, %12 overflow<nsw, nuw> : i64
        %30 = llvm.getelementptr inbounds|nuw %arg4[%29] : (!llvm.ptr, i64) -> !llvm.ptr, f32
        llvm.store %27, %30 : f32, !llvm.ptr
      }
      llvm.return
    }
  }
  gpu.module @main_kernel_7 [#nvvm.target<O = 3, chip = "sm_90", features = "+ptx80">] {
    llvm.func @main_kernel(%arg0: i64, %arg1: i64, %arg2: !llvm.ptr, %arg3: !llvm.ptr) attributes {gpu.kernel, nvvm.kernel} {
      %0 = llvm.mlir.constant(2 : index) : i64
      %1 = nvvm.read.ptx.sreg.ctaid.x : i32
      %2 = llvm.sext %1 : i32 to i64
      %3 = nvvm.read.ptx.sreg.tid.x : i32
      %4 = llvm.sext %3 : i32 to i64
      %5 = llvm.add %arg0, %2 : i64
      %6 = llvm.add %arg1, %4 : i64
      %7 = llvm.mul %5, %0 overflow<nsw, nuw> : i64
      %8 = llvm.add %7, %6 overflow<nsw, nuw> : i64
      %9 = llvm.getelementptr inbounds|nuw %arg2[%8] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %10 = llvm.load %9 : !llvm.ptr -> f32
      %11 = llvm.getelementptr inbounds|nuw %arg3[%6] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      %12 = llvm.load %11 : !llvm.ptr -> f32
      %13 = llvm.fadd %10, %12 : f32
      %14 = llvm.mul %5, %0 overflow<nsw, nuw> : i64
      %15 = llvm.add %14, %6 overflow<nsw, nuw> : i64
      %16 = llvm.getelementptr inbounds|nuw %arg2[%15] : (!llvm.ptr, i64) -> !llvm.ptr, f32
      llvm.store %13, %16 : f32, !llvm.ptr
      llvm.return
    }
  }
}

{-#
  dialect_resources: {
    builtin: {
      torch_tensor_2_torch.float32: "0x0400000014F7A2BDAA269DBD",
      torch_tensor_2_8_torch.float32: "0x04000000920E9EBEA26A7E3E62858A3E57E7B33E9385663E444D543E0BCA7B3EBF5772BEBA79ADBEFE0A8E3E6795EBBDC72AABBE50C97FBEC753F7BD71899FBE17EFC2BD",
      torch_tensor_8_4_torch.float32: "0x04000000A0DC7B3E7442373E980D163E000055B8DC8D80BE20CB46BEA818B1BDC0DA8F3EB49CC4BEE047F9BE182BE13DD231D33EB0DA3FBE3C61293E6A6ABDBE88C1EFBEF00619BEE24EC3BE2EA2A33EAC20F1BE48AE08BEE8E49D3D06CC88BE70FD043EB4F7D13E9434E3BEA492C43EE667C5BE983194BEA257F13E7ECEAEBE4461ADBE",
      torch_tensor_8_torch.float32: "0x04000000B6A0C2BEC4F105BEF0E3813D1665F33ED2FEFF3EF627BDBE386DF5BD30DE65BD"
    }
  }
#-}
