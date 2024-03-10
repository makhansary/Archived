import numpy as np
omg1=np.linspace(0.00001, 0.99999, 25)
rho12=[0.001, 0.01, 0.1, 0.25, 0.5, 0.75, 1, 1.5, 2, 5, 10]
for RHO12 in rho12:
    for OMG1 in omg1:
        Rn=1 + (1/RHO12 - 1) * (1/np.log(1/(1 - OMG1)) - (1 - OMG1)/OMG1)
        print (RHO12, OMG1, Rn)     