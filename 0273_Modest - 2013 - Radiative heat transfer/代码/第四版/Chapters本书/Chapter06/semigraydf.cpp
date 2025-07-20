// Function Semigraydf

# include <iostream.h>
# include <math.h>

//******************************************************************************
void SEMIGRAYDF(int iclsd,double A[],double EPS[][N+1],double HO[],double F[][N+1],int ID[],double q[],double T[])
{
// Routine to solve for missing surface temperatures/fluxes for the special case that
// all surfaces are diffuse reflectors; calling GRAYDIFF for 2 spectral ranges
// INPUT:
// N      = number of surfaces in enclosure
// iclsd  = closed or open configuration identifier
//         iclsd=1: configuration is closed; diagonal Fii evaluated from summation rule
//         iclsd/=1: configuration has openings; Fii must be specified
// A(N)   = vector containing surface areas, [m2]
// EPS(2,N)= matrix containing surface emittances for 2 spectral ranges
// HO(N)  = vector containing external irradiation, in [W/m2]
// F(N,N) = matrix containing view factors; on input only Fsij with j>i (iclsd=1) or
//          j>=i (iclsd/=1) are required; remainder are calculated
// ID(N)  = vector containing surface identifier:
//         ID=0: surface heat flux is specified, in [W/m2]
//         ID=1: surface temperature is specified, in [K]
// q(N)   = vector containing known surface fluxes (only for surfaces with id=2)
// T(N)   = vector containing known surface temperatures (only for surfaces with id=1)
// OUTPUT: 
// q(N)   = vector containing surface fluxes (for all surfaces)
// T(N)   = vector containing surface temperatures (for all surfaces)

int i,j,id1[N+1];
double sigma=5.670E-8,PIN[N+1],POUT[N+1],epsl[N+1],q1[N+1],HO2[N+1];

// First calculate fluxes for external irradiation (range 1)
    for (i=1;i<=N;i=i+1)
      {id1[i]=1;   // all surfaces have T=0
         PIN[i]=0.0;}

// Set local values for eps and Fs
    for (i=1;i<=N;i=i+1)
        epsl[i]=EPS[1][i];
    GRAYDIFF(iclsd,A,epsl,HO,F,id1,PIN,q1);

// Calculate unknown fluxes and temperatures by setting q2=q-q1;
// the q1 terms give rise to a "negative irradiation" term
    for (i=1;i<=N;i=i+1)
      {
// Set local values for eps
        epsl[i]=EPS[2][i];
        HO2[i]=-q1[i]/EPS[2][i];
        for (j=1;j<=N;j=j+1)
          HO2[i]=HO2[i]+(1./EPS[2][j]-1.)*F[i][j]*q1[j];
// Fill PIN array with q and T
        if(ID[i]==0) 
            PIN[i]=q[i];
        else
            PIN[i]=sigma*pow(T[i],4.0);    // Convert temperatures to emissive powers
        }
    GRAYDIFF(iclsd,A,epsl,HO2,F,ID,PIN,POUT);

// Convert emissive powers to temperatures
    for (i=1;i<=N;i=i+1)
        {
        if(ID[i]==0)
            T[i]=pow((POUT[i]/sigma),.25);      
        else
            q[i]=POUT[i];
        }
}
