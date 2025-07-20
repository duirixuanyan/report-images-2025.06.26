// Function graydifspec

# include <iostream.h>
# include <math.h>

//******************************************************************************
// Routine to fill view factor matrix and solve for missing surface temperatures/fluxes
void GRAYDIFFSPEC(int iclsd,double A[],double EPS[],double RHOs[],double HOs[],double Fs[][N+1],int ID[],double PIN[],double POUT[])
{
// INPUT:
// N     = number of surfaces in enclosure
// iclsd = closed or open configuration identifier
//         iclsd=1: configuration is closed; diagonal Fii evaluated from summation rule
//         iclsd/=1: configuration has openings; Fii must be specified
// A(N)  = vector containing surface areas, [m2]
// EPS(N)= vector containing surface emittances
// RHOs(N)= vector containing surface specular reflectance components
// HOs(N) = vector containing external irradiation, in [W/m2]
// Fs(N,N)= vector containing view factors; on input only Fsij with j>i (iclsd=1) or
//         j>=i (iclsd/=1) are required; remainder are calculated
// ID(N) = vector containing surface identifier:
//         ID=0: surface heat flux is specified, in [W/m2]
//         ID=1: surface temperature is specified, in [K]
// PIN(N)= vector containing surface emissive powers (id=1) and fluxes (id=2)
// OUTPUT: 
// POUT(N)= vector containing unknown surface fluxes (for surfaces with id=1) and 
//           temperatures (for surfaces with id=2)
int i,j,ikr;
double qm[N+1][N+1],em[N+1][N+1],pm[N+1][N+1],B[N+1];
// Compute missing view factors
// Lower left triangle by reciprocity
for (i=2;i<=N;i=i+1)
	 for (j=1;j<=(i-1);j=j+1)
		  Fs[i][j]=A[j]/A[i]*Fs[j][i];
// If closed configuration, need to also calculate diagonal terms by summation rule
	if(iclsd==1)
	{
	for (i=1;i<=N;i=i+1)
		{
		Fs[i][i]=1.;
		for (j=1;j<=N;j=j+1)
			if(j!=i)
				Fs[i][i]=Fs[i][i]-(1.-RHOs[j])*Fs[i][j];
		Fs[i][i]=Fs[i][i]/(1.-RHOs[i]);
		}
	}
// Fill q- and e-coefficient matrices
	 for (i=1;i<=N;i=i+1)
		{
		for (j=1;j<=N;j=j+1)
			{
			ikr=(i/j)*(j/i);         // Kronecker delta_ij
			qm[i][j]=ikr/EPS[j]-((1.-RHOs[j])/EPS[j]-1.)*Fs[i][j];
			em[i][j]=ikr-(1.-RHOs[j])*Fs[i][j];
			}
	}
// Fill POUT-coefficient matrix and RHS
	 for (i=1;i<=N;i=i+1)
			{
			B[i]=-HOs[i];
			for (j=1;j<=N;j=j+1)
					{
					pm[i][j]=qm[i][j]*ID[j]-em[i][j]*(1-ID[j]);
					B[i]=B[i]+(em[i][j]*ID[j]-qm[i][j]*(1-ID[j]))*PIN[j];
					}
			}
// Invert POUT-coefficient matrix and multiply by RHS to obtain POUT
	 GAUSS(pm,B,POUT);
}
