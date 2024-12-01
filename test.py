#Ref: https://github.com/iree-org/iree/tree/main/integrations/pjrt

import jax.numpy as jnp
a = jnp.array([
			[0, 1, 0],
			[1, 0, 0],
			[0, 0, 0],
		])
print(a + a)
