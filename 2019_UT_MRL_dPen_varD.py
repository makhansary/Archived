##############################
# MAK 
# python3
# varD.py
# (in)finite penetration depth : varying D
##############################
import numpy as np
import math
##############################
# test data 
L=1 # wall lenght 
gamma=0.05 # film flow rate kg/m.s 
#um=0.21 # maximum flow velocity 
#u=um*2/3 # average flow velocity 
cA0=0 # initial concentration 
cAi=0.0366 # interfacial concentration
#D=1.96/1000000000 # diffusivity 
var=[1.0, 2.0, 2.5, 5.0, 7.0, 8.0, 9.0]
varD=[vard/1000000000 for vard in var] 
##############################
Rho=998 # kg/m3
Mue=0.000894 # kg/m.s at STP
g=9.807 # m/s2
##############################
#Z=[0.01, 0.05, 0.1, 0.2, 0.5, 1, 1.5, 2, 2.4]
#Z=[z/10000 for z in Z] 
# y-coordinate 
YY=[0.00000000001, 0.0000000001, 0.000000001, 0.00000001, 0.0000001, 0.000001, 0.00001, 0.0001, 0.001, 0.01, 0.05, 0.1, 0.25, 0.5, 0.75, 1]
Y=[L*y for y in YY] 
# film thickness 
delta=((3*Mue*gamma)/((Rho**2)*g))**(1/3)
u=gamma/(Rho*delta)
# z-coordinate 
Z=np.linspace(0, delta, num=50)
# mass transfer properties 
#delta=((3*Mue*u)/(Rho*g))**0.5
############################
for D in varD:
	############################
	b=(2*D)/(3*u)
	# 
	infinity=100
	for y in Y:
		# finding kisi from BC2 
		guesslist=np.logspace(0, 10, num=10000)
		guesslist=delta/guesslist
		guesslist=np.fliplr([guesslist])[0]
		KICI=[delta]
		for kisi in guesslist:
			sigma=0
			for n in range(infinity):
				Sin=((-1)**n)/(2*n+1)
				lmbda=((2*n+1)*math.pi)/(2*kisi)
				lmbda2=lmbda**2
				Expot=(-1)*lmbda2*b
				Expt=y*Expot
				Exp=np.exp(Expt)
				An=Sin*Exp
				sigma += An
			Err=sigma - (math.pi/4)
			if abs(Err)==0:
				KICI.append(kisi)	
		kisi=min(KICI)
		# calculating kc and NA  
		Sum=0
		for n in range(infinity):
			lmbda=((2*n+1)*math.pi)/(2*kisi)
			lmbda2=lmbda**2
			Expot=(-1)*lmbda2*b
			Expt=y*Expot
			Exp=np.exp(Expt)
			An=Exp
			Sum += An
		kc_infY=(2*D/kisi)*Sum
		NA_infY=kc_infY*(cAi - cA0)
		kc_infN=((3*u*D)/(2*math.pi*y))**0.5
		NA_infN=(cAi-cA0)*kc_infN
		# kcbar calculation 
		Sum=0
		for n in range(infinity):
			lmbda=((2*n+1)*math.pi)/(2*kisi)
			lmbda2=lmbda**2
			Expot=(-1)*lmbda2*b
			Expt=L*Expot
			Exp=np.exp(Expt)
			An=Exp/((2*n+1)**2)
			Sum += An
		kcbar_infY=(12*u*kisi/(L*(math.pi**2)))*((math.pi**2)/8 - Sum)	
		kcbar_infN=((6*u*D)/(math.pi*L))**0.5
		# calculating cA 
		for z in Z:
			Sum=0
			for n in range(infinity):
				lmbda=((2*n+1)*math.pi)/(2*kisi)
				lmbda2=lmbda**2
				Expot=(-1)*lmbda2*b
				Expt=y*Expot
				Exp=np.exp(Expt)
				Sin=math.sin(z*lmbda)
				An=Sin*Exp/(2*n+1)
				Sum += An 
			cA_infY=cA0+(cAi-cA0)*(1-(4/math.pi)*Sum)
			Exp_infN=0.5*(((3*u*(z**2))/(2*D*y))**0.5)
			cA_infN=cA0+(cAi-cA0)*(1-math.erf(Exp_infN))
			print (D, y, z, delta, kisi, cA_infY, cA_infN, NA_infY, NA_infN, kc_infY, kc_infN, kcbar_infY, kcbar_infN, gamma, u)