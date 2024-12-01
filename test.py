#Ref: https://iree.dev/guides/ml-frameworks/tflite/#using-the-python-api

import jax
a = jax.numpy.asarray([1, 2, 3, 4, 5, 6, 7, 8, 9])
print(a + a)
