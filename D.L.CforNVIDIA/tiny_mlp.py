import os
os.environ["CUDA_VISIBLE_DEVICES"] = ""  # Disable CUDA for export
import torch
import torch_mlir
from torch_mlir import fx as torch_mlir_fx

# Define a simple model
class TinyMLP(torch.nn.Module):
    def __init__(self):
        super().__init__()
        self.fc1 = torch.nn.Linear(4, 8)
        self.relu = torch.nn.ReLU()
        self.fc2 = torch.nn.Linear(8, 2)

    def forward(self, x):
        return self.fc2(self.relu(self.fc1(x)))

model = TinyMLP().eval()
example_input = torch.randn(1, 4)

# Torch-MLIR export 
mlir_module = torch_mlir_fx.export_and_import(model, example_input)

# Get MLIR as text
mlir_text = mlir_module.operation.get_asm()
print(mlir_text)

with open("tiny_mlp.mlir", "w") as f:
    f.write(mlir_text)


