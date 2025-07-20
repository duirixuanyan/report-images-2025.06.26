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


//******************************************************************************
// View Factor routine
//
double VIEW(int NO,int NARG,double ARG[])
{
//  *************************************************************************
//  *  THIS SUBROUTINE EVALUATES ALL VIEW FACTORS LISTED IN APPENDIX D      *
//  *  NO = CONFIGURATION NUMBER (1 THROUGH 51),                            *
//  *  NARG = NUMBER OF NON-DIMENSIONAL ARGUMENTS FOR VIEW FACTOR,          *
//  *  ARG = ARRAY CONTAINING THE NARG DIFFERENT ARGUMENTS (in alphabetical *
//  *          order as given in App.D, angles given in degrees),           *
//  *  VIEW = VIEW FACTOR RETURNED BY THE SUBROUTINE                        *
//  *      (FOR NUMBERS 1-9, DF/DL IS GIVEN, WHERE DL IS NONDIMENSIONAL     *
//  *       INFINITESIMAL DIMENSION OF RECEIVING SURFACE).                  *
//  *************************************************************************


double VIEW,PHI,HR,RTA,RTB,XX,YY,Z,ZZ,LL,PHI1,PHI2,XY,RR1,RR2;
double PI,H,W,HW,ALPHA2,R,S,X,R1,R2,RR,SS,C,PHIMAX;
double A,B1,B2,BB1,BB2,B,Y,RTX,RTY,RT,L,HH,WW,W2,H2,HW2;
double H12,W12,C1,C2,C3,AA,BB,BL,L1,L2,D1,D2,OM,CC,D,SR;

if(NO<1 || NO>51) goto i;
PI=3.1415926E0;

switch (NO)
      {
  case 1:
      {if(NARG!=1) goto ii;
      PHI=ARG[1];
      VIEW=0.5*cos(PHI*PI/180.);
      return VIEW;}
  case 2:
      {if(NARG!=2) goto ii;
      L=ARG[1];
      R=ARG[2];
      RR=R/L;
      VIEW=2.*RR/pow((1.+RR*RR),2);
      return VIEW;}
  case 3:
      {if(NARG!=2) goto ii;
      R=ARG[1];
      X=ARG[2];
      XX=X/R;
      VIEW=2.*XX/pow((1.+XX*XX),2);
      return VIEW;}
  case 4:
      {if(NARG!=3) goto ii;
      R1=ARG[1];
      R2=ARG[2];
      Z=ARG[3];
      RR=R2/R1;
      if(RR>1.)
    {cout<<"R2 MUST BE LESS THAN R1"<<endl;
    VIEW=0.;
    return VIEW;}
      ZZ=Z/R1;
      X=1.+RR*RR+ZZ*ZZ;
      VIEW=2.*ZZ*(X-2.*RR*RR)*RR/pow((X*X-4.*RR*RR),1.5);
      return VIEW;}
  case 5:
      {if(NARG!=3) goto ii;
      X=ARG[1];
      Y=ARG[2];
      PHI=ARG[3];
      YY=Y/X;
      PHI=PHI*PI/180.;
      VIEW=0.5*YY*pow(sin(PHI),2)/pow((1.+YY*YY-2.*YY*cos(PHI)),1.5);
      return VIEW;}
  case 6:
      {if(NARG!=3) goto ii;
      B=ARG[1];
      R=ARG[2];
      PHI=ARG[3];
      BB=B/R;
      PHI=PHI*PI/180.;
      VIEW=atan(BB)*cos(PHI)/PI;
      return VIEW;}
  case 7:
      {if(NARG!=3) goto ii;
      L=ARG[1];
      R1=ARG[2];
      R2=ARG[3];
      RR=R1/R2;
      BL=L/R1;
      AA=BL*BL+RR*RR+1.;
      VIEW=2.*RR*BL*BL*AA/pow((AA*AA-4.*RR*RR),1.5);
      return VIEW;}
  case 8:
      {if(NARG!=3) goto ii;
      R1=ARG[1];
      R2=ARG[2];
      X=ARG[3];
      RR=R1/R2;
      XX=X/R2;
      AA=XX*XX-RR*RR+1.;
      BB=XX*XX+RR*RR+1.;
      VIEW=2.*XX*AA/pow((BB*BB-4.*RR*RR),1.5);
      return VIEW;}
  case 9:
      {if(NARG!=2) goto ii;
      R=ARG[1];
      X=ARG[2];
      XX=0.5*X/R;
      if(XX>.5E6)
        {VIEW=0.;
    return VIEW;}
      VIEW=1.-0.5*XX*(2.*XX*XX+3.)/pow((XX*XX+1.),1.5);
      return VIEW;}
  case 10:
      {if(NARG!=3) goto ii;
      A=ARG[1];
      B=ARG[2];
      C=ARG[3];
      AA=A/C;
      BB=B/C;
      RTA=sqrt(1.+AA*AA);
      RTB=sqrt(1.+BB*BB);
      VIEW=(AA/RTA*atan(BB/RTA)+BB/RTB*atan(AA/RTB))/(2.*PI);
      return VIEW;}
  case 11:
      {if(NARG!=3) goto ii;
      A=ARG[1];
      B=ARG[2];
      C=ARG[3];
      X=A/B;
      Y=C/B;
      RT=sqrt(X*X+Y*Y);
      VIEW=(atan(1./Y)-Y/RT*atan(1./RT))/(2.*PI);
      return VIEW;}
  case 12:
      {if(NARG!=2) goto ii;
      H=ARG[1];
      R=ARG[2];
      HR=H/R;
      VIEW=1./(1.+HR*HR);
      return VIEW;}
  case 13:
      {if(NARG!=3) goto ii;
      A=ARG[1];
      H=ARG[2];
      R=ARG[3];
      HH=H/A;
      RR=R/A;
      ZZ=1.+HH*HH+RR*RR;
      VIEW=.5*(1.-(ZZ-2.*RR*RR)/sqrt(ZZ*ZZ-4.*RR*RR));
      return VIEW;}
  case 14:
      {if(NARG!=3) goto ii;
      H=ARG[1];
      L=ARG[2];
      R=ARG[3];
      HH=H/L;
      RR=R/L;
      ZZ=1.+HH*HH+RR*RR;
      VIEW=.5*HH*(ZZ/sqrt(ZZ*ZZ-4.*RR*RR)-1.);
      return VIEW;}
  case 15:
      {if(NARG!=3) goto ii;
      H=ARG[1];
      L=ARG[2];
      R=ARG[3];
      HH=H/R;
      LL=L/R;
      X=pow((1.+HH),2)+LL*LL;
      Y=pow((1.-HH),2)+LL*LL;
      VIEW=LL/HH*(1./LL*atan(LL/sqrt(HH*HH-1.))
      +(X-2.*HH)/sqrt(X*Y)*atan(sqrt(X/Y*(HH-1.)/(HH+1.)))
      -atan(sqrt((HH-1.)/(HH+1.))))/PI;
      return VIEW;}
  case 16:
      {if(NARG!=2) goto ii;
      H=ARG[1];
      R=ARG[2];
      VIEW=pow((R/H),2);
      return VIEW;}
  case 17:
      {if(NARG!=2) goto ii;
      H=ARG[1];
      R=ARG[2];
      HH=H/R;
      VIEW=(atan(sqrt(1./(HH*HH-1.)))-sqrt(HH*HH-1.)/HH/HH)/PI;
      return VIEW;}
  case 18:
      {if(NARG!=3) goto ii;
      H=ARG[1];
      R=ARG[2];
      PHI=ARG[3];
      PHI=PHI*PI/180.;
      PHIMAX=acos(R/H);
      if(PHI>PHIMAX)
    {VIEW=0.;
    cout<<"PHI MUST BE LESS THAN ACOS(R/H),"<<180.*PHIMAX/PI<<endl;
    return VIEW;}
      VIEW=pow((R/H),2)*cos(PHI);
      return VIEW;}
  case 19:
      {if(NARG!=3) goto ii;
      H=ARG[1];
      L=ARG[2];
      R=ARG[3];
      HH=H/R;
      LL=L/R;
      if(HH<-1.)
        VIEW=0.;
      else if(HH<+1.)
        {X=LL*LL+HH*HH;
        Y=sqrt(X-1.);
        VIEW=(HH/pow(X,1.5)*acos(-HH/LL/Y)-Y*sqrt(1.-HH*HH)/X
          -asin(Y/LL/LL)+PI/2.)/PI;}
      else
        {X=LL*LL+HH*HH;
        VIEW=pow(H/X,1.5);}
      return VIEW;}
  case 20:
      {if(NARG!=3) goto ii;
      H=ARG[1];
      R=ARG[2];
      Z=ARG[3];
      if(Z<0. || Z>H)
    {VIEW=0.;
    cout<<"INVALID Z"<<endl;
    return VIEW;}
      HH=.5*H/R;
      ZZ=.5*Z/R;
      VIEW=1.+HH-(ZZ*ZZ+0.5)/sqrt(ZZ*ZZ+1.)-(pow((HH-ZZ),2)+0.5)/sqrt(pow((HH-ZZ),2)+1.);
      return VIEW;}
  case 21:
      {if(NARG!=2) goto ii;
      R=ARG[1];
      Z=ARG[2];
      if(Z<0.)
        {cout<<"INVALID Z"<<endl;
    VIEW=0.;
    return VIEW;}
      ZZ=Z/R;
      if(ZZ>1.E4)
        {VIEW=pow(ZZ,-3.);
    return VIEW;}
      VIEW=0.5*((ZZ*ZZ+2.)/sqrt(ZZ*ZZ+4.)-ZZ);
      return VIEW;}
  case 22:
      {if(NARG!=3) goto ii;
      R1=ARG[1];
      R2=ARG[2];
      Z=ARG[3];
      RR=R2/R1;
      if(RR>1.)
    {cout<<"R2 MUST BE LESS THAN R1"<<endl;
    VIEW=0.;
    return VIEW;}
      ZZ=Z/R1;
      X=1.+RR*RR+ZZ*ZZ;
      VIEW=0.5*ZZ*(X/sqrt(X*X-4.*RR*RR)-1.);
      return VIEW;}
  case 23:
      {if(NARG!=3) goto ii;
      L=ARG[1];
      X=ARG[2];
      XX=X/L;
      PHI=ARG[3];
      PHI=PHI*PI/180.;
      VIEW=0.5*(1.+(cos(PHI)-XX)/sqrt(1.+XX*XX-2.*XX*cos(PHI)));
      return VIEW;}
  case 24:
      {if(NARG!=2) goto ii;
      PHI1=ARG[1];
      PHI2=ARG[2];
      if(PHI2<PHI1)
    {cout<<"WARNING, PHI2 MUST BE GREATER THAN PHI1"<<endl;
    PHI=PHI1;
    PHI1=PHI2;
    PHI2=PHI;}
      if(PHI1>90.)
    {PHI1=90.;
    cout<<"PHI1 MUST BE LESS THAN 90 OR GREATER THAN -90"<<endl;}
      if(PHI1<-90.)
    {PHI1=-90.;
    cout<<"PHI1 MUST BE LESS THAN 90 OR GREATER THAN -90"<<endl;}
      PHI1=PHI1*PI/180.;
      PHI2=PHI2*PI/180.;
      VIEW=0.5*(sin(PHI2)-sin(PHI1));
      return VIEW;}
  case 25:
      {if(NARG!=3) goto ii;
      A=ARG[1];
      B=ARG[2];
      R=ARG[3];
      AA=A/R;
      BB=B/R;
      VIEW=AA/(AA*AA+BB*BB);
      return VIEW;}
  case 26:
      {if(NARG!=3) goto ii;
      A=ARG[1];
      B=ARG[2];
      C=ARG[3];
      X=A/C;
      Y=B/C;
      XX=sqrt(1.+X*X);
      YY=sqrt(1.+Y*Y);
      VIEW=(YY*atan(X/YY)-atan(X)+X*Y/XX*atan(Y/XX))/(PI*Y);
      return VIEW;}
  case 27:
      {if(NARG!=3) goto ii;
      A=ARG[1];
      B=ARG[2];
      C=ARG[3];
      X=A/B;
      Y=C/B;
      if (Y>1.E6)
        {VIEW=0.;
    return VIEW;}
      XY=X*X+Y*Y;
      YY=1.+Y*Y;
      VIEW=(atan(1/Y)+.5*Y*log(Y*Y*(XY+1.)/YY/XY)-Y/sqrt(XY)*atan(1./sqrt(XY)))/PI;
      return VIEW;}
  case 28:
      {if(NARG!=4) goto ii;
      H=ARG[1];
      R=ARG[2];
      S=ARG[3];
      X=ARG[4];
      HH=H/R;
      SS=S/R;
      XX=X/R;
      C=SS*SS+XX*XX;
      CC=sqrt(C);
      A=HH*HH+C-1.;
      B=HH*HH-C+1.;
      VIEW=SS/C*(1.-((1./PI)*(acos(B/A)-0.5*(sqrt(A*A+4.*HH*HH)*acos(B/A/CC)-B*asin(1./CC))/HH))
           -0.25*A/HH);
      return VIEW;}
  case 29:
      {if(NARG!=1) goto ii;
      PHI=ARG[1];
      VIEW=0.5*(1.+cos(PHI*PI/180.));
      return VIEW;}
  case 30:
      {if(NARG!=3) goto ii;
      A=ARG[1];
      R1=ARG[2];
      R2=ARG[3];
      RR1=R1/A;
      RR2=R2/A;
      if(RR2>1.)
        {cout<<"R@ MUST BE LESS THAN A"<<endl;
    VIEW=0.;
    return VIEW;}
      VIEW=RR2*RR2/pow((1.+RR1*RR1),1.5);
      return VIEW;}
  case 31:
      {if(NARG!=2) goto ii;
// IDENTICAL TO #21
      R=ARG[1];
      X=ARG[2];
      XX=0.5*X/R;
      if(XX>65000.0)
    {VIEW=0.;
    return VIEW;}
      VIEW=(XX*XX+0.5)/sqrt(1.+XX*XX)-XX;
      return VIEW;}
  case 32:
      {if(NARG!=2) goto ii;
      H=ARG[1];
      W=ARG[2];
      HW=H/W;
      VIEW=sqrt(1.+HW*HW)-HW;
      return VIEW;}
  case 33:
      {if(NARG!=2) goto ii;
      H=ARG[1];
      W=ARG[2];
      HW=H/W;
      VIEW=0.5*(1.+HW-sqrt(1.+HW*HW));
      return VIEW;}
  case 34:
      {if(NARG!=1) goto ii;
      if(ARG[1]>180.)
        {VIEW=0.;
    return VIEW;}
      ALPHA2=ARG[1]*PI/360.;
      VIEW=1.-sin(ALPHA2);
      return VIEW;}
  case 35:
      {if(NARG!=2) goto ii;
      R=ARG[1];
      S=ARG[2];
      X=1+0.5*S/R;
      VIEW=(asin(1./X)+sqrt(X*X-1.)-X)/PI;
      return VIEW;}
  case 36:
      {if(NARG!=3) goto ii;
      R1=ARG[1];
      R2=ARG[2];
      S=ARG[3];
      RR=R2/R1;
      SS=S/R1;
      C=1.+RR+SS;
      VIEW=(PI+sqrt(C*C-pow((RR+1.),2))-sqrt(C*C-pow((RR-1.),2))
             +(RR-1)*acos((RR-1.)/C)-(RR+1)*acos((RR+1.)/C))/(2.*PI);
      return VIEW;}
  case 37:
      {if(NARG!=3) goto ii;
      A=ARG[1];
      B1=ARG[2];
      B2=ARG[3];
      BB1=B1/A;
      BB2=B2/A;
      VIEW=(atan(BB1)-atan(BB2))/(2.*PI);
      return VIEW;}
  case 38:
      {if(NARG!=3) goto ii;
      A=ARG[1];
      B=ARG[2];
      C=ARG[3];
      X=A/C;
      Y=B/C;
      if(X<0.002 || Y<0.002)
        {VIEW=0.0;
    return VIEW;}
      RTX=sqrt(1.+X*X);
      RTY=sqrt(1.+Y*Y);
      RT=sqrt(1.+X*X+Y*Y);
      VIEW=(log(RTX*RTY/RT)+X*RTY*atan(X/RTY)+Y*RTX*atan(Y/RTX)
                         -X*atan(X)-Y*atan(Y))*2./(PI*X*Y);
      return VIEW;}
  case 39:
      {if(NARG!=3) goto ii;
      H=ARG[1];
      L=ARG[2];
      W=ARG[3];
      HH=H/L;
      WW=W/L;
      W2=WW*WW;
      H2=HH*HH;
      HW2=H2+W2;
      HW=sqrt(H2+W2);
      H12=H2+1.;
      W12=W2+1.;
      C1=W12*H12/(H12+W2);
      C2=W2*(H12+W2)/W12/HW2;
      C3=H2*(H12+W2)/H12/HW2;
      VIEW=(WW*atan(1./WW)+HH*atan(1./HH)-HW*atan(1./HW)
         +.25*(log(C1)+W2*log(C2)+H2*log(C3)))/(PI*WW);
      return VIEW;}
  case 40:
      {if(NARG!=3) goto ii;
      A=ARG[1];
      R1=ARG[2];
      R2=ARG[3];
      RR1=R1/A;
      RR2=R2/A;
      X=1.+(1.+RR2*RR2)/(RR1*RR1);
      VIEW=0.5*(X-sqrt(X*X-4.*pow((R2/R1),2)));
      return VIEW;}
  case 41:
      {if(NARG!=3) goto ii;
      L=ARG[1];
      R1=ARG[2];
      R2=ARG[3];
      RR=R1/R2;
      if(RR>1.)
       {cout<<"R2 MUST BE LESS THAN R1"<<endl;
       VIEW=0.;
       return VIEW;}
      BL=L/R2;
      if(BL>1000.)
       {VIEW=0.;
       return VIEW;}
      AA=BL*BL+RR*RR-1.;
      BB=BL*BL-RR*RR+1.;
      VIEW=BB/(8.*RR*BL)+(acos(AA/BB)
        -sqrt(pow(((AA+2.)/RR),2)-4.)/(2.*BL)*acos(AA*RR/BB)
        -AA/(2.*RR*BL)*asin(RR))/(2.*PI);
      return VIEW;}
  case 42:
      {if(NARG!=2) goto ii;
      H=ARG[1];
      R=ARG[2];
      HH=0.5*H/R;
      VIEW=1.+HH-sqrt(1.+HH*HH);
      return VIEW;}
  case 43:
      {if(NARG!=2) goto ii;
      H=ARG[1];
      R=ARG[2];
      HH=0.5*H/R;
        VIEW=2.*HH*(sqrt(1.+HH*HH)-HH);
      return VIEW;}
  case 44:
      {if(NARG!=3) goto ii;
      H=ARG[1];
      R1=ARG[2];
      R2=ARG[3];
      RR=R2/R1;
     if(RR<1.)
    {cout<<"R2 MUST BE GREATER THAN R1"<<endl;
    VIEW=0.;
    return VIEW;}
      HH=H/R1;
      AA=HH*HH+4.*RR*RR;
      BB=4.*(RR*RR-1.);
      VIEW=1.-1./RR-(sqrt(AA)-HH)/(4.*RR)+(2./RR*atan(sqrt(BB)/HH)
        -HH/(2.*RR)*(sqrt(AA)/HH*asin((HH*HH*(1.-2./RR/RR)+BB)/(AA-4.))
        -asin((RR*RR-2.)/RR/RR)))/PI;
      return VIEW;}
  case 45:
        {if(NARG!=3) goto ii;
      H=ARG[1];
      R1=ARG[2];
      R2=ARG[3];
      RR=R2/R1;
      if(RR<1.)
    {cout<<"R2 MUST BE GREATER THAN R1"<<endl;
        VIEW=0.;
    return VIEW;}
      HH=H/R1;
      if(HH>6250.)
    {VIEW=1.;
    return VIEW;}
      AA=HH*HH+RR*RR-1.;
      BB=HH*HH-RR*RR+1.;
      CC=HH*HH+RR*RR+1.;
      VIEW=1.-AA/(4.*HH)-(acos(BB/AA)
        -sqrt(CC*CC-4.*RR*RR)/(2.*HH)*acos(BB/RR/AA)
        -BB/(2.*HH)*asin(1./RR))/PI;
      return VIEW;}
  case 46:
      {if(NARG!=3) goto ii;
      H=ARG[1];
      R1=ARG[2];
      R2=ARG[3];
      RR=R1/R2;
      if(RR>1.)
    {cout<<"R2 MUST BE GREATER THAN R1"<<endl;
    VIEW=0.;
    return VIEW;}
      HH=H/R1;
      AA=1.-RR*RR-HH*HH;
      BB=1.-RR*RR+HH*HH;
      CC=1.+HH*HH+RR*RR;
      X=sqrt(1.-RR*RR);
      Y=RR*AA/BB;
      VIEW=(RR*(atan(X/HH)-atan(2.*X/HH))+0.25*HH*(asin(2.*RR*RR-1.)-asin(RR))
        +0.25*X*X/HH*(0.5*PI+asin(RR))-0.25*sqrt(CC*CC-4.*RR*RR)/HH*(0.5*PI+asin(Y))
    +0.25*sqrt(4.+HH*HH)*(0.5*PI+asin(1.-2.*RR*RR*HH*HH/(4.*X*X+HH*HH))))/PI;
      return VIEW;}
  case 47:
      {if(NARG!=3) goto ii;
      D=ARG[1];
      L1=ARG[2];
      L2=ARG[3];
      D1=D/L1;
      D2=D/L2;
      VIEW=0.25*atan(1./sqrt(D1*D1+D2*D2+D1*D1*D2*D2))/PI;
      return VIEW;}
  case 48:
      {if(NARG!=2) goto ii;
      A=ARG[1];
      R=ARG[2];
      RR=R/A;
      VIEW=0.5*(1.-1./sqrt(1.+RR*RR));
      return VIEW;}
  case 49:
      {if(NARG!=2) goto ii;
      A=ARG[1];
      R=ARG[2];
      RR=R/A;
      VIEW=1./sqrt(1.+RR*RR);
      return VIEW;}
  case 50:
      {if(NARG!=4) goto ii;
      R1=ARG[1];
      R2=ARG[2];
      S=ARG[3];
      OM=ARG[4];
      SS=S/R1;
      RR=R2/R1;
      A=asin(1./(SS+1.))*180./PI;
      if(OM<A) cout<<"Formula only valid for OM > "<<A<<"deg"<<endl;
      OM=OM*PI/180.;
      SR=1.+SS+RR/tan(OM);
      VIEW=0.5*(1.-SR/sqrt(SR*SR+RR*RR));
      return VIEW;}
 case 51:
     {if(NARG!=2) goto ii;
      D=ARG[1];
      S=ARG[2];
      SS=D/S;
      if(SS>1)
    {cout<<"D MUST BE LESS THAN S"<<endl;
    VIEW=0.;
    return VIEW;}
      VIEW=SS*acos(SS)+1.-sqrt(1.-SS*SS);
      return VIEW;}
      }
i:    cout<<"***ILLEGAL VALUE FOR NO (NO ="<<NO<<"), MUST BE 1<=NO>=51 ***"<<endl;
VIEW=0.;
return VIEW;
ii:   cout<<"*** WRONG VALUE OF NARG (NARG ="<<NARG<<") FOR NO ="<<NO<<"***"<<endl;
VIEW=0.;
return VIEW;
}



//***********************************************************************************
double perppltf(double X1,double X2,double Y1,double Y2,double Z1,double Z2,double Z3)
{
//  *************************************************************************
// *  THIS SUBROUTINE EVALUATES THE VIEW FACTOR BETWEEN TWO PERPENDICULAR, *
//  *  RECTANGULAR pltf OF SIZE (X2-X1)xZ1 AND (Y2-Y1)x(Z3-Z2), DISPLACED *
//  *  FROM ANOTHER BY Z2 IN THE Z-DIRECTION, BY X1 IN THE X-DIRECTON, AND  *
//  *  BY Y1 IN THE Y-DIRECTION, IN TERMS OF VIEW FACTORS OF DIRECTLY       *
//  *  ADJACENT, IDENTICAL RECTANGLES (CONFIG. 39), AS SHOWN IN FIG.4-15a   *
//  *************************************************************************

double perppltf,A,F,ARG[6];
int NARG;

      NARG=3;
      F=0.;
      ARG[1]=Y2;
      ARG[2]=Z3;
      ARG[3]=X2;
      A=X2*Z3;
      if(fabs(A*Y2)>1E-6) F=A*VIEW(39,NARG,ARG);
      ARG[1]=Y1;
      A=X2*Z3;
      if(fabs(A*Y1)>1E-6) F=F-A*VIEW(39,NARG,ARG);
      ARG[1]=Y2;
      ARG[3]=X1;
      A=X1*Z3;
      if(fabs(A*Y2)>1E-6) F=F-A*VIEW(39,NARG,ARG);
      ARG[1]=Y1;
      A=X1*Z3;
      if(fabs(A*Y1)>1E-6) F=F+A*VIEW(39,NARG,ARG);
      ARG[1]=Y2;
      ARG[2]=Z2;
      A=X1*Z2;
      if(fabs(A*Y2)>1E-6) F=F+A*VIEW(39,NARG,ARG);
      ARG[1]=Y1;
      A=X1*Z2;
      if(fabs(A*Y1)>1E-6) F=F-A*VIEW(39,NARG,ARG);
      ARG[1]=Y2;
      ARG[3]=X2;
      A=X2*Z2;
      if(fabs(A*Y2)>1E-6) F=F-A*VIEW(39,NARG,ARG);
      ARG[1]=Y1;
      A=X2*Z2;
      if(fabs(A*Y1)>1E-6) F=F+A*VIEW(39,NARG,ARG);
      ARG[1]=Y2;
      ARG[2]=(Z3-Z1);
      A=X2*(Z3-Z1);
      if(fabs(A*Y2)>1E-6) F=F-A*VIEW(39,NARG,ARG);
      ARG[1]=Y1;
      A=X2*(Z3-Z1);
      if(fabs(A*Y1)>1E-6) F=F+A*VIEW(39,NARG,ARG);
      ARG[1]=Y2;
      ARG[3]=X1;
      A=X1*(Z3-Z1);
      if(fabs(A*Y2)>1E-6) F=F+A*VIEW(39,NARG,ARG);
      ARG[1]=Y1;
      A=X1*(Z3-Z1);
      if(fabs(A*Y1)>1E-6) F=F-A*VIEW(39,NARG,ARG);
      ARG[1]=Y2;
      ARG[2]=(Z2-Z1);
      ARG[3]=X2;
      A=X2*(Z2-Z1);
      if(fabs(A*Y2)>1E-6) F=F+A*VIEW(39,NARG,ARG);
      ARG[1]=Y1;
      A=X2*(Z2-Z1);
      if(fabs(A*Y1)>1E-6) F=F-A*VIEW(39,NARG,ARG);
      ARG[1]=Y2;
      ARG[3]=X1;
      A=X1*(Z2-Z1);
      if(fabs(A*Y2)>1E-6) F=F-A*VIEW(39,NARG,ARG);
      ARG[1]=Y1;
      A=X1*(Z2-Z1);
      if(fabs(A*Y1)>1E-6) F=F+A*VIEW(39,NARG,ARG);
      perppltf=F/(2.*(X2-X1)*Z1);
      return perppltf;
}
//***********************************************************************************
double parlpltf(double X1,double X2,double X3,double Y1,double Y2,double Y3,double C)
{
//  *************************************************************************
//  *  THIS SUBROUTINE EVALUATES THE VIEW FACTOR BETWEEN TWO PARALLEL,      *
//  *  RECTANGULAR pltf OF SIZE X1xY1 AND (X3-X2)x(Y3-Y2), DISPLACED      *
//  *  FROM ANOTHER BY C IN THE Z-DIRECTION, BY X2 IN THE X-DIRECTON, AND   *
//  *  BY Y2 IN THE Y-DIRECTION, IN TERMS OF VIEW FACTORS OF DIRECTLY       *
//  *  OPPOSITE, IDENTICAL RECTANGLES (CONFIG. 38), AS SHOWN IN FIG.4-15b   *
//  *************************************************************************
double parlpltf,A,F,ARG[6];
int NARG;

      NARG=3;
      ARG[1]=X3;
      ARG[2]=Y3;
      ARG[3]=C;
      A=ARG[1]*ARG[2];
      if(fabs(A)>1E-6) F=A*VIEW(38,NARG,ARG);
      ARG[2]=Y2;
      A=ARG[1]*ARG[2];
      if(fabs(A)>1E-6) F=F-A*VIEW(38,NARG,ARG);
      ARG[2]=Y3-Y1;
      A=ARG[1]*ARG[2];
      if(fabs(A)>1E-6) F=F-A*VIEW(38,NARG,ARG);
      ARG[2]=Y2-Y1;
      A=ARG[1]*ARG[2];
      if(fabs(A)>1E-6) F=F+A*VIEW(38,NARG,ARG);
      ARG[1]=X2;
      ARG[2]=Y3;
      A=ARG[1]*ARG[2];
      if(fabs(A)>1E-6) F=F-A*VIEW(38,NARG,ARG);
      ARG[2]=Y2;
      A=ARG[1]*ARG[2];
      if(fabs(A)>1E-6) F=F+A*VIEW(38,NARG,ARG);
      ARG[2]=Y3-Y1;
      A=ARG[1]*ARG[2];
      if(fabs(A)>1E-6) F=F+A*VIEW(38,NARG,ARG);
      ARG[2]=Y2-Y1;
      A=ARG[1]*ARG[2];
      if(fabs(A)>1E-6) F=F-A*VIEW(38,NARG,ARG);
      ARG[1]=X3-X1;
      ARG[2]=Y3;
      A=ARG[1]*ARG[2];
      if(fabs(A)>1E-6) F=F-A*VIEW(38,NARG,ARG);
      ARG[2]=Y2;
      A=ARG[1]*ARG[2];
      if(fabs(A)>1E-6) F=F+A*VIEW(38,NARG,ARG);
      ARG[2]=Y3-Y1;
      A=ARG[1]*ARG[2];
      if(fabs(A)>1E-6) F=F+A*VIEW(38,NARG,ARG);
      ARG[2]=Y2-Y1;
      A=ARG[1]*ARG[2];
      if(fabs(A)>1E-6) F=F-A*VIEW(38,NARG,ARG);
      ARG[1]=X2-X1;
      ARG[2]=Y3;
      A=ARG[1]*ARG[2];
      if(fabs(A)>1E-6) F=F+A*VIEW(38,NARG,ARG);
      ARG[2]=Y2;
      A=ARG[1]*ARG[2];
      if(fabs(A)>1E-6) F=F-A*VIEW(38,NARG,ARG);
      ARG[2]=Y3-Y1;
      A=ARG[1]*ARG[2];
      if(fabs(A)>1E-6) F=F-A*VIEW(38,NARG,ARG);
      ARG[2]=Y2-Y1;
      A=ARG[1]*ARG[2];
      if(fabs(A)>1E-6) F=F+A*VIEW(38,NARG,ARG);
      parlpltf=F/(4.*(X1*Y1));
      return parlpltf;
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
