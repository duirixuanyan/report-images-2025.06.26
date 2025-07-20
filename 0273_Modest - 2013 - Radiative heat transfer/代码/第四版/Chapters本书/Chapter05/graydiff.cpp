// Function graydiff

# include <iostream.h>
# include <math.h>

//******************************************************************************
// Routine to fill view factor matrix and solve for missing surface temperatures/fluxes
void GRAYDIFF(int iclsd,double A[],double EPS[],double HO[],double F[][N+1],int ID[],double PIN[],double POUT[])
{
// INPUT:
// N     = number of surfaces in enclosure
// iclsd = closed or open configuration identifier
//         iclsd=1: configuration is closed; diagonal Fii evaluated from summation rule
//         iclsd/=1: configuration has openings; Fii must be specified
// A(N)  = vector containing surface areas, [m2]
// EPS(N)= vector containing surface emittances
// HO(N) = vector containing external irradiation, in [W/m2]
// F(N,N)= vector containing view factors; on input only Fij with j>i (iclsd=1) or
//         j>=i (iclsd/=1) are required; remainder are calculated
// ID(N) = vector containing surface identifier:
//         ID=0: surface heat flux is specified, in [W/m2]
//         ID=1: surface temperature is specified, in [K]
// PIN(N)= vector containing surface emissive powers (id=1) and fluxes (id=2)
// OUTPUT: 
// POUT(N)= vector containing unknown surface fluxes (for surfaces with id=1) and 
//           emissive powers (for surfaces with id=0)
int i,j,ikr;
double qm[N+1][N+1],em[N+1][N+1],pm[N+1][N+1],B[N+1];
// Compute missing view factors
// Lower left triangle by reciprocity
for (i=2;i<=N;i=i+1)
	 for (j=1;j<=(i-1);j=j+1)
		  F[i][j]=A[j]/A[i]*F[j][i];
// If closed configuration, need to also calculate diagonal terms by summation rule
	if(iclsd==1)
	{
	for(i=1;i<=N;i=i+1)
		{F[i][i]=1.;
		for(j=1;j<=N;j=j+1)
			{if(i!=j)
				F[i][i]=F[i][i]-F[i][j];}}
	}
// Fill q- and e-coefficient matrices
	 for (i=1;i<=N;i=i+1)
		{
		for (j=1;j<=N;j=j+1)
			{
			ikr=(i/j)*(j/i);         // Kronecker delta_ij
			qm[i][j]=ikr/EPS[j]-(1./EPS[j]-1.)*F[i][j];
			em[i][j]=ikr-F[i][j];
			}
	}
// Fill POUT-coefficient matrix and RHS
	 for (i=1;i<=N;i=i+1)
			{
			B[i]=-HO[i];
			for (j=1;j<=N;j=j+1)
					{
					pm[i][j]=qm[i][j]*ID[j]-em[i][j]*(1-ID[j]);
					B[i]=B[i]+(em[i][j]*ID[j]-qm[i][j]*(1-ID[j]))*PIN[j];
					}
			}
// Invert POUT-coefficient matrix and multiply by RHS to obtain POUT
	 GAUSS(pm,B,POUT);
}
//***********************************************************************************
void GAUSS(double A[][N+1],double B[],double X[])
{
int I,L[N+1],K,J,LK;
double S[N+1];
double SMAX,RMAX,R,XMULT,SUM;
      for (I=1;I<=N;I=I+1)
			{L[I]=I;
			SMAX=0.0;
			for (J=1;J<=N;J=J+1)
				{if (fabs(A[I][J]>SMAX))
				SMAX=fabs(A[I][J]);
				}
			S[I]=SMAX;
			}
      for (K=1;K<=N-1;K=K+1) 
        {RMAX=0.0;
        for (I=K;I<=N;I=I+1) 
		{R = fabs(A[L[I]][K])/S[L[I]];
		if (R<=RMAX)
		{}
		else
		{J=I;
		RMAX=R;
		}}
		LK=L[J];
		L[J]=L[K];
		L[K]=LK;
		for (I=K+1;I<=N;I=I+1)
			{XMULT = A[L[I]][K]/A[LK][K];
				for (J=K+1;J<=N;J=J+1)
					A[L[I]][J] = A[L[I]][J] - XMULT*A[LK][J];
				A[L[I]][K] = XMULT;
			}
          	}    
 
      for (K=1;K<=N-1;K=K+1) 
        { 
        for (I=K+1;I<=N;I=I+1)      
          {B[L[I]] = B[L[I]] - A[L[I]][K]*B[L[K]];
	  //cout<<B[L[I]]<<" "<<L[I]<<endl;
	  } 
        }
      X[N] = B[L[N]]/A[L[N]][N];
      for (I=N-1;I>=1;I=I-1)      
        {SUM = B[L[I]];       
		  for (J=I+1;J<=N;J=J+1)
          SUM = SUM - A[L[I]][J]*X[J];    
        X[I] = SUM/A[L[I]][I];
        }         
}
