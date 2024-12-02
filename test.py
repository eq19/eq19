#Ref: https://mathworld.wolfram.com/GeneralizedGell-MannMatrix.html
#Ref: https://github.com/iree-org/iree/tree/main/integrations/pjrt

import numpy as np
a = np.array([
			[0, 1, 0],
			[1, 0, 0],
			[0, 0, 0],
		])
print(a + a)
