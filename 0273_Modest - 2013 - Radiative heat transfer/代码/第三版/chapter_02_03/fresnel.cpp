// Frensel Function

# include <iostream.h>
# include <math.h>


	
void FRESNEL(double AN, double AK, double TH, double& RHOS, double& RHOP,
				double& RHO)
{
	double C1,P2,Q2,CT,C2,C3,P,Q;

	C1=AN*AN-AK*AK-pow(sin(TH),2);
	P2=.5E0*(sqrt(C1*C1+pow((2.E0*AN*AK),2))+C1);
	Q2=P2-C1;
	CT=cos(TH);
	C2=(AN*AN-AK*AK)*CT;
	C3=2.E0*AN*AK*CT;
	P=sqrt(P2);
	Q=sqrt(Q2);
	RHOP=(pow((P-C2),2)+pow((Q-C3),2))/(pow((P+C2),2)+pow((Q+C3),2));
	RHOS=(pow((CT-P),2)+Q2)/(pow((CT+P),2)+Q2);
	RHO=.5E0*(RHOP+RHOS);
}
