import numpy as np
omg1=np.linspace(0.00001, 0.99999, 25)
betta=[-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1]
for BETTA in betta:
    for OMG1 in omg1:
        RHO12 = 1/(1 - BETTA * OMG1)
        Rn=1 + (1/RHO12 - 1) * (1/np.log(1/(1 - OMG1)) - (1 - OMG1)/OMG1)
        print (BETTA, RHO12, Rn)