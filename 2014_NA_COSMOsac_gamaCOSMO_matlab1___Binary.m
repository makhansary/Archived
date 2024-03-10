function MATrix=Binary(SYSTEMP, ListCOMP) 
% 
COMP=length(ListCOMP); % COMP=2;
% mole fractions 
x1=5e-3:1e-3:(1-5e-3); % mole fraction of component 1
x2=1-x1; % mole fraction of component 2
%
% COSMO settings 
[EO, AEFFPRIME, RGAS, VNORM, ANORM, COMPSEG, ...
	EPS, COORD, SIGMAHB, CHB, FPOL, ALPHA, ALPHAPRIME]=paraCOSMO(); 
%
for n=1:COMP
	[SigmaDensity SigmaProfile VolCavity]=SimgaProfileCalculator(ListCOMP{n});
	xlswrite('sProfiles.xlsx', SigmaDensity', ListCOMP{n}, ...
	['A3' ':' ['A' num2str(length(SigmaDensity)+3)]]); 
	xlswrite('sProfiles.xlsx', SigmaProfile', ListCOMP{n}, ...
	['B3' ':' ['B' num2str(length(SigmaDensity)+3)]]);
	SigmaProfiles(:,n)=SigmaProfile'; 
	ACOSMO(n)=sum(SigmaProfile); % MOLECULAR SURFACE AREA FROM COSMO OUTPUT (A**2) 
								% --THE SUM OF THE INDIVIDUAL PROFILE
	VCOSMO(n)=VolCavity; % CAVITY VOLUME FROM COSMO OUTPUT (A**3)
end
RNORM = VCOSMO./VNORM; 
QNORM = ACOSMO./ANORM;
for x=1:length(x1)
	NUMER = x1(x)*SigmaProfiles(:,1) + x2(x)*SigmaProfiles(:,2);
	DENOM = x1(x)*ACOSMO(1) + x2(x)*ACOSMO(2);
	MixSigmaProfile=NUMER./DENOM;
	for i=1:length(SigmaDensity)
		for j=1:length(SigmaDensity)
			if SigmaDensity(i)>=SigmaDensity(j)
				SIGMAACC = SigmaDensity(i);
				SIGMADON = SigmaDensity(j);
			else 
				SIGMADON = SigmaDensity(i);
				SIGMAACC = SigmaDensity(j);
			end 
			DELTAW(i,j)=(ALPHAPRIME/2.0)*(SigmaDensity(i)+SigmaDensity(j))^2.0 + ...
				CHB*max(0.0,(SIGMAACC - SIGMAHB))*min(0.0,(SIGMADON + SIGMAHB));
		end 
	end
	% SEGMENT ACITIVITY COEF (PURE SPECIES)
	for n=1:COMP
		CONPR=1e3;
		SEGGAMMAPR(1:length(SigmaDensity),n) = 1.0;
		while (max(CONPR) > 1e-6)
			SEGGAMMAOLDPR(:,n)=SEGGAMMAPR(:,n);
			for i=1:length(SigmaDensity)
				SUMMATION = 0.0;
				for j=1:length(SigmaDensity)
					SUMMATION = SUMMATION + ...
						(SigmaProfiles(j,n)/ACOSMO(n))*SEGGAMMAOLDPR(j,n)*...
						exp(-DELTAW(i,j)/(RGAS*SYSTEMP));
				end
				SEGGAMMAPR(i,n)=exp(-log(SUMMATION));
				SEGGAMMAPR(i,n)=(SEGGAMMAPR(i,n)+SEGGAMMAOLDPR(i,n))/2.0; 
			end 
			CONPR=abs((SEGGAMMAPR(:,n)-SEGGAMMAOLDPR(:,n))/SEGGAMMAOLDPR(:,n));
		end 
	end 
	% SEGMENT ACTIVITY COEF. (MIXTURE)
	CON=1e3;
	SEGGAMMA(1:length(SigmaDensity)) = 1.0;
	while (max(CON) > 1e-6)
		SEGGAMMAOLD=SEGGAMMA;
		for i=1:length(SigmaDensity)
			SUMMATION = 0.0;
			for j=1:length(SigmaDensity)
				SUMMATION = SUMMATION + MixSigmaProfile(j)...
				*SEGGAMMAOLD(j)*exp(-DELTAW(i,j)/(RGAS*SYSTEMP));
			end
			SEGGAMMA(i)=exp(-log(SUMMATION));
			SEGGAMMA(i)=(SEGGAMMA(i)+SEGGAMMAOLD(i))/2.0; 
		end 
		CON=abs((SEGGAMMA-SEGGAMMAOLD)/SEGGAMMAOLD);
	end 
	BOTTHETA = x1(x)*QNORM(1) + x2(x)*QNORM(2);
	BOTPHI = x1(x)*RNORM(1) + x2(x)*RNORM(2);
	THETA(1) = (x1(x)*QNORM(1))/BOTTHETA;
	THETA(2) = (x2(x)*QNORM(2))/BOTTHETA;
	PHI(1) = (x1(x)*RNORM(1))/BOTPHI;
	PHI(2) = (x2(x)*RNORM(2))/BOTPHI;
	L = (COORD/2.0)*(RNORM-QNORM)-(RNORM-1.0);
	% CALCULATION OF GAMMAS
	GAMMASG(1) = log(PHI(1)/x1(x))+(COORD/2)*QNORM(1)*log(THETA(1)/PHI(1))...
		+L(1)-(PHI(1)/x1(x))* (x1(x)*L(1) + x2(x)*L(2));
	GAMMASG(2) = log(PHI(2)/x2(x))+(COORD/2)*QNORM(2)*log(THETA(2)/PHI(2))...
		+L(2)-(PHI(2)/x2(x))* (x1(x)*L(1) + x2(x)*L(2)); 
	for n=1:COMP 
		SUMGAMMA(n)=sum((SigmaProfiles(:,n)/AEFFPRIME).*(log(SEGGAMMA'./(SEGGAMMAPR(:,n)))));
	end 
	GAMMA=exp(SUMGAMMA + GAMMASG);
	LNGAMMA = log(GAMMA);
	MATrix(x,:)=[x1(x) GAMMA(1) LNGAMMA(1) x2(x) GAMMA(2) LNGAMMA(2)];
end
% 
end