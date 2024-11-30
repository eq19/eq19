import iree.compiler.tflite as iree_tflite_compile
import iree.runtime as iree_rt
import numpy
import os
import urllib.request

from PIL import Image

workdir = "/tmp/workdir"
os.makedirs(workdir, exist_ok=True)

tfliteFile = "/".join([workdir, "model.tflite"])
jpgFile = "/".join([workdir, "input.jpg"])
tfliteIR = "/".join([workdir, "tflite.mlir"])
tosaIR = "/".join([workdir, "tosa.mlir"])
bytecodeModule = "/".join([workdir, "iree.vmfb"])

backends = ["llvm-cpu"]
config = "local-task"
