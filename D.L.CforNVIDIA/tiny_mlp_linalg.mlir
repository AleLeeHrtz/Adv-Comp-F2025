#map = affine_map<(d0, d1) -> (d0, d1)>
#map1 = affine_map<(d0, d1) -> (d1)>
module {
  func.func @main(%arg0: tensor<1x4xf32>) -> tensor<1x2xf32> {
    %cst = arith.constant dense_resource<torch_tensor_8_torch.float32> : tensor<8xf32>
    %cst_0 = arith.constant 0.000000e+00 : f32
    %cst_1 = arith.constant dense_resource<torch_tensor_8_4_torch.float32> : tensor<8x4xf32>
    %cst_2 = arith.constant dense_resource<torch_tensor_2_8_torch.float32> : tensor<2x8xf32>
    %cst_3 = arith.constant dense_resource<torch_tensor_2_torch.float32> : tensor<2xf32>
    %0 = tensor.empty() : tensor<4x8xf32>
    %transposed = linalg.transpose ins(%cst_1 : tensor<8x4xf32>) outs(%0 : tensor<4x8xf32>) permutation = [1, 0] 
    %1 = tensor.empty() : tensor<1x8xf32>
    %2 = linalg.fill ins(%cst_0 : f32) outs(%1 : tensor<1x8xf32>) -> tensor<1x8xf32>
    %3 = linalg.matmul ins(%arg0, %transposed : tensor<1x4xf32>, tensor<4x8xf32>) outs(%2 : tensor<1x8xf32>) -> tensor<1x8xf32>
    %4 = linalg.generic {indexing_maps = [#map, #map1, #map], iterator_types = ["parallel", "parallel"]} ins(%3, %cst : tensor<1x8xf32>, tensor<8xf32>) outs(%1 : tensor<1x8xf32>) {
    ^bb0(%in: f32, %in_5: f32, %out: f32):
      %11 = arith.addf %in, %in_5 : f32
      linalg.yield %11 : f32
    } -> tensor<1x8xf32>
    %5 = linalg.generic {indexing_maps = [#map, #map], iterator_types = ["parallel", "parallel"]} ins(%4 : tensor<1x8xf32>) outs(%1 : tensor<1x8xf32>) {
    ^bb0(%in: f32, %out: f32):
      %11 = arith.cmpf ugt, %in, %cst_0 : f32
      %12 = arith.select %11, %in, %cst_0 : f32
      linalg.yield %12 : f32
    } -> tensor<1x8xf32>
    %6 = tensor.empty() : tensor<8x2xf32>
    %transposed_4 = linalg.transpose ins(%cst_2 : tensor<2x8xf32>) outs(%6 : tensor<8x2xf32>) permutation = [1, 0] 
    %7 = tensor.empty() : tensor<1x2xf32>
    %8 = linalg.fill ins(%cst_0 : f32) outs(%7 : tensor<1x2xf32>) -> tensor<1x2xf32>
    %9 = linalg.matmul ins(%5, %transposed_4 : tensor<1x8xf32>, tensor<8x2xf32>) outs(%8 : tensor<1x2xf32>) -> tensor<1x2xf32>
    %10 = linalg.generic {indexing_maps = [#map, #map1, #map], iterator_types = ["parallel", "parallel"]} ins(%9, %cst_3 : tensor<1x2xf32>, tensor<2xf32>) outs(%7 : tensor<1x2xf32>) {
    ^bb0(%in: f32, %in_5: f32, %out: f32):
      %11 = arith.addf %in, %in_5 : f32
      linalg.yield %11 : f32
    } -> tensor<1x2xf32>
    return %10 : tensor<1x2xf32>
  }
}

{-#
  dialect_resources: {
    builtin: {
      torch_tensor_8_torch.float32: "0x04000000B6A0C2BEC4F105BEF0E3813D1665F33ED2FEFF3EF627BDBE386DF5BD30DE65BD",
      torch_tensor_8_4_torch.float32: "0x04000000A0DC7B3E7442373E980D163E000055B8DC8D80BE20CB46BEA818B1BDC0DA8F3EB49CC4BEE047F9BE182BE13DD231D33EB0DA3FBE3C61293E6A6ABDBE88C1EFBEF00619BEE24EC3BE2EA2A33EAC20F1BE48AE08BEE8E49D3D06CC88BE70FD043EB4F7D13E9434E3BEA492C43EE667C5BE983194BEA257F13E7ECEAEBE4461ADBE",
      torch_tensor_2_8_torch.float32: "0x04000000920E9EBEA26A7E3E62858A3E57E7B33E9385663E444D543E0BCA7B3EBF5772BEBA79ADBEFE0A8E3E6795EBBDC72AABBE50C97FBEC753F7BD71899FBE17EFC2BD",
      torch_tensor_2_torch.float32: "0x0400000014F7A2BDAA269DBD"
    }
  }
#-}

