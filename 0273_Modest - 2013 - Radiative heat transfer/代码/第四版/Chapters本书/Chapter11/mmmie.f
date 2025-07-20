      PROGRAM MMMIE
C THIS PROGRAM CALCULATES MIE COEFFICIENTS (SCATTERING COEFFICIENTS AN AND BN,
C EFFICIENCIES QSCA, QEXT AND QABS) AND RELATES THEM TO PARTICLE CLOUD 
C PROPERTIES (EXTINCTION COEFFICIENT BETA, ABSORPTION COEFFICIENT KAPPA, 
C SCATTERING COEFFICIENT SIGMA, SCATTERING PHASE FUNCTION ATOT)
C
      PARAMETER (NETAMAX=10, MAXN=500, MAXI=513) 
      IMPLICIT REAL*8 (A-H,O-Z)
      REAL*8 AN(MAXI),XMIE(MAXI),KSC(MAXI),KEX(MAXI),ANN(129,MAXI),   
     2     XL(30),XR(30),KSCAL(30),KSCAR(30),KEXTL(30),KEXTR(30),       
     2     ANL(30,MAXI),ANR(30,MAXI),SS(MAXI),KAPPA(30),SIGMA(30),         
     3     BETA(30),ATOT(30,MAXI),NPV,KAPP,KSCA,KEXT,ETAM(30),ER(MAXI)             
      INTEGER NM(MAXI),NML(30),NMR(30)                                   
      COMMON /BLK1/ AR(500),AI(500),BR(500),BI(500)                     
      COMMON /BLK2/ PN(500,181),TN(500,181),NMU                         
      COMPLEX*16 CIR                                                       
C                                                                       
      FR(R)=AMG*R**ALMG*DEXP(-BMG*R**GAMG)                               
      EPS=.002D0                                                          
      PI=4.D0*DATAN(1.D0)                                                    
      LU=9
      NETA=1
      OPEN(UNIT=8,FILE='MIE.DAT')
      OPEN(UNIT=LU,FILE='MIE.RES')
C                                                                       
C INPUT PARAMETERS:
C                                                                       
C CIR=COMPLEX INDEX OF REFRACTION                                       
C IDSTF=1: SINGLE PARTICLE SIZE; =2: MODIFIED GAMMA DISTRIBUTION        
C IETA=1: SINGLE WAVENUMBER; =2: WAVE NUMBER SPECTRUM                   
C IPRNT=1: PRINT ONLY FINAL RESULTS; =2: ALSO INTERMEDIATE INTEGRATIONS
C
C RMIN, RMAX= MINIMUM AND MAXIMUM PARTICLE SIZE IN GAMMA DISTRIBUTION
C             (IN MICROMETERS)
C AMG,BMG,ALMG,GAMG= CONSTANTS IN GAMMA DISTRIBUTION, SEE FORMULA ABOVE;
C     UNITS: AMG[CM^-3 MICRON^(ALMG+1)], ALMG[-], BMG[MICRON^-1], GAMG[-]
C NPV= NUMBER OF PARTICLES PER UNIT VOLUME (IN PARTICLES PER CUBIC CM)
C ETA= WAVENUMBER IF SINGLE WAVENUMBER IS CONSIDERED (IN CM-1)
C ETMIN, ETMAX= MINIMUM AND MAXIMUM ETA TO BE CONSIDERED
C NETA= NUMBER OF WAVENUMBERS TO BE CONSIDERED (EQUALLY SPACED BETWEEN ETMIN
C       AND ETMAX)
C ERRP= MAXIMUM ERROR ALLOWED FOR ABSORPTION/SCATTERING COEFFICIENTS 
C     OR ASYMMETRY FACTOR (IN %)
C ERRA= DIGITS OF ACCURACY DESIRED IN A_N FOR PHASE FUNCTION (IN 10**-DIGITS)
C
C NOTES:
C  -- PRESENTLY, NETA MAY NOT EXCEED THE VALUE 10. THIS MAY BE CHANGED BY
C        INCREASING THE VALUE OF NETAMAX BELOW, AS WELL AS EVERY VARIABLE
C        DIMENSIONED TO 10 (MAIN PROGRAM ONLY)
C
C  -- PRESENTLY, THE MAXIMUM SIZE PARAMETER MAY NOT EXCEED 300 (APPROX).
C        THIS MAY BE CHANGED BY INCREASING THE VALUE FOR MAXN BELOW, AS WELL AS
C        EVERY VARIABLE DIMENSIONED TO 500 (MAIN PROGRAM AND SUBROUTINES). MAXN
C        MAY BE ESTIMATED FROM
C                 MAXN=1.5*X+5.*(REAL(CIR)+DLOG(1.+X*X/50.))+3
C
C  -- PRESENTLY, THE MAXIMUM NUMBER OF NODES IN INTEGRATION OVER SIZE
C        PARAMETERS (OR OVER DISTRIBUTION FUNCTION) MAY NOT EXCEED 513.
C        THIS MAY BE CHANGED BY INCREASING THE VALUE FOR MAXI ABOVE.
      HFMAXNX=(MAXI-1)/2
C                                                                       
      READ(8,*) IDSTF,IETA,IPRNT,CIR
      IF(IDSTF.EQ.1) READ(8,*) RPART,NPV
      IF(IDSTF.EQ.2) READ(8,*) RMIN,RMAX,AMG,BMG,ALMG,GAMG,NPV
      IF(IETA.EQ.1)  READ(8,*) ETA
      IF(IETA.EQ.2)  READ(8,*) ETMIN,ETMAX,NETA
      IF(IDSTF*IETA.NE.1) READ(8,*) ERRP,ERRA
      IF(NETA.LE.NETAMAX) GOTO 1000
      WRITE(*,1010)
      STOP
C                                                                       
C PARAMETERS FOR SINGLE PARTICLE/SINGLE WAVENUMBER                      
C                                                                       
 1000 IF(IDSTF*IETA.NE.1) GOTO 1040
      XSPSE=2.D0*PI*RPART*ETA*1D-4                                        
      CALL FMIE(CIR,XSPSE,KSCA,KEXT,NMAX)                               
      CONST=PI*RPART**2*NPV*1D-8                                        
      BET=CONST*KEXT                                                    
      SIGM=CONST*KSCA                                                   
      KAPP=BET-SIGM                                                     
      WRITE(LU,1900)                                                     
      WRITE(LU,2000) RPART,CIR,NPV,XSPSE                                 
      CALL PITAU(XSPSE,NMAX)                                            
      CALL PHASE(NMAX,AN)                                               
      DO 1030 N=1,NMU                                                   
 1030 ATOT(1,N)=2.D0*AN(N)/(XSPSE**2*KSCA)                                
      NETA=1                                                            
      ETAM(1)=ETA                                                       
      XMIE(1)=XSPSE                                                     
      KAPPA(1)=KAPP                                                     
      SIGMA(1)=SIGM                                                     
      BETA(1)=BET                                                       
      NMAX2=NMAX+2                                                      
      GOTO 1310                                                         
C                                                                       
C PARAMETERS FOR SINGLE PARTICLE/WAVENUMBER SPECTRUM                    
C                                                                       
 1040 IF(IDSTF.NE.1) GOTO 1100                                          
      XMIN=2.D0*PI*RPART*ETMIN*1D-4                                       
      XMAX=2.D0*PI*RPART*ETMAX*1D-4                                       
      DELX=(XMAX-XMIN)/(NETA-1.D0)                                        
      DETA=(ETMAX-ETMIN)/(NETA-1.D0)                                      
      CONST=PI*RPART**2*NPV*1D-8                                        
      WRITE(LU,2010) RPART,CIR,NPV,ETMIN,ETMAX,NETA                      
      NMAX=1.5D0*XMAX+5.D0*(1.D0+DLOG(1.D0+XMAX*XMAX))                          
      CALL PITAU(XMAX,NMAX)                                             
C                                                                       
      DO 1050 IET=1,NETA                                                
      XMIE(IET)=XMIN+DELX*(IET-1)                                       
      ETAM(IET)=ETMIN+DETA*(IET-1)                                      
      CALL FMIE(CIR,XMIE(IET),KSCA,KEXT,NMAX)                           
      SIGMA(IET)=CONST*KSCA                                             
      BETA(IET)=CONST*KEXT                                              
      KAPPA(IET)=BETA(IET)-SIGMA(IET)                                   
      CALL PHASE(NMAX,AN)                                               
      DO 1045 N=1,NMU                                                   
 1045 ATOT(IET,N)=2.D0*AN(N)/(XMIE(IET)**2*KSCA)                          
 1050 CONTINUE                                                          
      GOTO 1310                                                         
C                                                                       
C PARAMETERS FOR PARTICLE DISTRIBUTION/SINGLE WAVENUMBER                
C                                                                       
 1100 IF(IETA.NE.1) GOTO 1110                                           
      ETMIN=ETA                                                         
      ETMAX=ETA                                                         
      NETA=1                                                            
      DETA=0.D0                                                           
      WRITE(LU,2020) ETA                                                 
      GOTO 1120                                                         
C                                                                       
C PARAMETERS FOR PARTICLE DISTRIBUTION/WAVENUMBER SPECTRUM              
C                                                                       
 1110 DETA=(ETMAX-ETMIN)/(NETA-1)                                       
      WRITE(LU,2030) ETMIN,ETMAX,NETA                                    
 1120 DO 1125  IET=1,NETA                                               
      ETAM(IET)=ETMIN+DETA*(IET-1)                                      
      BETA(IET)=0.D0                                                      
      SIGMA(IET)=0.D0                                                     
      DO 1125 N=1,500                                                   
 1125 ATOT(IET,N)=0.D0                                                    
      WRITE(LU,2040) RMIN,RMAX,CIR,NPV,AMG,ALMG,BMG,GAMG                 
      IMIN=0                                                            
      IMAX=0                                                            
      R1MIN=RMIN                                                        
      R1MAX=RMAX                                                        
      IF(BMG*GAMG.EQ.0.D0) GOTO 1175                                      
C                                                                       
      FRMAX=(ALMG/GAMG/BMG)**(1.D0/GAMG)                                  
      R1=1.D0                                                             
      KK=1                                                              
      C1=BMG*FRMAX**GAMG/(2.D0+ALMG)                                      
      EAL=EPS**(1.D0/(2.D0+ALMG))                                           
 1130 R2=EAL*DEXP(C1*(R1-1.D0))                                            
      IF(1.D0-R2/R1.LT.1.D-4) GOTO 1140                                   
      KK=KK+1                                                           
      R1=R2                                                             
      IF(KK.LE.30) GOTO 1130                                            
      WRITE(LU,2060)                                                     
      STOP                                                              
C                                                                       
 1140 R3=R2*FRMAX                                                       
      IMIN=RMIN/R3                                                      
      IMIN=1/(1+IMIN)                                                   
      R1MIN=(1-IMIN)*RMIN+IMIN*R3                                       
C                                                                       
      C2=1.D0-DLOG(EAL)/C1                                                
      R1=1.D0                                                             
      KK=1                                                              
 1150 R2=(C2+DLOG(R1)/C1)**(1.D0/GAMG)                                    
      IF(R2/R1-1.D0.LT.1.D-4) GOTO 1160                                   
      KK=KK+1                                                           
      R1=R2                                                             
      IF(KK.LE.30) GOTO 1150                                            
      WRITE(LU,2060)                                                     
      STOP                                                              
C                                                                       
 1160 R3=R2*FRMAX                                                       
      IMAX=R3/RMAX                                                      
      IMAX=1/(1+IMAX)                                                   
      R1MAX=(1-IMAX)*RMAX+IMAX*R3                                       
 1175 XMIN=2.D-4*PI*R1MIN*ETMIN                                         
      XMAX=2.D-4*PI*R1MAX*ETMAX                                         
      JMIN=XMIN/4                                                       
      JMAX=XMAX/4+1                                                     
      XMIN=(1-IMIN)*XMIN+IMIN*4*JMIN                                    
      XMAX=(1-IMAX)*XMAX+4*IMAX*JMAX                                    
      NMAX=1.5D0*XMAX+7+5*DLOG(1+XMAX*XMAX/50.D0)                           
      CALL PITAU(XMAX,NMAX)                                             
      WRITE(LU,2050) XMIN,XMAX                                           
C                                                                       
C PARAMETERS FOR LARGEST X IF NOT IN GRID                               
C                                                                       
      IF(IMAX.NE.0) GOTO 1210                                           
      DO 1200 IET=1,NETA                                                
      XR(IET)=2.D-4*PI*RMAX*ETAM(IET)                                   
      CALL FMIE(CIR,XR(IET),KSCAR(IET),KEXTR(IET),NMAX)                 
      NMR(IET)=NMAX                                                     
      CALL PHASE(NMAX,AN)                                               
      DO 1200 IMU=1,NMU                                                 
 1200 ANR(IET,IMU)=AN(IMU)                                              
C                                                                       
C                                                                       
C PARAMETERS FOR SMALLEST X IF NOT IN GRID                              
C                                                                       
 1210 IF(IMIN.NE.0) GOTO 1190                                           
      DO 1180 IET=1,NETA                                                
      XL(IET)=2.D-4*PI*RMIN*ETAM(IET)                                   
      CALL FMIE(CIR,XL(IET),KSCAL(IET),KEXTL(IET),NMAX)                 
      NML(IET)=NMAX                                                     
      CALL PHASE(NMAX,AN)                                               
      DO 1180 IMU=1,NMU                                                 
 1180 ANL(IET,IMU)=AN(IMU)                                              
C                                                                       
C                                                                       
C PARAMETERS FOR ALL X IN REGULAR GRID                                  
C                                                                       
 1190 NX=8                                                              
 1215 DX=4.D0*(JMAX-JMIN)/NX                                              
      IX1=2-8/NX                                                        
      NX1=NX+8/NX                                                       
      DO 1220 I=IX1,NX1,IX1                                             
      XMIE(I)=4.D0*JMIN+(I-1)*DX                                          
      IF(XMIE(I).LT.1D-3) XMIE(I)=1D-3                                  
      CALL FMIE(CIR,XMIE(I),KSC(I),KEX(I),NMAX)                         
 1217 NM(I)=NMAX                                                        
      CALL PHASE(NMAX,AN)                                               
      DO 1220 IMU=1,NMU                                                 
 1220 ANN(I,IMU)=AN(IMU)                                                
C                                                                       
C                                                                       
      ERRORA=0.D0                                                         
      ERROR=0.D0                                                          
      DO 1300 IET=1,NETA                                                
      IXL=1                                                             
      IXR=NX+1                                                          
      NMAX2=NMU+2                                                       
      DO 1230 N=1,NMAX2                                                 
 1230 SS(N)=0.D0                                                          
      IF(IMIN.NE.0) GOTO 1250                                           
C                                                                       
C CALCULATE INTEGRALS  FOR LEFT TAIL IF NOT IN GRID                     
C                                                                       
      I11=(XL(IET)-XMIE(1))/DX+1                                        
      IXL=((I11-1)/4)*4+5                                               
      F11=FR(XMIE(I11+1)/(2.D0*PI*ETAM(IET)))                             
      F1L=FR(RMIN)                                                      
      F1X1=XMIE(I11+1)**2*F11                                           
      F1XL=XL(IET)**2*F1L                                               
      F2XL=F1XL*KEXTL(IET)                                              
      F2X1=F1X1*KEX(I11+1)                                              
      F1XL=F1XL*KSCAL(IET)                                              
      F1X1=F1X1*KSC(I11+1)                                              
      SS(1)=SS(1)+F1XL*(XMIE(I11+1)-XL(IET))/2.D0                         
     1     +F1X1*(XMIE(I11)-XL(IET))/2.D0                                 
      SS(2)=SS(2)+F2XL*(XMIE(I11+1)-XL(IET))/2.D0                         
     1     +F2X1*(XMIE(I11)-XL(IET))/2.D0                                 
      DO 1235 N=3,NMAX2                                                 
      FNXL=F1L*ANL(IET,N-2)                                             
      FNX1=F11*ANN(I11+1,N-2)                                           
 1235 SS(N)=SS(N)+FNXL*(XMIE(I11+1)-XL(IET))/2.D0                         
     1     +FNX1*(XMIE(I11)-XL(IET))/2.D0                                 
      I111=I11+1                                                        
      DO 1240 IL=I111,IXL                                               
      F1=FR(XMIE(IL)/(2.D0*PI*ETAM(IET)))                                 
      F1X=XMIE(IL)**2*F1                                                
      F2X=F1X*KEX(IL)                                                   
      F1X=F1X*KSC(IL)                                                   
      SS(1)=SS(1)+(2-IL/IXL)*DX*F1X/2.D0                                  
      SS(2)=SS(2)+(2-IL/IXL)*DX*F2X/2.D0                                  
      DO 1240 N=3,NMAX2                                                 
 1240 SS(N)=SS(N)+(2-IL/IXL)*DX*F1X*ANN(IL,N-2)/2.D0                      
C                                                                       
C CALCULATE INTEGRALS FOR RIGHT TAIL IF NOT IN GRID                     
C                                                                       
 1250 IF(IMAX.NE.0) GOTO 1280                                           
      I22=(XR(IET)-XMIE(1)-1D-10)/DX+2                                  
      IXR=((I22-2)/4)*4+1                                               
      F1R=FR(RMAX)                                                      
      F12=FR(XMIE(I22-1)/(2.D0*PI*ETAM(IET)))                             
      F1XR=XR(IET)**2*F1R                                               
      F1X2=XMIE(I22-1)**2*F12                                           
      F2XR=F1XR*KEXTR(IET)                                              
      F2X2=F1X2*KEX(I22-1)                                              
      F1XR=F1XR*KSCAR(IET)                                              
      F1X2=F1X2*KSC(I22-1)                                              
      SS(1)=SS(1)+F1XR*(XR(IET)-XMIE(I22-1))/2.D0                         
     1           +F1X2*(XR(IET)-XMIE(I22))/2.D0                           
      SS(2)=SS(2)+F2XR*(XR(IET)-XMIE(I22-1))/2.D0                         
     1           +F2X2*(XR(IET)-XMIE(I22))/2.D0                           
      DO 1260 N=3,NMAX2                                                 
      FNXR=F1R*ANR(IET,N-2)                                             
      FNX2=F12*ANN(I22-1,N-2)                                           
 1260 SS(N)=SS(N)+FNXR*(XR(IET)-XMIE(I22-1))/2.D0                         
     1           +FNX2*(XR(IET)-XMIE(I22))/2.D0                           
      I222=I22-1                                                        
      DO 1270 IR=IXR,I222                                               
      F1=FR(XMIE(IR)/(2.D0*PI*ETAM(IET)))                                 
      F1X=XMIE(IR)**2*F1                                                
      F2X=F1X*KEX(IR)                                                   
      F1X=F1X*KSC(IR)                                                   
      SS(1)=SS(1)+(2-IXR/IR)*DX*F1X/2.D0                                  
      SS(2)=SS(2)+(2-IXR/IR)*DX*F2X/2.D0                                  
      DO 1270 N=3,NMAX2                                                 
 1270 SS(N)=SS(N)+(2-IXR/IR)*DX*F1*ANN(IR,N-2)/2.D0                       
C                                                                       
C CALCULATE INTEGRALS FOR REGULAR GRID                                  
C                                                                       
 1280 NINT=(IXR-IXL)/4                                                  
      CONST=2.D0*DX/45.D0                                                   
      CC=2.D-4*PI*ETAM(IET)                                             
      IF(NINT.EQ.0) GOTO 1295                                           
      DO 1290 IX=1,NINT                                                 
      IXX=IXL+4*IX-4                                                    
      F11=7.D0*CONST*FR(XMIE(IXX)/CC)                                     
      F12=32.D0*CONST*FR(XMIE(IXX+1)/CC)                                  
      F13=12.D0*CONST*FR(XMIE(IXX+2)/CC)                                  
      F14=32.D0*CONST*FR(XMIE(IXX+3)/CC)                                  
      F15=7.D0*CONST*FR(XMIE(IXX+4)/CC)                                   
      F1X1=XMIE(IXX)**2*F11                                             
      F1X2=XMIE(IXX+1)**2*F12                                           
      F1X3=XMIE(IXX+2)**2*F13                                           
      F1X4=XMIE(IXX+3)**2*F14                                           
      F1X5=XMIE(IXX+4)**2*F15                                           
      F2X1=F1X1*KEX(IXX)                                                
      F2X2=F1X2*KEX(IXX+1)                                              
      F2X3=F1X3*KEX(IXX+2)                                              
      F2X4=F1X4*KEX(IXX+3)                                              
      F2X5=F1X5*KEX(IXX+4)                                              
      F1X1=F1X1*KSC(IXX)                                                
      F1X2=F1X2*KSC(IXX+1)                                              
      F1X3=F1X3*KSC(IXX+2)                                              
      F1X4=F1X4*KSC(IXX+3)                                              
      F1X5=F1X5*KSC(IXX+4)                                              
      SS(1)=SS(1)+F1X1+F1X2+F1X3+F1X4+F1X5                              
      SS(2)=SS(2)+F2X1+F2X2+F2X3+F2X4+F2X5                              
      DO 1290 N=3,NMAX2                                                 
 1290 SS(N)=SS(N)+F11*ANN(IXX,N-2)+F12*ANN(IXX+1,N-2)+                  
     1      F13*ANN(IXX+2,N-2)+F14*ANN(IXX+3,N-2)+F15*ANN(IXX+4,N-2)    
 1295 CONST=8.D0*PI*PI*ETAM(IET)**3                                       
      SIG=SS(1)/CONST*1E+4                                              
      ER(1)=ABS(1.D0-SIGMA(IET)/SIG)*100.D0                                 
      IF(ERROR.LT.ER(1)) ERROR=ER(1)                                    
      SIGMA(IET)=SIG                                                    
      BET=SS(2)/CONST*1E+4                                              
      ER(2)=ABS(1.D0-BETA(IET)/BET)*100.D0                                  
      IF(ERROR.LT.ER(2)) ERROR=ER(2)                                    
      BETA(IET)=BET                                                     
      KAPPA(IET)=BET-SIG                                                
      DO 1300 N=3,NMAX2                                                 
      ANTOT=2.D0*SS(N)/SS(1)                                              
      ER(N)=ABS(ANTOT-ATOT(IET,N-2))                                    
      IF(ERRORA.LT.ER(N)) ERRORA=ER(N)                                  
 1300 ATOT(IET,N-2)=ANTOT                                               
C                                                                       
C SETTING UP A FINER GRID FOR REFINED INTEGRATION                       
C                                                                       
      IF(ERROR.LT.ERRP.AND.ERRORA.LT.ERRA) GOTO 1310
      IF(NX.LT.100) GOTO 1305                                           
      WRITE(LU,2150) ERROR,ER(1),ER(2),(N,ER(N+2),N=1,NMU)               
      GOTO 1310                                                         
C                                                                       
C PRINT OUT INTERMEDIATE RESULTS IF DESIRED
C                                                                       
 1305 IF(IPRNT.EQ.1) GOTO 1335
      IN=(NETA-1)/10+1                                                  
      WRITE(LU,2090) IXR,DX                                              
      DO 1325 II=1,IN                                                   
      I1=10*(II-1)+1                                                    
      I2=(II/IN)*NETA+(1-II/IN)*10*II                                   
      WRITE(LU,2100) (ETAM(I),I=I1,I2)                                   
      WRITE(LU,2110) (KAPPA(I),I=I1,I2)                                  
      WRITE(LU,2120) (SIGMA(I),I=I1,I2)                                  
      WRITE(LU,2130) (BETA(I),I=I1,I2)                                   
      WRITE(LU,2170)                                                     
      DO 1325 N=1,NMU                                                   
      IDEG=180.D0*(N-1.D0)/(NMU-1.D0)+1D-3                                    
 1325 WRITE(LU,2140) IDEG,(ATOT(I,N),I=I1,I2)                            
      WRITE(LU,2145)
 1335 DO 1315 N=1,NX                                                    
      N1=NX+2-N                                                         
      N2=2*(NX-N)+3                                                     
      XMIE(N2)=XMIE(N1)                                                 
      KSC(N2)=KSC(N1)                                                   
      KEX(N2)=KEX(N1)                                                   
      NM(N2)=NM(N1)                                                     
      DO 1315 NN=1,NMU                                                  
 1315 ANN(N2,NN)=ANN(N1,NN)                                             
      NX=2*NX                                                           
      GOTO 1215                                                         
C                                                                       
C PRINT OUT RESULTS                                                     
C                                                                       
 1310 IN=(NETA-1)/10+1                                                  
      DO 1330 II=1,IN                                                   
      I1=10*(II-1)+1                                                    
      I2=(II/IN)*NETA+(1-II/IN)*10*II                                   
      WRITE(LU,2100) (ETAM(I),I=I1,I2)                                   
      IF(IDSTF.EQ.1) WRITE(LU,2070)(XMIE(I),I=I1,I2)                     
      WRITE(LU,2110) (KAPPA(I),I=I1,I2)                                  
      WRITE(LU,2120) (SIGMA(I),I=I1,I2)                                  
      WRITE(LU,2130) (BETA(I),I=I1,I2)                                   
      WRITE(LU,2170)                                                     
      DO 1330 N=1,NMU                                                   
      IDEG=180.D0*(N-1.D0)/(NMU-1.D0)+1D-3                                    
 1330 WRITE(LU,2140) IDEG,(ATOT(I,N),I=I1,I2)                            
      STOP                                                              
C                                                                       
 1010 FORMAT(5X,40HNUMBER OF WAVENUMBERS MUST BE < OR = 10,,
     1          16H PROGRAM ABORTED)
 1900 FORMAT(5X,48HPARAMETERS FOR SINGLE PARTICLE/SINGLE WAVELENGTH 
     1      /5X,48H************************************************///) 
 2000 FORMAT(//5X,24HPARTICLE RADIUS        =,E10.3,7H MICROM/          
     1       5X,24HREFRACTIVE INDEX       =,F7.4,1H-,F6.4,1Hi/                  
     2       5X,24HPARTICLE DENSITY       =,E10.3,10H PER CM**3/        
     3       5X,24HX = 2*PI*R*ETA         =,F8.3/)                      
 2010 FORMAT(5X,50HPARAMETERS FOR SINGLE PARTICLE/WAVENUMBER SPECTRUM/
     1       5X,50H**************************************************///
     X       5X,24HPARTICLE RADIUS        =,E10.3,7H MICROM/            
     1       5X,24HREFRACTIVE INDEX       =,F7.4,1H-,F6.4,1Hi/                  
     2       5X,24HPARTICLE DENSITY       =,E10.3,10H PER CM**3/        
     4       5X,24HMINIMUM WAVENUMBER     =,E10.3,5H CM-1/              
     5       5X,24HMAXIMUM WAVENUMBER     =,E10.3,5H CM-1/              
     6       5X,24HNUMBER OF WAVENUMBERS  =,I3///)                      
 2020 FORMAT(5X,54HPARAMETERS FOR PARTICLE DISTRIBUTION/SINGLE WAVENUMBE
     2R/                                                            
     1       5X,54H*****************************************************
     3*//    5X,24HWAVENUMBER             =,E10.3,5H CM-1)              
 2030 FORMAT(5X,56HPARAMETERS FOR PARTICLE DISTRIBUTION/WAVENUMBER SPECT
     1RUM/                                                          
     2       5X,56H*****************************************************
     3***//                                                         
     4       5X,24HMINIMUM WAVENUMBER     =,E10.3,5H CM-1/              
     5       5X,24HMAXIMUM WAVENUMBER     =,E10.3,5H CM-1/              
     6       5X,24HNUMBER OF WAVENUMBERS  =,I3///)                      
 2040 FORMAT(5X,24HMINIMUM PARTICLE RADIUS=,E10.3,7H MICROM/            
     1       5X,24HMAXIMUM PARTICLE RADIUS=,E10.3,7H MICROM/            
     1       5X,24HREFRACTIVE INDEX       =,F7.4,1H-,F6.4,1Hi/                  
     2       5X,24HPARTICLE DENSITY       =,E10.3,10H PER CM**3/        
     3       5X,28HDISTRIBUTION FUNCTION: N(R)=,E11.5,4H*R**,F3.1,      
     1       6H*EXP(-,E11.5,4H*R**,F3.1,1H)///)                         
 2050 FORMAT(5X,33HMIE-PARAMETERS ARE CALCULATED FOR,F10.5,             
     1       7H  < X <,F10.5//)                                         
 2060 FORMAT(5X,44HCALCULATIONS FOR RMIN/RMAX DID NOT CONVERGE,,        
     1          16H PROGRAM ABORTED)                                    
 2090 FORMAT(5X,16HINTEGRATION WITH,I4,18H NODES, AND A DX =,F6.3/)     
 2100 FORMAT(///2X,10HETA (CM-1),5X,1P10E10.3/)                         
 2070 FORMAT(2X,12HX=2*PI*R*ETA,3X,1P10E10.3)                           
 2110 FORMAT(2X,12HKAPPA (CM-1),3X,1P10E10.3)                           
 2120 FORMAT(2X,12HSIGMA (CM-1),3X,1P10E10.3)                           
 2130 FORMAT(2X,12HBETA  (CM-1),3X,1P10E10.3/)                          
 2170 FORMAT(//2X,14HPHASE FUNCTION/2X,21HDEG.              PHI)                 
 2140 FORMAT(2X,I3,12X,1P10E10.3)                                          
 2145 FORMAT(///)
 2150 FORMAT(//5X,29HINTEGRATION DID NOT CONVERGE:,                     
     1            16H MAXIMUM ERROR =,F5.2,1H%///                       
     2       5X,17HERROR FOR SIGMA :,F5.2,19H%, ERROR FOR BETA :,       
     3       F5.2,1H%/5X,9HERROR FOR/(1X,6HPHASE(,I3,2H):,F8.5))        
 2160 FORMAT(2X,6HPHASE(,I3,6HDEG.) ,1P10E11.4)                         
      END                                                               
      SUBROUTINE FMIE(M,X,KSCA,KEXT,JMAX)                               
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 M,Y,DY(500),G(500),ZETA,A,B                               
      REAL*8 PSI(500),CHI(500),DX(500),X,KSCA,KEXT                        
      COMMON /BLK1/ AR(500),AI(500),BR(500),BI(500)                     
C                                                                       
      NMAX=1.5D0*X+7+5*DLOG(1+X*X/50.D0)                                    
      Y=M*X                                                             
      LLMAX=NMAX-1                                                      
      DX(NMAX)=(NMAX+1)/X                                               
      DY(NMAX)=(NMAX+1)/Y                                               
      DO 600 I=1,LLMAX                                                  
      N=NMAX-I                                                          
      DX(N)=(N+1.D0)/X-1.D0/(DX(N+1)+(N+1.D0)/X)                              
 600  DY(N)=(N+1.D0)/Y-1.D0/(DY(N+1)+(N+1.D0)/Y)                              
C                                                                       
      G(1)=CMPLX(0.D0,-1.D0)                                                
      G(1)=1.D0/(1.D0/X-G(1))-1.D0/X                                          
      DO 700 N=2,NMAX                                                   
 700  G(N)=1.D0/(N/X-G(N-1))-N/X                                          
C                                                                       
      LMAX=NMAX-2                                                       
      PSI(NMAX)=0.D0                                                      
      PSI(NMAX-1)=1.D0                                                    
      SUM=2.D0*NMAX-1.D0                                                    
      DO 200 I=1,LMAX                                                   
      N=LLMAX-I                                                         
      PSI(N)=(2.D0*N+3.D0)/X*PSI(N+1)-PSI(N+2)                              
 200  SUM=SUM+(2.D0*N+1.D0)*PSI(N)**2                                       
      PSI0=3.D0/X*PSI(1)-PSI(2)                                           
      SUM=SUM+PSI0**2                                                   
      SQ=DSQRT(SUM)                                                      
      DO 300 N=1,NMAX                                                   
 300  PSI(N)=PSI(N)*X/SQ                                                
C                                                                       
      CHI(1)=COS(X)/X+SIN(X)                                            
      CHI(2)=3.D0/X*CHI(1)-COS(X)                                         
      DO 400 N=3,NMAX                                                   
 400  CHI(N)=(2.D0*N-1.D0)/X*CHI(N-1)-CHI(N-2)                              
C                                                                       
C                                                                       
      KSCA=0.D0                                                           
      KEXT=0.D0                                                           
      DO 500 N=1,NMAX                                                   
      ZETA=CMPLX(PSI(N),CHI(N))                                         
      A=PSI(N)/ZETA*((DY(N)-M*DX(N))/(DY(N)-M*G(N)))                    
      B=PSI(N)/ZETA*((M*DY(N)-DX(N))/(M*DY(N)-G(N)))                    
      AR(N)=REAL(A)                                                     
      BR(N)=REAL(B)                                                     
      AI(N)=AIMAG(A)                                                    
      BI(N)=AIMAG(B)                                                    
      KSCA=KSCA+(2.D0*N+1.D0)*(AR(N)**2+AI(N)**2+BR(N)**2+BI(N)**2)         
      KEXT=KEXT+(2*N+1)*(AR(N)+BR(N))                                   
  500 CONTINUE                                                          
      KSCA=KSCA*2.D0/X**2                                                 
      KEXT=KEXT*2.D0/X**2                                                 
      ABSK=KEXT-KSCA                                                    
C                                                                       
C                                                                       
      JMAX=NMAX-2                                                       
      RETURN                                                            
      END                                                               
      SUBROUTINE PITAU(XMAX,NMAX)                                       
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON /BLK2/ PN(500,181),TN(500,181),NMU                         
      PI=DATAN(1.D0)*4.D0                                                   
      NMU=19                                                            
      IF(XMAX.GE.2.D0) NMU=37                                             
      IF(XMAX.GE.10.D0) NMU=91                                            
      IF(XMAX.GE.30.D0) NMU=181                                           
      NMU=181                                                            
      DO 1195 IMU=1,NMU                                                 
      AMU=COS((IMU-1.D0)/(NMU-1.D0)*PI)                                     
      PN(1,IMU)=1.D0                                                      
      PN(2,IMU)=3.D0*AMU                                                  
      TN(1,IMU)=AMU                                                     
      TN(2,IMU)=3.D0*(2.D0*AMU*AMU-1.D0)                                      
      DO 1195 N=3,NMAX                                                  
      PN(N,IMU)=((2.D0*N-1.D0)*AMU*PN(N-1,IMU)-N*PN(N-2,IMU))/(N-1.D0)        
 1195 TN(N,IMU)=AMU*(PN(N,IMU)-PN(N-2,IMU))+TN(N-2,IMU)                 
     *         -(2.D0*N-1.D0)*(1.D0-AMU*AMU)*PN(N-1,IMU)                      
      RETURN                                                            
      END                                                               
      SUBROUTINE PHASE(NMAX,AN)                                         
      IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION AN(500)                                                 
      COMMON /BLK1/ AR(500),AI(500),BR(500),BI(500)                     
      COMMON /BLK2/ PN(500,181),TN(500,181),NMU                         
      DO 1205 IMU=1,NMU                                                 
      A1R=0.D0                                                            
      A1I=0.D0                                                            
      A2R=0.D0                                                            
      A2I=0.D0                                                            
      DO 1200 N=1,NMAX                                                  
      FAC=(2.D0*N+1.D0)/N/(N+1.D0)                                            
      A1R=A1R+FAC*(AR(N)*PN(N,IMU)+BR(N)*TN(N,IMU))                     
      A1I=A1I+FAC*(AI(N)*PN(N,IMU)+BI(N)*TN(N,IMU))                     
      A2R=A2R+FAC*(AR(N)*TN(N,IMU)+BR(N)*PN(N,IMU))                     
 1200 A2I=A2I+FAC*(AI(N)*TN(N,IMU)+BI(N)*PN(N,IMU))                     
 1205 AN(IMU)=A1R*A1R+A1I*A1I+A2R*A2R+A2I*A2I                           
      RETURN                                                            
      END                                                               
