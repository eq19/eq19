
#Ref: https://iree.dev/guides/ml-frameworks/tflite/#using-the-python-api

import tensorflow.compat.v2 as tf
loaded_model = tf.saved_model.load('/path/to/downloaded/model/')
print(list(loaded_model.signatures.keys()))
