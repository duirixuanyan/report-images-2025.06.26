!!**********************************************************************
!!
!!	CALCULATION OF RADIATIVE INTENSITY AND TRANSMISSIVITY OF
!!       A NONISOTHERMAL AND NONHOMOGENEOUS MIXTURE COLUMN OF H2O-CO2-CO-CH4
!!	TRANSPARENT GAS-PARTICLES DISCRETIZED INTO N HOMOGENEOUS AND 
!!       ISOTHERMAL ELEMENTS -- New SNB parameters
!!
!!	WITH THE MALKMUS STATISTICAL NARROW-BAND MODEL AND 
!!	THE CURTIS-GODSON APPROXIMATION AND A 25 cm-1 SPECTRAL RESOLUTION
!!
!!	THE INPUTS (FILE 'SNBINPUT') :
!!	*****************************
!!
!!	- N : TOTAL NUMBER OF ELEMENTS
!!	- FOR I VARYING FROM 1 TO N :
!!	 LENGTH(CM),TEMPERATURE(K),PRESSURE(ATM),XH2O,XCO2,XCO,XCH4,XSOOT
!!	 (XSPEC = MOLAR FRACTION OF SPECIES SPEC=H2O,CO2,CO or CH4)
!!	 (XSOOT = VOLUME FRACTION OF PARTICLES IN THE MIXTURE)
!!        (EACH LINE CORRESPONDS TO ONE ELEMENT I)
!!	 (THE DIRECTION OF PROPAGATION IS FROM N TO 1)
!!
!!	THE OUTPUTS ARE :
!!	*****************
!!
!!	FILE 'SNBINTENS' :
!!	------------
!!
!!	- WAVE NUMBER (CM-1), SPECTRAL RADIATIVE INTENSITY AT 
!!	  THE EXIT OF THE COLUMN  (IN W.M-2.STR-1.(CM-1)-1)
!!	- TOTAL RADIATIVE INTENSITY (IN W.M-2.STR-1)
!!
!!	FILE 'SNBTRANS' :
!!	-------------
!!
!!	- WAVE NUMBER (CM-1), TRANSMISSIVITY
!!
!!	THE OTHER FILES REQUIRED FOR THIS PROGRAM ARE :
!!	***********************************************
!!
!!	- SNBWN : CONTAINS THE WAVE NUMBERS FOR WHICH CALCULATIONS ARE
!!	  CARRIED OUT AND SPECTRAL WIDTHS BOTH IN cm-1
!!         THE PROGRAM IS STOPPED WHEN A NEGATIVE WAVE NUMBER IS 
!!         ENCOUNTERED
!!         THE WAVE NUMBERS MUST BE GREATER THAN 25 cm-1 (LOWER NARROW-BAND CENTRE for CH4)
!!         IN THE RANGE 25-9300cm-1, BAND WIDTHS MUST BE CONSISTENT WITH GAS SNB PARAMETERS.
!!         ABOVE 9300 cm-1, BAND WITHS MAY BE GREATER SINCE ONLY SOOT PARTICULE CONTRIBUTE.
!!         THE TOTAL NARROW-BAND NUMBER MUST NOT EXCEED THE PARAMETER NWVMAX
!!         
!!         THE WAVE NUMBERS MUST BE WITHIN THE RANGE 25-11250 cm-1
!!
!!	- SNBH2O : H2O SNB PARAMETERS
!!	- SNBCO2 : CO2 SNB PARAMETERS
!!	- SNBCO  : CO  SNB PARAMETERS
!!	- SNBCH4  : CH4  SNB PARAMETERS
!!**********************************************************************
program snb
implicit none
integer(4),parameter:: NWVMAX=500
real(8),parameter::PI=ACOS(-1._8)
logical(2):: LICO,LICO2,LIH2O,LICH4
real(8):: DWVNB,WVNB,WV55,C1,C2
real(8),allocatable::XD(:),T(:),P(:),XH2O(:),XCO2(:),XCO(:),XSUT(:),XCH4(:),TAUIN(:),XLUM(:)
integer(4)::N,ICO,ICO2,IH2O,ICH4
!!!!!!
real(8):: DCO(48,194),DC(48,323),DH(48,449),KCO(48,194),KC(48,323),KH(48,449),kch4(18,248),dch4(18,248)
real(8):: XL(NWVMAX),XLS(NWVMAX),WV(NWVMAX)
!!!!!!
integer(4)::I,J,IWVNB,NWV
real(8)::TT,XLT
!!
!!     READING THE COLUMN DATA FILE
!!
open(UNIT=10,FILE='SNBINTENS')
open(UNIT=11,FILE='SNBTRANS')
open(UNIT=8,FILE='SNBINPUT')
read(8,*) N
allocate(XD(N),T(N),P(N),XH2O(N),XCO2(N),XCO(N),XSUT(N),XCH4(N),TAUIN(N+1),XLUM(N))
do  I=1,N
      READ(8,*) XD(I),T(I),P(I),XH2O(I),XCO2(I),XCO(I),XCH4(I),XSUT(I)
enddo
!!
!!     READING THE MODEL PARAMETERS
!!
call PARAM
!!MF=1
!!NF=1
!!
!!     WAVE NUMBER LOOP
!!
IWVNB=0
open(UNIT=9,FILE='SNBWN')
do 
  IWVNB=IWVNB+1
  READ(9,*) WVNB,DWVNB
  IF(WVNB.LT.0.) exit
  WV55=WVNB*5.5
  WV(IWVNB)=WVNB
!!
!!     CALCULATION OF THE SPECTRAL INDEX FOR EACH SPECIES
!!
      call FINDI
!!
!!     CALCULATION OF BLACKBODY INTENSITIES
!!
  do  I=1,N
     TT=T(I)
     XLUM(I)=XLU(TT)
  enddo
!!
!!     CALCULTATION OF TRANSMISSIVITIES
!!
  CALL TRSMI
!!
!!     CALCULATION OF RADIATIVE INTENSITIES
!!
  XL(IWVNB)=0._8
  do I=1,N
      XL(IWVNB)=XL(IWVNB)+XLUM(I)*(TAUIN(I)-TAUIN(I+1))
  enddo
  XLS(IWVNB)=XL(IWVNB)/DWVNB
  WRITE(11,*) WVNB, TAUIN(N+1)
  WRITE(10,*) WVNB,XLS(IWVNB)
enddo
NWV=IWVNB-1
XLT=0._8
do J=1,NWV
    XLT=XLT+XL(J)
enddo
WRITE(10,*) XLT
CLOSE(UNIT=9)
CLOSE(UNIT=10)
CLOSE(UNIT=11)
CLOSE(UNIT=8)
!!**************************************************************
contains
!!
!!**************************************************************
!!                                                             *
!!     BLACKBODY INTENSITY (PLANCK FORMULA)                    *
!!                                                             *
!!**************************************************************
!!
function XLU(T)
implicit none
real(8)::XLU,T,C2T
 C2T=C2/T
 C2T=EXP(C2T)-1._8
 XLU=C1/C2T
end function XLU
!!
!!
!!*****************************************************************
!!                                                                *
!!   THIS SUBROUTINE READS THE MODEL PARAMETERS                   *
!!                                                                *
!!*****************************************************************
!!
subroutine PARAM
implicit none
Real(8):: xxnu
OPEN(UNIT=45,FILE='SNBCO')
OPEN(UNIT=46,FILE='SNBCO2')
OPEN(UNIT=47,FILE='SNBH2O')
OPEN(UNIT=48,FILE='SNBCH4')
!!
!!   READING THE PARAMETERS
!!
do I=1,194
   READ(45,*) xxnu,(KCO(J,I),J=1,48)
enddo
do I=1,194
   READ(45,*) xxnu,(DCO(J,I),J=1,48)
enddo
close(45)
do I=1,323
   READ(46,*) xxnu,(KC(J,I),J=1,48)
enddo
do I=1,323
   READ(46,*) xxnu,(DC(J,I),J=1,48)
enddo
close(46)
do I=1,449
   READ(47,*) xxnu,(KH(J,I),J=1,48)
enddo
do I=1,449
   READ(47,*) xxnu,(DH(J,I),J=1,48)
enddo
close(47)
do I=1,248
     READ(48,*) xxnu,(kch4(J,I),J=1,18)
enddo
do I=1,248
     READ(48,*) xxnu,(dch4(J,I),J=1,18)
enddo
close(48)
end subroutine PARAM
!!
!!
!!***********************************************************************
!!                                                                      *
!!     THIS SUBROUTINE CALCULATES THE INTERPOLATION COEFFICIENTS        *
!!                                                                      *
!!***********************************************************************
!!
subroutine TMNO(TM,RT,IT)
implicit none
integer(4)::IT
real(8):: TM,RT
IF(TM.GT.300._8) THEN
     IF(TM.LT.5000._8) THEN
         RT=(TM-300._8)/100._8
         IT=INT(RT+1.0E-6_8)
         RT=RT-IT
         IT=IT+1
     ELSE
         RT=1._8
         IT=47
     ENDIF
ELSE
     RT=0._8
     IT=1
ENDIF
end subroutine TMNO
!!
subroutine interpolch4(TM,RT,IT)
implicit none
integer(4)::IT
real(8):: TM,RT
IF(TM.GT.300._8) THEN
     IF(TM.lt.2000._8) THEN
         RT=(TM-300._8)/100._8
         IT=INT(RT+1.0E-6_8)
         RT=RT-IT
         IT=IT+1
     ELSE
         RT=1._8
         IT=17
     ENDIF
ELSE
     RT=0._8
     IT=1
ENDIF
end subroutine interpolch4
!!*******************************************************************
!!                                                                  *
!!     THIS SUBROUTINE SEARCHS THE PARAMETER INDEXES                *
!!     CORRESPONDING THE WAVE NUMBER 'WVNB'                         *
!!                                                                  *
!!*******************************************************************
!!
subroutine FINDI
implicit none
!!
!!   CALCULATION OF PLANCK LAW PARAMETERS
!!
C1=(0.11909E-7)*WVNB**3*DWVNB
C2=1.4388*WVNB
!!
!!   LOOKING FOR THE INDEXES
!!
if(wvnb>=250._8.and.wvnb<=8300._8)then
    ICO2=INT((WVNB-250.)/25.)+1
else
    ICO2=-9
endif
if(WVNB.GE.50._8.AND.WVNB.LE.11250._8) then
    IH2O=INT((WVNB-50.)/25.)+1
else
    IH2O=-9
endif
if(WVNB>=1600._8.and.WVNB<=6425._8)then
    ICO=INT((WVNB-1600.)/25.)+1
else
    ICO=-9
endif
if(WVNB>=25._8.and.WVNB<=6200._8)then
     ICH4=INT((WVNB-25.)/25.)+1
else
     ICH4=-9
endif
LICO=ICO.GT.0
LICO2=ICO2.GT.0
LIH2O=IH2O.GT.0
LICH4=ICH4.GT.0
end subroutine FINDI
!!
!!
!!***********************************************************
!!                                                          *
!!     CALCULATION OF THE TRANSMISSIVITY OF A INHOMOGENEOUS *
!!     COLUMN WITH CURTIS-GODSON APPROXIMATION              *
!!     TRANSMISSIVITIES ARE CALCULATED BETWEEN THE FIRST    *
!!     POINT AND A CURRENT POINT OF THE COLUMN              *
!!                                                          *
!!***********************************************************
!!
!!
subroutine TRSMI
implicit none
real(8):: XKCO(N),XDCO(N),XBCO(N)
real(8):: XKCO2(N),XDCO2(N),XBCO2(N)
real(8):: XKH2O(N),XDH2O(N),XBH2O(N)
real(8):: XKCH4(N),XDCH4(N),XBCH4(N)
real(8):: XH(N)
integer(4)::NCOL,J,IT
real(8)::RT,T296,T273,T900,XN2,GAM,HSUIE,XMCO,XMCO2,XMH2O,XMCH4!!,HT
real(8):: SC,SK,SB,YC,YK,YB,ZK,ZB,RATT,XK,ZC
NCOL=N+1
do J=1,NCOL-1
   XH(J)=XD(J)
   CALL TMNO(T(J),RT,IT)
   T296=296._8/T(J)
   XN2=1._8-XCO2(J)-XH2O(J)
   IF(LICO) THEN
        GAM=0.075_8*XCO2(J)*T296**0.6_8+0.06_8*XN2*T296**0.7_8
		GAM=GAM+0.12_8*XH2O(J)*T296**0.82
        GAM=P(J)*GAM
        XKCO(J)=KCO(IT,ICO)+RT*(KCO(IT+1,ICO)-KCO(IT,ICO))
        XDCO(J)=DCO(IT,ICO)+RT*(DCO(IT+1,ICO)-DCO(IT,ICO))
        XBCO(J)=2._8*GAM*XDCO(J)
    ENDIF
    IF(LICO2) THEN
        GAM=0.07_8*XCO2(J)+0.058_8*XN2+0.10_8*XH2O(J)
		GAM=P(J)*GAM*(T296)**0.7_8
        XKCO2(J)=KC(IT,ICO2)+RT*(KC(IT+1,ICO2)-KC(IT,ICO2))
        XDCO2(J)=DC(IT,ICO2)+RT*(DC(IT+1,ICO2)-DC(IT,ICO2))
        XBCO2(J)=2._8*GAM*XDCO2(J)
      ENDIF
    IF(LIH2O) THEN
        RATT=SQRT(T296)
        GAM=0.066_8*(7._8*RATT*XH2O(J)+1.2_8*(XH2O(J)+XN2)+1.6_8*XCO2(J))*RATT
        GAM=P(J)*GAM
        XKH2O(J)=KH(IT,IH2O)+RT*(KH(IT+1,IH2O)-KH(IT,IH2O))
        XDH2O(J)=DH(IT,IH2O)+RT*(DH(IT+1,IH2O)-DH(IT,IH2O))
        XBH2O(J)=2._8*GAM*XDH2O(J)
     ENDIF
     if(LICH4)then
        call interpolch4(T(J),rt,it)
        GAM= 0.051_8*T296**0.75_8  
        GAM=P(J)*GAM
        XKCH4(J)=kch4(IT,ICH4)+RT*(kch4(IT+1,ICH4)-kch4(IT,ICH4))
        XDCH4(J)=dch4(IT,ICH4)+RT*(dch4(IT+1,ICH4)-dch4(IT,ICH4))
        XBCH4(J)=2._8*GAM*XDCH4(J)
     endif
enddo
!!
!!     THE TRANSMISSIVITIES ARE INITIALIZED WITH THE TRANSMISSIVITY
!!     OF THE PARTICLES.
!!
TAUIN(1)=1._8
do  I=1,NCOL-1
  HSUIE=0._8
  do  J=2,NCOL
      HSUIE=HSUIE-XH(J-1)*WV55*XSUT(J-1)
      TAUIN(J)=DEXP(HSUIE)
   enddo
enddo
XMCO=0._8
XMCO2=0._8
XMH2O=0._8
XMCH4=0._8
do I=1,NCOL-1
!!    HT=HT+XH(I)
    XMCO=XMCO+XCO(I)
    XMCO2=XMCO2+XCO2(I)
    XMH2O=XMH2O+XH2O(I)
    XMCH4=XMCH4+XCH4(I)
enddo
!!
!!     CALCULATION OF CO TRANSMISSIVITY
!!
if(LICO.AND.XMCO.GT.1.0E-6_8) then
   SC=0._8
   SK=0._8
   SB=0._8
   do J=2,NCOL
      YC=XCO(J-1)*P(J-1)*XH(J-1)
      YK=YC*XKCO(J-1)
      YB=YK*XBCO(J-1)
      SC=SC+YC
      IF(SC.GT.1.e-12_8) THEN
        SK=SK+YK
        SB=SB+YB
        ZC=SC
        ZK=SK/ZC
        ZB=SB/SK
        XK=1._8+2._8*ZK*ZC/ZB
        TAUIN(J)=TAUIN(J)*EXP(-ZB*(SQRT(XK)-1._8))
      ENDIF
    enddo
endif
!!
!!     CALCULATION OF CO2 TRANSMISSIVITY
!!
if(LICO2.AND.XMCO2.GT.1.0E-6_8) then
   SC=0._8
   SK=0._8
   SB=0._8
   do J=2,NCOL
      YC=XCO2(J-1)*P(J-1)*XH(J-1)
      YK=YC*XKCO2(J-1)
      YB=YK*XBCO2(J-1)
      SC=SC+YC
      IF(SC.GT.1.e-12_8) THEN
        SK=SK+YK
        SB=SB+YB
        ZC=SC
        ZK=SK/ZC
        ZB=SB/SK
        XK=1._8+2._8*ZK*ZC/ZB
        TAUIN(J)=TAUIN(J)*EXP(-ZB*(SQRT(XK)-1._8))
      ENDIF
   enddo
endif
!!
!!     CALCULATION OF H2O TRANSMISSIVITY
!!
if(LIH2O.AND.XMH2O.GT.1.0E-6_8) then
   SC=0._8
   SK=0._8
   SB=0._8
   do  J=2,NCOL
      YC=XH2O(J-1)*P(J-1)*XH(J-1)
      YK=YC*XKH2O(J-1)
      YB=YK*XBH2O(J-1)
      SC=SC+YC
      IF(SC.GT.1.e-12_8) THEN
        SK=SK+YK
        SB=SB+YB
        ZC=SC
        ZK=SK/ZC
        ZB=SB/SK
        XK=1._8+2._8*ZK*ZC/ZB
        TAUIN(J)=TAUIN(J)*EXP(-ZB*(SQRT(XK)-1._8))
      ENDIF
    enddo
endif

!!
!!     CALCULATION OF CH4 TRANSMISSIVITY
!!
if(LICH4.AND.XMCH4.GT.1.0E-6_8) then
   SC=0._8
   SK=0._8
   SB=0._8
   do  J=2,NCOL
      YC=XCH4(J-1)*P(J-1)*XH(J-1)
      YK=YC*XKCH4(J-1)
      YB=YK*XBCH4(J-1)
      SC=SC+YC
      IF(SC.GT.1.e-12_8) THEN
        SK=SK+YK
        SB=SB+YB
        ZC=SC
        ZK=SK/ZC
        ZB=SB/SK
        XK=1._8+2._8*ZK*ZC/ZB
        TAUIN(J)=TAUIN(J)*EXP(-ZB*(SQRT(XK)-1._8))
      ENDIF
    enddo
endif
end subroutine TRSMI
end program snb
