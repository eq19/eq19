#Ref: https://github.com/iree-org/iree/tree/main/integrations/pjrt

import jax
a = jax.numpy.asarray([1, 2, 3, 4, 5, 6, 7, 8, 9])
print(a + a)
