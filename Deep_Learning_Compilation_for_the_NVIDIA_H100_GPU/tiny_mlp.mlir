module {
  func.func @main(%arg0: !torch.vtensor<[1,4],f32>) -> !torch.vtensor<[1,2],f32> {
    %0 = torch.vtensor.literal(dense_resource<torch_tensor_8_4_torch.float32> : tensor<8x4xf32>) : !torch.vtensor<[8,4],f32>
    %1 = torch.vtensor.literal(dense_resource<torch_tensor_8_torch.float32> : tensor<8xf32>) : !torch.vtensor<[8],f32>
    %2 = torch.aten.linear %arg0, %0, %1 : !torch.vtensor<[1,4],f32>, !torch.vtensor<[8,4],f32>, !torch.vtensor<[8],f32> -> !torch.vtensor<[1,8],f32>
    %3 = torch.aten.relu %2 : !torch.vtensor<[1,8],f32> -> !torch.vtensor<[1,8],f32>
    %4 = torch.vtensor.literal(dense_resource<torch_tensor_2_8_torch.float32> : tensor<2x8xf32>) : !torch.vtensor<[2,8],f32>
    %5 = torch.vtensor.literal(dense_resource<torch_tensor_2_torch.float32> : tensor<2xf32>) : !torch.vtensor<[2],f32>
    %6 = torch.aten.linear %3, %4, %5 : !torch.vtensor<[1,8],f32>, !torch.vtensor<[2,8],f32>, !torch.vtensor<[2],f32> -> !torch.vtensor<[1,2],f32>
    return %6 : !torch.vtensor<[1,2],f32>
  }
}

{-#
  dialect_resources: {
    builtin: {
      torch_tensor_8_4_torch.float32: "0x04000000A0DC7B3E7442373E980D163E000055B8DC8D80BE20CB46BEA818B1BDC0DA8F3EB49CC4BEE047F9BE182BE13DD231D33EB0DA3FBE3C61293E6A6ABDBE88C1EFBEF00619BEE24EC3BE2EA2A33EAC20F1BE48AE08BEE8E49D3D06CC88BE70FD043EB4F7D13E9434E3BEA492C43EE667C5BE983194BEA257F13E7ECEAEBE4461ADBE",
      torch_tensor_8_torch.float32: "0x04000000B6A0C2BEC4F105BEF0E3813D1665F33ED2FEFF3EF627BDBE386DF5BD30DE65BD",
      torch_tensor_2_8_torch.float32: "0x04000000920E9EBEA26A7E3E62858A3E57E7B33E9385663E444D543E0BCA7B3EBF5772BEBA79ADBEFE0A8E3E6795EBBDC72AABBE50C97FBEC753F7BD71899FBE17EFC2BD",
      torch_tensor_2_torch.float32: "0x0400000014F7A2BDAA269DBD"
    }
  }
#-}
