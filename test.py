#Ref: https://github.com/iree-org/iree/tree/main/integrations/pjrt

import jax
a = jax.numpy.asarray([
			[0, 1, 0],
			[1, 0, 0],
			[0, 0, 0],
		])
print(a + a)
