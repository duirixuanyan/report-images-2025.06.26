// function bandappdf

# include <iostream.h>
# include <math.h>

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

   int IDl[N+1],i,j,k,iqsp,o;
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
