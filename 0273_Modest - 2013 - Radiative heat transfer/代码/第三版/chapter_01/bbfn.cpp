// bbfn Function

# include <iostream.h>
# include <math.h>

double bbfn(double X)
	{
	//  ********************************************************************
	//  *  This subroutine calculates the fractional blackbody		 *
	//  *  emissive power f(n*lambda*T), where X=n*lambda*T in (micro-m*K) *
	//  ********************************************************************double PI,CC,C2,EPS,V,EX,M,BBFN,EM,VM,BM;
	double PI,CC,C2,EPS,V,EX,M,BBFN,VM,BM,EM;
	
	PI=4.E0*atan(1.E0);
	CC=1.5E1/pow(PI,4);
	C2=1.4388E4;
	EPS=1.E-16;
	
	V=C2/X;
	EX=exp(V);
	
	M=0;
	BBFN=0.E0;
	EM=1.E0;
	i:
	M=M+1;
	VM=M*V;
	BM=(6.E0+VM*(6.E0+VM*(3.E0+VM)))/pow(M,4);
	EM=EM/EX;
	BBFN=BBFN+BM*EM;
	if(pow(VM,3)*EM>EPS)
		goto i;
	BBFN=CC*BBFN;
	return BBFN;
	}
	
	
	
	
	
	
	

