// Program Semigrxchdf

# include <iostream.h>
# include <math.h>
# include <iomanip.h>

const int N=2;
void SEMIGRAYDF(int,double [],double [][N+1],double [],double [][N+1],int [],double [],double []);
void GRAYDIFF(int ,double [],double [],double [],double [][N+1],int [],double [],double []);
double VIEW(int,int,double []);
double perppltf(double,double,double,double,double,double,double);
double parlpltf(double,double,double,double,double,double,double);
void GAUSS(double [][N+1],double [],double []);


int main ()
      {
      double A[N+1],F[N+1][N+1],EPS[3][N+1],HO[N+1],T[N+1],q[N+1],L1,L2;
      int id[N+1],iclsd,i;
      
// Dimensions
    L1=0.8;
    L2=0.6;

// Surface 1 (bottom)
    A[1]=L1;                         // per unit depth
    HO[1]=866;                   // solar irradiation including specular reflection from A2
    EPS[1][1]=0.8;  
    EPS[2][1]=0.1;
    id[1]=1;                         // T specified
    T[1]=350.;                       // T in K
// Surface2 (left)
    A[2]=L2;                         // per unit depth
    HO[2]=500.;                     // direct solar irradiation
    EPS[1][2]=0.1; 
    EPS[2][2]=0.8; 
    id[2]=0;                        // q specified
    q[2]= 0.;                        // q in W/m2
// View Factors; since configuration is open (iclsd=2), diagonal terms are also needed
    iclsd=2;
// Range 1&2 are the same in this problem (no specular reflected energy hits another surface)
    F[1][1]=0.; 
    F[1][2]=0.25; 
    F[2][2]=0.; 
// Solve system of equations
    SEMIGRAYDF(iclsd,A,EPS,HO,F,id,q,T);
// Output
    cout<<"surface     T        q [W/m2]      Q [W]"<<endl; 
    for (i=1;i<=N;i=i+1)
      {cout<<setw(5)<<i<<setw(9)<<T[i]<<setw(13)<<q[i]<<"       "<<q[i]*A[i]<<endl;}

return 0;
}

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
