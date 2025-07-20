// Dirreflec

# include <iostream.h>
# include <math.h>
# include <iomanip.h>

void FRESNEL( double, double, double, double&, double&, double&);

int main()
	{

	double AN,AK,ISTEP,PI2,TH,PH,EPS,I,RHOS,RHOP,RHO;

	cout<<"     INPUT INDEX OF REFRACTION: N,K"<<endl;
	cin>>AN>>AK;
	cout<<"     N = "<<AN<<",  K = "<<AK<<endl;
	cout<<"     INPUT SPACING FOR OUTPUT, IN DEGREES"<<endl;
	cin>>ISTEP;
	cout<<"     THETA     RHOS      RHOP      RHO       EPS"<<endl;
	PI2=2.E0*atan(1.E0);
	for(I=1;I<91;I=I+ISTEP)
		{
		TH=(I-1)*PI2/9.E1;
		PH=(I-1);
		FRESNEL(AN,AK,TH,RHOS,RHOP,RHO);
		EPS=1.E0-RHO;
		cout<<setw(8)<<PH<<setw(13)<<RHOS<<setw(10)<<RHOP<<setw(10)<<
		RHO<<setw(10)<<EPS<<endl;
		}
	return 0;
	}


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


