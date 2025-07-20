//  Planck
//  ********************************************************************
//  *  This program calculates the spectral and fractional blackbody   *
//  *  emissive powers E_blambda/n^3T^5, E_beta/nT^3 and f(n*lambda*T),*
//  *  Input: ID = 1 -- use wavelength in micro-m		       *
//  *            = 2 -- use wavenumber in cm^-1			       *
//  *         WL/WN wavelength or wavenumber			       *
//  *         T  = temperature in K				       *
//  ********************************************************************


# include <iostream.h>
# include <math.h>
# include <iomanip.h>

double PI,CC,C1,C2,EPS,ID,XX,T,X,XN,V,EX,EL,EN,M,FL,EM,VM,BM;

int main ()
	{
	PI=4E0*atan(1E0);
	CC=1.5E1/pow(PI,4);
	C1=3.7404E8;
	C2=1.4388E4;
	EPS=1E-16;

	i:
	cout<<"  ID (1 FOR WL, 2 FOR WN), WLorWN, T ?"<<endl;
	cin>>ID>>XX>>T;
// X = lambda*T (mum*K), XN = eta/T (cm^-1/K)
	if(ID==1)
		{
		X=XX*T;
		XN=1.E4/X;
		}
	else if (ID==2)
		{
		XN=XX/T;
		X=1.E4/XN;
		}
	else
		{
		cout<<"ILLEGAL ID"<<endl;
		goto i;
		}
// V = C_2/lambdaT = C_2*eta/T
// EL = E_blambda/n^3T^5
// EN = E_beta/nT^3
	V=C2/X;
	EX=exp(V);
	EL=C1/(pow(X,5)*(EX-1.E0))*1.E11;
	EN=EL*X*X*1.E-7;

// Evaluation of f(n*lambda*T) in terms of an infinite series
// FL = f(n*lambda*T)

	M=0;
	FL=0.E0;
	EM=1.E0;
	ii:
	M=M+1;
	VM=M*V;
	BM=(6.E0+VM*(6.E0+VM*(3.E0+VM)))/pow(M,4);
	EM=EM/EX;
	FL=FL+BM*EM;
	if((pow(VM,3)*EM)>EPS)
		goto ii;
	FL=CC*FL;

// Print results to screen

	cout<<"     WL*T       WN/T        EBL/T5          EBN/T3       F"<<endl;
	cout<<"     (umk)     (cm K)  (E-11 W/m2umK5) (E-8 W/m2cm-1K3)"<<endl;
	cout<<setw(10)<<X<<setw(11)<<XN<<setw(14)<<EL<<setw(15)<<
		EN<<setw(12)<<FL<<endl;

	return 0;
	}
