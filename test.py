#Ref: https://github.com/iree-org/iree/tree/main/integrations/pjrt
#Ref: https://mathworld.wolfram.com/GeneralizedGell-MannMatrix.html
#Ref: https://github.com/CQuIC/pysme/blob/master/src/pysme/gellmann.py
import numpy as np
a = np.array([
			[0, 1, 0],
			[1, 0, 0],
			[0, 0, 0],
		])
print(a + a)
