
#include <iostream.h>
#include <fstream.h>
#include <iomanip.h>
#include <math.h>

    const int II=41,JJ=21,KK=1,IRE=0;
    
    void SOR(double&,double&,double,double,int,double&,int&,int,int&,double&);
    void P1SOR(double,double,double [],double [],double [][JJ+1],double [][II+1],double [][JJ+1],double [][JJ+1],double [][JJ+1],double [][JJ+1],double [][JJ+1],double[][JJ+1],double[][II+1]);
    

//*******************************************************************************************************************
void P1SOR(double L,double R,double EPSX[],double EPSR[],double SX[][JJ+1],double SR[][II+1],double KT[][JJ+1],double ST[][JJ+1],double A1[][JJ+1],double SS[][JJ+1],double G[][JJ+1],double QX[][JJ+1],double QR[][II+1])
{
// SUBROUTINE P1SUB CALCULATES INTERNAL INCIDENT RADIATION G AND WALL FLUXES Q
// FOR A 2-DIMENSIONAL RECTANGULAR OR AXISYMMETRIC ENCLOSURE BY THE P-1 APPROXIMATION
// ALLOWS FOR ARBITRARY SPATIAL VARIATION OF ABSORPTION/SCATTERING COEFFICIENTS, AS
// WELL AS LINEAR-ANISOTROPY, AND ALSO WALL AND INTERNAL SOURCES
// CAN BE USED FOR A GRAY MEDIUM OR ON A SPECTRAL BASIS
// USES SUCCESSIVE OVERRELAXTION (SOR) METHOD WITH OPTIMIZED SOR PARAMETER TO SOLVE SIMULTANEOUS EQUATIONS
// INPUT:
//   II  =   NUMBER OF NODES IN X-DIRECTION
//   JJ  =   NUMBER OF NODES IN Y- OR R-DIRECTION
//   KK  =   0 FOR RECTANGULAR, KK  =  1 FOR CYLINDRICAL ENCLOSURE
//   IRE =   RADIATIVE EQUILIBRIUM IDENTIFIER; IRE=0: NO EQUILIBRIUM; IRE=1: RADIATIVE EQUILIBRIUM 
//   L   =   LENGTH OF ENCLOSURE (CM)
//   R   =   HEIGHT (RECTANGLE) OR RADIUS (CYLINDER) OF ENCLOSURE (CM)
//   EPSX=   WALL EMITTANCES, EPSX(1) AT X=0, EPSX(2) AT X=L
//   EPSR=   WALL EMITTANCES, EPSR(1) AT Y=0 (FOR RECTANGLE ONLY), EPSR(2) AT Y,r=R
//   SX  =   SOURCES AT X-DIR WALLS:
//           SX(1,j=1,2,...JJ) SOURCE AT X=0 FOR VARYING Y/r-NODES
//           SX(2,j=1,2,...JJ) SOURCE AT X=L FOR VARYING Y/r-NODES
//           (FOR A STANDARD, GRAY APPLICATION SX=4*SIGMA*T^4, IN W/CM^2)
//   SR  =   SOURCES AT Y/r-DIR WALLS:
//           SR(1,i=1,2,...II) SOURCE AT Y=0 FOR VARYING X-NODES (RECTANGLE ONLY)
//           SR(2,i=1,2,...II) SOURCE AT Y/r=R FOR VARYING X-NODES
//           (FOR A STANDARD, GRAY APPLICATION SR=4*SIGMA*T^4, IN W/CM^2)
//   KT  =   KT(II,JJ) = ABSORPTION COEFFICIENT FOR ALL INTERNAL NODES (CM^-1)
//   ST  =   ST(II,JJ) = SCATTERING COEFFICIENT FOR ALL INTERNAL NODES (CM^-1)
//   A1  =   A1(II,JJ) = LINEAR ANISOTROPY FACTOR FOR ALL INTERNAL NODES
//   SS  =   SS(II,JJ) = SOURCES FOR ALL INTERNAL NODES (W/CM^2)
//           (FOR A STANDARD, GRAY APPLICATION SS=4*SIGMA*T^4, IN W/CM^2)
// OUTPUT:
//   G   =   G(II,JJ) = INCIDENT RADIATION FOR ALL INTERNAL NODES (W/CM^2)
//   QX  =   FLUXES AT X-DIR WALLS:
//           QX(1,j=1,2,...JJ) FLUX AT X=0 FOR VARYING Y/r-NODES
//           QX(2,j=1,2,...JJ) FLUX AT X=L FOR VARYING Y/r-NODES
//           (POSITIVE INTO POSITIVE X-DIRECTION)
//   QR  =   FLUXES AT Y/r-DIR WALLS:
//           QR(1,i=1,2,...II) FLUX AT Y=0 FOR VARYING X-NODES (RECTANGLE ONLY)
//           QR(2,i=1,2,...II) FLUX AT Y/r=R FOR VARYING X-NODES
//           (POSITIVE INTO POSITIVE Y/r-DIRECTION)
//

      int I,J,IM1,IP1,JM1,JP1,NUMIT,ITMAX,ICONV;
      double BR[3],BX[3],GN[II+1][JJ+1];
      double AA[II+1][JJ+1],BB[II+1][JJ+1],CC[II+1][JJ+1],DD[II+1][JJ+1],EE[II+1][JJ+1],FF[II+1][JJ+1];
      double BT[II+1][JJ+1];
      double XTRA,SIP,OM,SUMER,YUN,DNP,DELX,DELR,DR2,SRCT;
      if(IRE!=0 && IRE!=1) 
        {cout<<"ILLEGAL VALUE IRE ="<<IRE<<"  EXECUTION TERMINATED"<<endl;
         return;}
      if(KK!=0 && KK!=1) 
        {cout<<"ILLEGAL VALUE KK ="<<KK<<"  EXECUTION TERMINATED"<<endl;
     return;}
     
      for (I=1;I<=2;I=I+1)
        {BR[I]=1.5E0*EPSR[I]/(2.E0-EPSR[I]); // BOUNDARY CONDITION FUNCTION
         BX[I]=1.5E0*EPSX[I]/(2.E0-EPSX[I]);}// BOUNDARY CONDITION FUNCTION
      for (I=1;I<=II;I=I+1)
        {for (J=1;J<=JJ;J=J+1)
      {BT[I][J]=KT[I][J]+ST[I][J];}}     // EXTINCTION COEFFICIENT
      for (I=1;I<=II;I=I+1)
        {for (J=1;J<=JJ;J=J+1)
      {BT[I][J]=BT[I][J]-A1[I][J]*ST[I][J]/3.E0;}}  // MODIFIED EXTINCTION COEFFICIENT
      if (JJ>1) DELR=R/(JJ-1.E0);
      else DELR=1.E10;                  // FOR 1D SLAB (JJ=1)
      if(II>1) DELX=L/(II-1.E0);
      else DELX=1.E10;                  // FOR 1D CYLINDER (II=1)
      DR2=pow((DELX/DELR),2.);

// COEFFICIENTS FOR S.O.R.

// INTERNAL
      for (I=1;I<=II;I=I+1)
        {
        IM1=I-1+(1/I);            // i-1 with a minimum of 1 at i=1 (to avoid out-of-bounds call)
        IP1=I+1-(I/II);           // i+1 with a maximum of II at i=II (to avoid out-of-bounds call)
        for (J=1;J<=JJ;J=J+1)
        {
            JM1=J-1+(1/J);        // j-1 with a minimum of 1 at j=1 (to avoid out-of-bounds call)  
            JP1=J+1-(J/JJ);       // j+1 with a maximum of JJ at j=JJ (to avoid out-of-bounds call)
            AA[I][J]=2.E0*BT[I][J]/(BT[IM1][J]+BT[I][J]+1.E-16);      // coefficient for G(i-1,j)
            BB[I][J]=2.E0*BT[I][J]/(BT[IP1][J]+BT[I][J]+1.E-16);      // coefficient for G(i+1,j)
            if(KK==0) 
                {CC[I][J]=2.E0*DR2*BT[I][J]/(BT[I][JM1]+BT[I][J]+1.E-16);  // coefficient for G(i,j-1) for rectangle
                DD[I][J]=2.E0*DR2*BT[I][J]/(BT[I][JP1]+BT[I][J]+1.E-16);}  // coefficient for G(i,j+1) for rectangle
            else if (J>1) 
                {CC[I][J]=2.e0*DR2*BT[I][J]/(BT[I][JM1]+BT[I][J]+1.E-16)*(1.E0-.5E0/JM1);  // coefficient for G(i,j-1) for cylinder
                DD[I][J]=2.E0*DR2*BT[I][J]/(BT[I][JP1]+BT[I][J]+1.E-16)*(1.E0+.5E0/JM1);}  // coefficient for G(i,j+1) for cylinder
            else
                {CC[I][J]=0.E0;                // cylinder centerline
                DD[I][J]=2.E0*(KK+1)*DR2;}     // cylinder centerline
            SRCT=3.E0*BT[I][J]*DELX*DELX;
            FF[I][J]=SRCT*(IRE+(1-IRE)*KT[I][J])*SS[I][J];                          // nonhomogeneous/source term (i,j)
            EE[I][J]=SRCT*(1-IRE)*KT[I][J]+AA[I][J]+BB[I][J]+CC[I][J]+DD[I][J];     // coefficient for G(i,j)
            }
        }
// R-WALLS                                    correction to G-coefficients using artificial nodes
      for (I=1;I<=II;I=I+1)
        {
        CC[I][JJ]=CC[I][JJ]+DD[I][JJ];
        XTRA=2.E0*BT[I][JJ]*DELR*BR[2]*DD[I][JJ];
        EE[I][JJ]=EE[I][JJ]+XTRA;
        FF[I][JJ]=FF[I][JJ]+XTRA*SR[2][I];
        DD[I][JJ]=0.E0;
        if(KK==0) 
            {DD[I][1]=CC[I][1]+DD[I][1];
            XTRA=2.E0*BT[I][1]*DELR*BR[1]*CC[I][1];
            EE[I][1]=EE[I][1]+XTRA;
            FF[I][1]=FF[I][1]+XTRA*SR[1][I];
            CC[I][1]=0.E0;}
        }
// X-WALLS                                   correction to G-coefficients using artificial nodes
      for (J=1;J<=JJ;J=J+1)
        {
        BB[1][J]=AA[1][J]+BB[1][J];
        XTRA=2.E0*BT[1][J]*DELX*BX[1]*AA[1][J];
        EE[1][J]=EE[1][J]+XTRA;
        FF[1][J]=FF[1][J]+XTRA*SX[1][J];
        AA[1][J]=0.E0;
        AA[II][J]=AA[II][J]+BB[II][J];
        XTRA=2.E0*BT[II][J]*DELX*BX[2]*BB[II][J];
        EE[II][J]=EE[II][J]+XTRA;
        FF[II][J]=FF[II][J]+XTRA*SX[2][J];
        BB[II][J]=0.E0;
        }

// NORMALIZE COEFFICIENTS
      for (I=1;I<=II;I=I+1)
        {for (J=1;J<=JJ;J=J+1)
        {
            AA[I][J]=AA[I][J]/EE[I][J];
            BB[I][J]=BB[I][J]/EE[I][J];
            CC[I][J]=CC[I][J]/EE[I][J];
            DD[I][J]=DD[I][J]/EE[I][J];
            FF[I][J]=FF[I][J]/EE[I][J];
            }
        }

// S.O.R. ITERATION

      SIP=1.E-6;      // STOPPING CRITERION FOR ITERATION  (see SOR below)
      NUMIT=0;
      ITMAX=800; 
      for (I=1;I<=II;I=I+1)
        {for (J=1;J<=JJ;J=J+1)
        {G[I][J]=0.;}}
      OM=1.4;
// ROUTINE TO OPTIMIZE OVERRELAXATION CONSTANT OM
VII:  SOR(DNP,DNP,YUN,SIP,0,OM,ICONV,ITMAX,NUMIT,OM);
      SUMER=0.E0;
      YUN=0.E0;
      for (J=1;J<=JJ;J=J+1)
          {
          JM1=J-1+(int)(1/J);
          JP1=J+1-(int)(J/JJ);
          for (I=1;I<=II;I=I+1)
         {
             IM1=I-1+(int)(1/I);
             IP1=I+1-(int)(I/II);
             GN[I][J]=OM*(CC[I][J]*GN[I][JM1]+AA[I][J]*GN[IM1][J]+DD[I][J]*G[I][JP1]+BB[I][J]*G[IP1][J]+FF[I][J])+(1.E0-OM)*G[I][J];
             SUMER=SUMER+pow((GN[I][J]-G[I][J]),2.);
             if(GN[I][J]>YUN) YUN=GN[I][J];
             }
      }
 
      for (I=1;I<=II;I=I+1)
        {
        for (J=1;J<=JJ;J=J+1)
      {G[I][J]=GN[I][J];}}
      DNP=SUMER/YUN;

// CONVERGENCE CHECK

      if(ICONV==0) goto VII;
      if(NUMIT>ITMAX) cout<<"          ITERATION DID NOT CONVERGE!"<<endl;       
      cout<<"     NUMBER OF ITERATIONS:"<<NUMIT<<"  2-NORM ERROR:  "<<DNP<<endl;

// CALCULATION OF WALL FLUXES

      for (I=1;I<=II;I=I+1)
        {
        if(KK==0) QR[1][I]=(SR[1][I]-G[I][1])/3.E0*BR[1];
        QR[2][I]=(G[I][JJ]-SR[2][I])/3.E0*BR[2];
        }
        for (J=1;J<=JJ;J=J+1)
      {
          QX[1][J]=(SX[1][J]-G[1][J])/3.E0*BX[1];
          QX[2][J]=(G[II][J]-SX[2][J])/3.E0*BX[2];
      }
}

//*******************************************************************************************************************

//*******************************************************************************************************************
    void SOR(double& DELNP,double& DELNE,double YUN,double SIP,int NPRT,double& OM,int& ICONV,int ILIMIT,int& ITP,double& OME)
{
// SUBROUTINE SOR IS AN IMPLEMENTATION OF ALGORITHM 9-6.1 GIVEN IN
// *APPLIED ITERATIVE METHODS* BY LOUIS A. HAGEMAN AND DAVID M. YOUNG,
// ACADEMIC PRESS, 1981.

// SOR COMPUTES THE OVERRELAXATION PARAMETER OMEGA AND MEASURES THE
// ITERATION ERROR VECTOR FOR THE SUCCESSIVE OVERRELAXATION METHOD.
// THIS SUBROUTINE MUST BE ENTERED BEFORE EVERY SOR ITERATION. ON EXIT,
// OM IS THE VALUE OF OMEGA TO USE ON THE NEXT ITERATION.

//  ITP    = # OF ITERATION (=0 ON FIRST ENTRY)
//  OME    = OLD (OR INITIAL) VALUE FOR OMEGA
//  ILIMIT = UPPER LIMIT OF ITERATIONS
// REMARK 1: SET OME=1.0 INITIALLY UNLESS SOME A-PRIORI INFORMATION IS
//       KNOWN.
// REMARK 2: IF FIXED VALUE OF OMEGA IS TO BE USED SET OME TO THE
//       NEGATIVE OF DESIRED VALUE.
// REMARK 3: AFTER FIRST ENTRY USER SHOULD NOT MODIFY ANY VARIABLES
//       EXCEPT DELNE,DELNP,YUN,SIP, AND NPRT.
//  NPRT   = PRINT CONTROL: =0 PRINTING ONLY AFTER CONVERGENCE
//              =1 PRINTING AFTER EVERY ITERATION.
//  DELNP  = THE 2-NORM OF THE DIFFERENCE VECTOR,EQ. 9-4.1.
//  DELNE  = THE BETA-NORM OF THE DIFFERENCE VECTOR.
//  YUN    = THE ETA-NORM OF THE LATEST SOLUTION VECTOR.
//  SIP    = STOPPING CRITERION NUMBER, ZETA, EQ. 9-5.17.
//  OM     = VALUE OF OMEGA FOR NEXT ITERATION
//  ICONV  = CONVERGENCE INDICATOR: =0 NO CONVERGENCE
//                  =1 CONVERGENCE
//                  =10 ILIMIT EXCEEDED
//  ITP    = ITERATION COUNTER.
//  DELNE  = ON EXIT GIVES ESTIMATE OF ITERATION ERROR (CF. SIP)

// WHENEVER OMEGA IS CHANGED AND NPRT=1, THE FOLLOWING IS PRINTED:
//  OMEG P. = NEW UNCORRECTED ESTIMATE OF OMEGA;
//  OMEG U. = NEW OMEGA TO BE USED AFTER TAU-TEST, EQ. 9-5.22;
//  P-HAT   = VALUE DEFINED BY EQ. 9-6.2
//  P-STAR  = VALUE DEFINED BY EQ. 9-5.20
//  MU      = ESTIMATE OF SPECTRAL RADIUS OF JACOBI MATRIX

    int P,PS,PH,I,J,IPWM,IS,INPRT,IPH,ITPP,ICS,ICIS,ITPD,IPRED;
    double TAU[9]={0.0,1.6,1.8,1.9,1.95,1.975,1.985,1.990,1.995};
    double EPS,XC,Z,XMUP,OMEP,R,FF,PSPP,RSPP,DELNO,TAUS,XOM1,XC1,XOCR,XWDEL,RO,H,RESDS,DELR,ZZ;
    
    ICONV=0;
    EPS=1.;
    XC=1.;
    IPWM=0;
    if(ITP>0) goto XIII;

// INITIALIZE
    P=-1;
    IS=0;
    Z=fabs(OME);
    if (Z<1.||Z>2.) OME=1.;
    XMUP=0.;
    if(Z>1.) XMUP=2.*sqrt(Z-1.)/Z;
    OMEP=OME;
    DELNP=1.;
    INPRT=0;
    R=1.;
    FF=.75;
    PSPP=.5;
    RSPP=.0001;

// NEXT ITERATION
I:  ITP=ITP+1;
    P=P+1;
    DELNO=DELNP;
    if(P>0) goto VIII;
// INITIALIZE FOR NEW ESTIMATE OF OMEGA
    ICS=0;
    IS=IS+1;
    PH=3;
    PS=6;
    OME=OMEP;
    if(IS>8) IS=8;
    TAUS=TAU[IS];
    if(OME>TAUS) OME=TAUS;
    if(OMEP<0.) OME=-OMEP;
    XOM1=OME-1.;
    XC1=XOM1/(2.-OME);
    IPH=(int)XC1;
    if(IPH>PH) PH=IPH;
    XOCR=1.;
    if(XOM1>0.) XOCR=log(XOM1);
    for (I=PS;I<=5000;I=I+1)
     {
     Z=(double)I;
     J=I-1;
     if((Z*pow(XOM1,J))<PSPP) goto III;
     }
    I=5000;
III:PS=I;
    if(OMEP>0.)  goto IV;
    PS=10000;
    goto V;
IV: if(XOM1>0.) goto V;
    PH=2;
    PS=3;
    IS=IS-1;
V:  XWDEL=RSPP;
    if(OME<=1.9) goto VI;
    Z=(pow((2.-OME),2.))*.01;
    if(Z<RSPP) XWDEL=Z;
VI: IPWM=1;

// CLEAN UP BEFORE EXIT
VIII:  DELNE=EPS;
    ITPP=ITP-1;
    if(ITPP>=ILIMIT) ICONV=10;
    if(ICONV>0) goto XIX;
    if(ITP==1) cout<<"0INITIAL ESTIMATE USED FOR OMEGA"<<endl;
    if(ITP==1) goto XI;
    if(NPRT==0) goto XII;
IX:   cout<<" I= "<<ITPP<<"   R="<<R<<"   CR= "<<XC<<"   EPS= "<<EPS<<"   ICONV= "<<ICONV<<endl;
XI: if(IPWM==1) cout<<"0OMEG P.= "<<OMEP<<"   OMEG U.= "<<OME<<"   P-HAT= "<<PH<<"   P-STAR= "<<PS<<"   MU= "<<XMUP<<endl;
    if(PS>=10000&&ICONV>0) goto XX;
XII: OM=OME;
return;

// STOPPING TEST
XIII:   RO=R;
    R=DELNP/DELNO;
    H=R;
    if(ITP==2) RESDS=DELNP;
    if(P<PH) goto I;
    if(R>=1.) goto I;
    if(R>XOM1) goto XIV;
    ICIS=ITP;
    H=XOM1;
    ICS=ICS+1;
XIV:   EPS=DELNE/(YUN*(1.-H));
    if(XOM1>0.) XC=log(R)/XOCR;
    if(EPS<SIP) ICONV=1;

// PARAMETER CHANGE TEST
XV:   if(P<PS) goto I;
    if(ICS==0) goto XVI;
    ITPD=ITP-ICIS;
// THIS TEST INVOLVING ICS AND ITPD IS NOT INCLUDED IN ALG. 9-6.1.
    if(ICS<3&&ITPD>40) goto XVI;
    goto I;
XVI:   if(OME>1.) goto XVII;
    Z=1.-R;
    OMEP=2./(1.+sqrt(Z));
    P=-1;
    XMUP=sqrt(R);
    goto I;
XVII:   Z=pow(XOM1,FF);
    if(R<Z) goto I;
    DELR=RO-R;
    Z=-10.*XWDEL;
    if(DELR<XWDEL&&DELR>=Z) goto XVIII;
    if(IS>2) goto I;
    Z=pow(XOM1,.1);
    if(R<Z) goto I;
XVIII:   XMUP=(R+XOM1)/(OME*sqrt(R));
    Z=1.-XMUP*XMUP;
    OMEP=2./(1.+sqrt(Z));
    P=-1;
    goto I;

// PRINT FINAL ESTIMATE FOR OMEGA IF NPRT=0
XIX:   if(INPRT!=0) goto IX;
    if(PS>=10000) goto IX;
    if(NPRT==1) goto IX;
    cout<<"0ITERATION SUMMARY"<<endl;
    INPRT=1;
    cout<<"0OMEG P.= "<<OMEP<<"   OMEG U.= "<<OME<<"   P-HAT= "<<PH<<"   P-STAR= "<<PS<<"   MU= "<<XMUP<<endl;
    goto IX;

// IF OMEGA IS FIXED, GIVE ESTIMATE OF ITS WORTH.
XX:   if(INPRT!=0) goto XII;
    INPRT=1;
    DELNP=-1.;
    if(R<1.) goto XXV;
XXI:   cout<<"0NUMERICAL RESULTS IMPLY THAT OMEGA= "<<OME<<" IS GREATER THAN OR EQUAL TO THE OPTIMAL VALUE."<<endl;
XXIII:   cout<<"0"<<endl;
    goto XII;
XXV:   IPRED=1;
    if(ICS==0) goto XXVI;
    ITPD=ITP-ICIS-1;
    if(ICS<3&&ITPD>40) goto XXVI;
    goto XXI;
XXVI:   Z=.0001;
    ZZ=-.001;
    DELR=RO-R;
    if(DELR<=Z&&DELR>=ZZ) IPRED=2;
    if(OME==1.) goto XXIX;
    XMUP=(R+XOM1)/(OME*sqrt(R));
XXVII:   Z=1.-XMUP*XMUP;
    DELNP=2./(1.+sqrt(Z));
    cout<<"0NUMERICAL RESULTS INDICATE THAT THE OPTIMAL OMEGA IS ABOUT "<<DELNP<<endl;
    if(IPRED==1) cout<<" THIS ESTIMATE IS QUESTIONABLE."<<endl;
    if(IPRED==2) cout<<" THIS ESTIMATE IS REASONABLE"<<endl;
    Z=1.;
    if(IPRED==1) Z=-1.;
    DELNP=Z*DELNP;
    goto XXIII;
XXIX: XMUP=sqrt(R);
    goto XXVII;
}
