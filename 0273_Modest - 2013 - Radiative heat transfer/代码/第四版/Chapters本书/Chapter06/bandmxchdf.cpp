// Program Bandmxchdf

# include <iostream.h>
# include <math.h>
# include <iomanip.h>

const int N=2,M=2;

void BANDAPPDF(int,double[],double[],double[][N+1],double[][N+1],double[][N+1],int[],double[],double[]);
void GRAYDIFF(int ,double [],double [],double [],double [][N+1],int [],double [],double []);
double VIEW(int,int,double []);
double perppltf(double,double,double,double,double,double,double);
double parlpltf(double,double,double,double,double,double,double);
void GAUSS(double [][N+1],double [],double []);
double bbfn(double );


int main ()
    {
    double A[N+1],Bandwl[M+1],F[N+1][N+1],EPS[M+1][N+1],HO[M+1][N+1],T[N+1],q[N+1],L1,L2;
    int id[N+1],iclsd,i;

    // Spectral band limit wavelengths
        Bandwl[1]=4.;                    // wavelength in micron

    // Dimensions
        L1=0.8;
        L2=0.6;


    // Surface 1 (bottom)
    A[1]=L1;                         // per unit depth
    HO[1][1]=866.*bbfn(4.*5762);
    HO[2][1]=866.-HO[1][1];                   // solar irradiation including specular reflection from A2
    EPS[1][1]=0.8;
    EPS[2][1]=0.1;
    id[1]=1;                         // T specified
    T[1]=350.;                       // T in K
// Surface2 (left)
    A[2]=L2;                         // per unit depth
    HO[1][2]=500.*bbfn(4.*5762);
    HO[2][2]=500.-HO[1][2];                     // direct solar irradiation
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
    BANDAPPDF(iclsd,A,Bandwl,EPS,HO,F,id,q,T);
// Output
    cout<<"surface     T        q [W/m2]      Q [W]"<<endl;
    for (i=1;i<=N;i=i+1)
        {cout<<setw(5)<<i<<setw(9)<<T[i]<<setw(13)<<q[i]<<"       "<<q[i]*A[i]<<endl;}

return 0;
}



//******************************************************************************
void BANDAPPDF(int iclsd,double A[],double Bandwl[],double EPS[][N+1],double HO[][N+1],double F[][N+1],int id[],double q[],double T[])
{
// Routine to solve for missing surface temperatures/fluxes calling GRAYDIFF
// for M spectral ranges
// INPUT:
// M     = number of spectral bands
// N      = number of surfaces in enclosure
// iclsd  = closed or open configuration identifier
//          iclsd=1: configuration is closed; diagonal Fsii evaluated from summation rule
//          iclsd/=1: configuration has openings; Fsii must be specified
// A(N)   = vector containing surface areas, [m2]
// Bandwl(M-1) = vector containing wavelengths separating the M spectral bands, [micro-m]
// EPS(M,N) = matrix containing surface emittances for 2 spectral ranges
// HO(M,N) = vector containing external irradiation, in [W/m2]
// F(N,N)= matrix containing view factors; on input only Fij with j>i (iclsd=1) or
//          j>=i (iclsd/=1) are required; remainder are calculated
// ID(N)  = vector containing surface identifier:
//          ID=0: surface heat flux is specified, in [W/m2]
//          ID=1: surface temperature is specified, in [K]
// q(N)   = vector containing known surface fluxes (only for surfaces with id=2)
// T(N)   = vector containing known surface temperatures (only for surfaces with id=1)
// OUTPUT:
// q(N)   = vector containing surface fluxes (for all surfaces)
// T(N)   = vector containing surface temperatures (for all surfaces)

   int IDl[N+1],i,j,iqsp,o;
   double qc[N+1],sigma=5.670E-8,Tresset=.1; //temperature residual setpoint in K
   double PIN[N+1],POUT[N+1],epsl[N+1],hol[N+1],Tmin,Tmax;
   double fracl[N+1],frach[N+1],Eb[N+1],Ttop,Tbot,Tnew,Ebtop,Ebbot,Ebnew,ebfrh,ebfrl,FZ,FZb,Tres;

// First guess temperature for surfaces for which flux is specified
    Tmin=1.e8;
    Tmax=0.;
    iqsp=0;
    for (i=1;i<=N;i=i+1)
        {if(id[i]!=0)
            {if(T[i]>Tmax) Tmax=T[i];
            if(T[i]<Tmin) Tmin=T[i];}}
    for (i=1;i<=N;i=i+1)
        {if(id[i]!=1)
            {iqsp=iqsp+1;                     // number of surfaces with q specified
            T[i]=.5*(Tmin+Tmax);}}

    Bandwl[M]=1.e5;

// Scan over spectral bands
v:  for (i=1;i<=N;i=i+1)
    fracl[i]=0.;
// Initialize (calculated) total fluxes and emissive powers
    for (i=1;i<=N;i=i+1)
        qc[i]=0.;
    for (i=1;i<=N;i=i+1)
        Eb[i]=sigma*pow(T[i],4.0);
    for (j=1;j<=M;j=j+1)
       {
// Set local values for eps, rhos, hos, pin and Fs
       for (i=1;i<=N;i=i+1)
        {epsl[i]=EPS[j][i];
        hol[i]=HO[j][i];
        frach[i]=bbfn(Bandwl[j]*T[i]);       // bbfn at max wavelength for band
        PIN[i]=Eb[i]*(frach[i]-fracl[i]);    // fraction of emissive power in band
        }
        for (o=1;o<=N;o=o+1)
          {IDl[o]=1;                         // as used here ALL T's are specified
          fracl[o]=frach[o];}                // bbfn at min wavelength for (next) band

        GRAYDIFF(iclsd,A,epsl,hol,F,IDl,PIN,POUT);
// Adding fluxes of all bands
        for (o=1;o<=N;o=o+1)
          {qc[o]=qc[o]+POUT[o];}
       }

// Update temperatures for surfaces for which flux is specified
// This is done by assuming irradiation H(r) to be correct in eq. (6.10-top; modified
// for bandmodel), ie, FZ= [q - eps*Eb]_last - [q_specified - eps*Eb(T_new)]
// (this REALLY should be in double precision!)
    Tres=0.;             // initialize temperature error residual
    for (i=1;i<=N;i=i+1)
        {if(id[i]!=1)
// Calculate unchangeable part of zero function (all except eps*Eb(T_new))
            {FZb=qc[i]-q[i];
            ebfrl=0;
            for (j=1;j<=M;j=j+1)
              {ebfrh=bbfn(Bandwl[j]*T[i]);
              FZb=FZb-EPS[j][i]*Eb[i]*(ebfrh-ebfrl);
                  ebfrl=ebfrh;}

        if(qc[i]>q[i])
    {
// Temperature is too high
          Ttop=T[i];
          Tbot=Ttop;
vv:       Tbot=Tbot-10.;
// Calculate remainder of zero function via iteration with changing T_new
          FZ=FZb;
          ebfrl=0;
          Ebbot=sigma*pow(Tbot,4.0);
          for (j=1;j<=M;j=j+1)
        {ebfrh=bbfn(Bandwl[j]*Tbot);
            FZ=FZ+EPS[j][i]*Ebbot*(ebfrh-ebfrl);
            ebfrl=ebfrh;}
          if(FZ>0.) goto vv;}   // not low enough yet
        else
// Temperature is too low
          {Tbot=T[i];
          Ttop=Tbot;
xx:       Ttop=Ttop+10.;
// Calculate remainder of zero function
          FZ=FZb;
          ebfrl=0;
          Ebtop=sigma*pow(Ttop,4.0);
          for (j=1;j<=M;j=j+1)
        {ebfrh=bbfn(Bandwl[j]*Ttop);
            FZ=FZ+EPS[j][i]*Ebtop*(ebfrh-ebfrl);
            ebfrl=ebfrh;}
          if(FZ<0.) goto xx;}   // not high enough yet

// Find new temperature by secant method
xxx:     Tnew=0.5*(Ttop+Tbot);
// Calculate remainder of zero function
          FZ=FZb;
          ebfrl=0;
          Ebnew=sigma*pow(Tnew,4.0);
          for (j=1;j<=M;j=j+1)
        {ebfrh=bbfn(Bandwl[j]*Tnew);
            FZ=FZ+EPS[j][i]*Ebnew*(ebfrh-ebfrl);
            ebfrl=ebfrh;
            }
// Check for convergence (really need double precision here!)
          if(FZ<0.) Tbot=Tnew;   // too low
          if(FZ>0.) Ttop=Tnew;   // too high
          if(Ttop-Tbot>Tresset) goto xxx;
          Tres=Tres+fabs(T[i]-Tnew);
          T[i]=Tnew;
        }} // i
    Tres=Tres/iqsp;
    if(Tres>Tresset) goto v;
    for (o=1;o<=N;o=o+1)
        q[o]=qc[o];
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


double bbfn(double X)
    {
    //  ********************************************************************
    //  *  This subroutine calculates the fractional blackbody       *
    //  *  emissive power f(n*lambda*T), where X=n*lambda*T in (micro-m*K) *
    //  ********************************************************************
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
