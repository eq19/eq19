#Ref: https://iree.dev/guides/ml-frameworks/tflite/#using-the-python-api
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

#Ref: https://www.tensorflow.org/guide/saved_model
tfliteUrl = "https://storage.googleapis.com/download.tensorflow.org/data/ImageNetLabels.txt"
jpgUrl = "https://storage.googleapis.com/download.tensorflow.org/example_images/grace_hopper.jpg"

urllib.request.urlretrieve(tfliteUrl, tfliteFile)
urllib.request.urlretrieve(jpgUrl, jpgFile)

iree_tflite_compile.compile_file(
  tfliteFile,
  input_type="tosa",
  output_file=bytecodeModule,
  save_temp_tfl_input=tfliteIR,
  save_temp_iree_input=tosaIR,
  target_backends=backends,
  import_only=False)
