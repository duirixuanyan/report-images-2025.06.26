! CODE TO CALCULATE FSK DISTRIBUTION FOR THE FULL SPECTRUM [k(g) and a(T_i,g)]
! FOR MIXTURES OF CO2(ifg=1), H2O(ifg=2) AND CH4(ifg=3), WITH OR WITHOUT SOOT.
!
! Input parameters (set by changing values in front matter):
!   Tref:   reference temperature (K)
!   Tmin:   minimum temperature for a-function (K)
!   Tmax:   maximum temperature for a-function (K)
!   numT:   number of temperatures considered for a (equally spaced Tmin-->Tmax)
!   P:      total pressure of mixture (bar)
!   xmfr(ifg): mole fraction of component ifg
!   fvsoot: soot volume fraction (-)
!   nsoot,ksoot: soot complex index of refraction (assumed constant across spectrum)
!   wvnm_b: minimum wavenumber to be considered (cm-1)
!   wvnm_e: maximum wavenumber to be considered (cm-1)
!   wvnmst: wavenumber step, equally spaced (cm-1)
!   klmin:  minimum absorption coefficient evaluated for individual lines (because of
!           line overlap klmin should be 2-3 orders of magnitude lower than desired accuracy)
!   n_pwrk: number of k-boxes for k-distribution
!   pwr:    exponent for setting of k-box values; in equal steps of k^pwr
!   kdmin:  minimum k-value to be considered for k-distribution (values<1E-9 force kdmin=1E-9)
!   kdmax:  maximum k-value to be considered for k-distribution (kdmax<=0 sets kdmax=kmax,
!           ie, the maximum absorption coefficient found across the spectrum)
!     Warning: setting kdmin too low and/or kdmax too large will cause many empty k-boxes!
!   nq:     number of quadrature points for radiative calculations
! Switches:
!   iwr=0: single run for absco and k and a(g), no absco stored
!   iwr=1: calculate absco, then k and a(g), and absco stored
!   iwr=2: absco from file, calculate  k and a(g)
!   ipl=0: calculate linear absorption coefficient
!   ipl=1: calculate pressure-based absorption coefficient (only for single absorbing gas!)
!   ipr=1: single output file containing k,g(T,k),a(T,k) for all values of T and k
!   ipr=2: an additional data file containing wq,gq(Tref),kq(gq),aq(T,kq) for all values of T for the
!          nq quadrature points gq (and Gaussian weights wq)
! Notes:
!   If the absorption coefficient absco is calculated (iwr=0 or 1), usually the
!   LINEAR absorption coefficient is calculated (ipl=0); sometimes--FOR A PURE GAS ONLY--
!   the PRESSURE-BASED absorption coefficient is desired (ipl=1). If the pressure-based
!   absorption coefficient for a dilute gas is desired, set xmfr=1.d-3 (=0.1%)
!
! Files (names and paths may be changed):
!   xxx/co2.dat, xxx/h2o.dat, xxx/ch4.dat: HITRAN/HITEMP data files if required
!   absco.dat: output file for absorption coefficient absco if iwr=0 or iwr=1
!              input file for absorption coefficient absco if iwr=2
!   k+avsg.dat: output file (in Tecplot format), providing:
!               k, f(k), g0(k), numT*g(T,k), numT*a(T,g0)
  MODULE Key
   IMPLICIT NONE
!HITRAN/HITEMP DATABASE
   INTEGER  :: lu
   INTEGER,PARAMETER  :: rows=1400000
   DOUBLE PRECISION,PARAMETER :: wvnm_b=50.d0,wvnm_e=12000.d0,wvnmst=0.005d0, &
                                 kdmin=1.d-7,kdmax=-20.d0
   DOUBLE PRECISION   :: data(rows,6)
  END MODULE Key

   PROGRAM Main
   USE Key
! Input parameters
   INTEGER,PARAMETER :: numT=4,n_pwrk=5000,iwr=1,ipl=1,ipr=2,nq=12 ! J.Cai set nq=12 old nq=10
   DOUBLE PRECISION,PARAMETER :: P=1.d0,Tref=2000d0,Tmin=000d0,Tmax=1500d0
   DOUBLE PRECISION,PARAMETER :: xmfr(3)=(/0.0d0,1.0d-3,0.d0/)
   DOUBLE PRECISION,PARAMETER :: klmin=1.d-9,pwr=0.1d0
   DOUBLE PRECISION,PARAMETER :: fvsoot=0.d-6,nsoot=1.89d0,ksoot=0.92d0
!
   INTEGER,PARAMETER :: nabs=(wvnm_e-wvnm_b)/wvnmst+100,ncdim=100
   DOUBLE PRECISION,PARAMETER :: molemass(3)=(/44.d0,18.d0,16.d0/)
   DOUBLE PRECISION,PARAMETER :: hhh=6.626076d-34,ccc=2.997925d10
   DOUBLE PRECISION,PARAMETER :: kkk=1.380658d-23,nnn=6.022136d23
   DOUBLE PRECISION,PARAMETER   :: PI=3.1415926d0,T0=296.d0,P0=1.d0
   DOUBLE PRECISION,PARAMETER   :: c1=3.7419d-12,c2=1.4388d0,sigma=5.67d-12
   DOUBLE PRECISION  :: hck,hckt,hckt0,hcktt0,bk,ck,sootf,sootfc,patm,cnchk
   DOUBLE PRECISION  :: wvnm(nabs),absc(0:nabs),abscof,ri,mass,RR0,VV0
   DOUBLE PRECISION  :: kmin=1.d10,kmax=1.d-10,pwrk_min,pwrk_max,pwrk_step,temp
   INTEGER           :: i,it,icl,j,l,js,jj,lines,imax,ifg,im1,ip1,iq,ic(0:nq)
   INTEGER           :: number,iadd,iaddo=0,bin1st,binlst,numbins,number2
   DOUBLE PRECISION  :: k(0:n_pwrk),pwrk(0:n_pwrk),af(numT,n_pwrk),as(numT,n_pwrk)
   DOUBLE PRECISION  :: ki,kim1,kpwri,kpwrim1,dtot,dtoto,dlcl,T(0:numT)
   DOUBLE PRECISION  :: ff(0:numT,0:n_pwrk+1),gg(0:numT,0:n_pwrk+1)
   DOUBLE PRECISION  :: V,V0,deta,dk
   DOUBLE PRECISION  :: wvnm_b2,wvnm_e2,wvnmst2,kplancklbl,kplanckfsk,kplancksum,kperr
   DOUBLE PRECISION  :: intensity,line_width,klmax,TT0,cr,crcn,c1sigt4(0:numT),eb(0:numT),sum(0:numT)
   CHARACTER         :: dummy*25
! J.Cai added filenames start
   character(256),parameter :: kvsgFile='kvsgh2o-0p-2000K.dat' 
   character(256),parameter :: kvsgqFile='kvsgqh2o-0p-2000K.dat' 
   character(256),parameter :: abscFile='absch2o-0p-2000K.dat' 
   character(256),parameter :: CO2File='/opt/HITRAN2008/02_hit08.par' 
   character(256),parameter :: CH4File='/opt/HITRAN2008/06_hit08.par' 
   character(256),parameter :: H2OFile='/opt/HITRAN2008/01_hit08.par' 
   !character(256),parameter :: H2OFile='/opt/HITRAN/hitran96/by_molec/01_hit96.par' 
! J.Cai added filenames end
! J.Cai comment out starts
!! Selection of g-values for numerical quadrature, using a Numerical Recipes routine
!! If Numerical Recipes is not available, set nq=12, comment out the following 8 lines of code,
!! and uncomment the 5-line REAL declaration following it
!   REAL              :: gqs(nq),wqs(nq),kq(nq),aq(numt,nq),gq(nq),wq(nq),gaujac,alf=3.,bet=-.9,wsum
!! Get quadrature coefficients from Numerical recipies
!    wsum=0.
!    CALL GAUJAC(gqs,wqs,nq,alf,bet)
!          do iq=1,nq
!            gq(iq)=0.5*(1.-gqs(iq))
!            wq(iq)=wqs(iq)/(2.**(alf+bet+1)*gq(iq)**alf*(1.-gq(iq))**bet)
!            wsum=wsum+wq(iq)
!          enddo
!! Correction to make sum(wq)=1
!         wq=wq/wsum
!! End quadrature coefficients from Numerical recipies
! J.Cai comment out ends
! Selection of precalculated g-values for numerical quadrature, for nq=12,alf=3.,bet=0.
! J.Cai uncomment out starts
    REAL              :: kq(nq),aq(numt,nq), &
           gq(nq)=(/ 5.120075E-02,1.170678E-01,2.015873E-01,3.007074E-01,4.095012E-01,5.225285E-01,  &
                     6.341280E-01,7.387071E-01,8.310236E-01,9.064499E-01,9.612060E-01,9.925594E-01/),&
           wq(nq)=(/ 5.556622E-02,7.576839E-02,9.258290E-02,1.048306E-01,1.118451E-01,1.132605E-01,  &
                     1.090012E-01,9.927844E-02,8.457905E-02,6.563999E-02,4.341329E-02,1.904792E-02/)
! J.Cai uncomment out starts
! PRESSURE IN atm
   patm=P/1.01325
! IF P-BASED absc is requested make sure it is not a mixture
    IF(ipl==1) THEN
        cnchk=xmfr(1)*xmfr(2)+xmfr(1)*xmfr(3)+xmfr(3)*xmfr(2)
        IF(cnchk > 1.d-6) PAUSE 'ERROR: you cannot use pressure-based absorption coefficient for mixture!'
    ENDIF
! Open output files
! Output file for k,g(T,k),a(T,k) for all numT temperatures and all n_pwrk k-values
   OPEN(7,FILE=kvsgFile) ! J.Cai centralize filename
! Header formatted for TECPLOT, for a numT of 4
   write(7,6)
 6 format('VARIABLES = k,g0,g1,g2,g3,g4,a1,a2,a3,a4')
! Output file for wq,gq(Tref),kq(gq),aq(T,kq) for all numT temperatures and all nq g-values
   IF(ipr==2) THEN
       OPEN(8,FILE=kvsgqFile,STATUS='unknown') ! J.Cai centralize filename
! Header formatted for readability, for a numT of 4
        write(8,8)
   ENDIF
 8 format('    wq',9x,'gq',9x,'kq',8x,'aq1',8x,'aq2',8x,'aq3',8x,'aq4')
! File containing absorption coefficient
   !IF(iwr>0) OPEN(9,FILE='c:\absco\absch2o-0p-2000K.dat',STATUS='unknown')
   IF(iwr>0) OPEN(9,FILE=abscFile,STATUS='unknown') ! J.Cai centralize filename

   hck=hhh*ccc/kkk
   hckt0=hck/T0
   IF(iwr==2) THEN
! READ (GAS-ONLY) ABSORPTION COEFFICIENT FROM FILE
      read(9,97) dummy
      read(9,98) number
      read(9,92) dummy,wvnm_b2,wvnm_e2,wvnmst2
      number2=(wvnm_e2-wvnm_b2)/wvnmst2+1
      IF(number2 /= number) PAUSE 'bad data file'
      read(9,*) (absc(i),i=1,number)
      CLOSE(9)
      DO i=1,number
         wvnm(i)=wvnm_b2+(i-1)*wvnmst2
      ENDDO

   ELSE

! CALCULATE NECESSARY WAVENUMBERS AND ABSORPTION COEFFICIENTS
! WVNM(I): WAVENUMBER
! ABSC(I): ABSORPTION COEFFICIENT; INITIALIZE FOR SOOT
   number=(wvnm_e-wvnm_b)/wvnmst+1
   IF(number>nabs) PAUSE 'increase nabs'
   DO i=1,number
    wvnm(i)=wvnm_b+(i-1)*wvnmst
    absc(i)=0.d0
   ENDDO

  kplancksum=0.d0
! Scan over gases
  DO ifg=1,3
  IF(xmfr(ifg)<.9d-3) CYCLE
! Open HITEMP database
  IF(ifg==1) THEN
     lu=11
     write(*,*) 'Reading CO2 data'
     OPEN(lu,FILE=CO2File, action='READ')  ! J.Cai change path
  ELSEIF(ifg==2) THEN
     lu=12
     write(*,*) 'Reading H2O data'
     OPEN(lu,FILE=H2OFile, action='READ')  ! J.Cai change path
  ELSE
     lu=13
     write(*,*) 'Reading CH4 data'
     OPEN(lu,FILE=CH4File, action='READ') ! J.Cai change path
  ENDIF
! GET LINE INFORMATION FROM HITEMP (all lines wvnm_b.le.lmbda.le.wvnm_e)
   CALL Getdata(lines)
   CLOSE(lu)
   write(*,*) 'Gas ',ifg,',  lines read: ', lines
   mass=1.d3*molemass(ifg)/nnn
   hckt=hck/Tref
   hcktt0=hckt0-hckt
! MULTIPLIER FOR PRESSURE-BASED ABSORPTION COEFFICIENT
   cr=nnn/8.314d1/Tref
! MULTIPLIER FOR LINEAR ABSORPTION COEFFICIENT
   IF(ipl==0) cr=cr*xmfr(ifg)*P
   IF(ifg==1) THEN
    write(*,*) 'start of absc loop for co2'
! VIBRATIONAL PARTITION FUNCTION FOR CO2
    V0=(1d0-DEXP(-666d0*hckt0))**2*(1d0-DEXP(-2396d0*hckt0))*   &
            (1d0-DEXP(-1351d0*hckt0))
    V=(1d0-DEXP(-666d0*hckt))**2*(1d0-DEXP(-2396d0*hckt))*   &
            (1d0-DEXP(-1351d0*hckt))
    VV0=V/V0
! ROTATIONAL PARTITION FUNCTION
    TT0=T0/Tref
    RR0=TT0
  ELSEIF(ifg==2) THEN
   write(*,*) 'start of absc loop for h2o'
! VIBRATIONAL PARTITION FUNCTION FOR H2O
    V0=(1d0-DEXP(-3652d0*hckt0))*(1d0-DEXP(-1595d0*hckt0))*   &
            (1d0-DEXP(-3756d0*hckt0))
    V=(1d0-DEXP(-3652d0*hckt))*(1d0-DEXP(-1595d0*hckt))*   &
            (1d0-DEXP(-3756d0*hckt))
    VV0=V/V0
! ROTATIONAL PARTITION FUNCTION
    TT0=T0/Tref
    RR0=TT0**1.5
  ELSE
   write(*,*) 'start of absc loop for ch4'
! VIBRATIONAL PARTITION FUNCTION FOR CH4
    V0=(1d0-DEXP(-1306d0*hckt0))**3*(1d0-DEXP(-1526d0*hckt0))**2*   &
            (1d0-DEXP(-2914d0*hckt0))*(1d0-DEXP(-3020d0*hckt0))**3
    V=(1d0-DEXP(-1306d0*hckt))**3*(1d0-DEXP(-1526d0*hckt))**2*   &
            (1d0-DEXP(-2914d0*hckt))*(1d0-DEXP(-3020d0*hckt))**3
    VV0=V/V0
! ROTATIONAL PARTITION FUNCTION
    TT0=T0/Tref
    RR0=TT0**1.5
  ENDIF
   VR0=VV0*RR0

! Scan over lines
    c1sigt4(0)=c1/(sigma*Tref**4)
    DO l=1,lines
! print out every 10000 lines so that user sees machine is working
    IF(l-(l/10000)*10000 == 0) write(*,*) 'reading line #',l
      line_width=(Data(l,4)*xmfr(ifg)+Data(l,3)*(1.d0-xmfr(ifg)))*patm*TT0**Data(l,6)
! molecule-based intensity
      intensity=Data(l,2)*VR0*DEXP(hcktt0*Data(l,5))
! pressure-based or linear intensity
      intensity=intensity*cr*(1d0-DEXP(-data(l,1)*hckt))/(1d0-DEXP(-data(l,1)*hckt0))
! calculate Planck-mean absorption coefficient to ensure adequacy of spectral resolution
      kplancksum=kplancksum+intensity*c1sigt4(0)*data(l,1)**3/(EXP(hck/Tref*data(l,1))-1.d0)
! absorption coefficient at line center
      klmax=intensity/(PI*line_width)
      IF(klmax<klmin) CYCLE
! Find wavenumber (subscript) closest to line center
      icl=(data(l,1)-wvnm_b)/wvnmst+1
! Scan over adjacent wavenumbers to see whether line makes contribution to absco
        DO i=icl,number
          deta=(data(l,1)-wvnm(i))/line_width
          dk=klmax/(1.d0+deta*deta)
          absc(i)=absc(i)+dk
          IF(dk<klmin) EXIT
        ENDDO
        DO i=icl-1,1,-1
          deta=(data(l,1)-wvnm(i))/line_width
          dk=klmax/(1.d0+deta*deta)
          absc(i)=absc(i)+dk
          IF(dk<klmin) EXIT
        ENDDO
    ENDDO ! l
  ENDDO ! ifg
   write(*,*) 'end of absc loop'

! WRITE ABSC TO DATA FILE IF DESIRED
  IF(iwr==1) THEN
      write(9,96)
      write(9,98) number
      write(9,95) wvnm_b,wvnm_e,wvnmst
      write(9,99) (absc(i),i=1,number)
      CLOSE(9)
      ENDIF
92 FORMAT(a1,3f12.5)
95 FORMAT('#',3f12.5)
96 FORMAT('variables = "absco"')
97 FORMAT(a25)
98 FORMAT('zone i=',i8)
99 FORMAT(e14.5)
   ENDIF ! iwr

! ADD SOOT CONTRIBUTION TO ABSCO (AFTER STORING/RETRIEVING GAS-ONLY VALUES)
  sootfc=sootf(fvsoot,nsoot,ksoot)
  DO i=1,number
    absc(i)=absc(i)+sootfc*wvnm(i)
  ENDDO

! CALCULATE K-DISTRIBUTION
! pwrK_MAX AND pwrK_MIN DEFINES THE MAXIMUM AND MINIMUM pwr(K) VALUES.
! pwrK_STEP IS THE pwr(K) INTERVAL WE USE TO SCAN THE SPECTRUM.
! pwrK(I): pwr(K) VALUES
! FF(I): F*DELTAK
! GG(I): G FUNCTION (CUMULATIVE K-DISTRIBUTION FUNCTION)
! Find maximum kappa value
    DO i=1,number
      IF(absc(i)>kmax) then
        kmax=absc(i)
        imax=i
      endif
    ENDDO
    IF(ipl==0) THEN
        write(*,93) kmax,wvnm(imax)
    ELSE
        write(*,94) kmax,wvnm(imax)
    ENDIF
93 FORMAT(' kmax =',f12.5,'cm-1 at ',f10.4,'cm-1')
94 FORMAT(' kmax =',f12.5,'bar-1cm-1 at ',f10.4,'cm-1')
   IF(kmax>kdmax .and. kdmax>0.d0) &
        write(*,*) 'WARNING!!! kdmax is less than maximum absorption coefficient!!'
    kmin=max(1.d-9,kdmin)
    kmax=max(kdmax,kmax)
    pwrk_min=kmin**pwr
    pwrk_max=kmax**pwr
    pwrk_step=(pwrk_max-pwrk_min)/REAL(n_pwrk-1)

!*****************************************************************************
! K-DISTRIBUTION
   write(*,*) 'start of k-dist loop'

   DO i=0,n_pwrk
    pwrk(i)=REAL(i-1)*pwrk_step+pwrk_min
    k(i)=pwrk(i)**(1./pwr)
   ENDDO

   c1sigt4(0)=c1/(sigma*Tref**4)*wvnmst
   T(0)=Tref
   DO it=1,numT
    T(it)=max(300d0,Tmin+(Tmax-Tmin)*(it-1.)/(numT-1.))
    c1sigt4(it)=c1/(sigma*T(it)**4)*wvnmst
   ENDDO
    absc(0)=2.*absc(1)-absc(2)
    kpwri=absc(0)**pwr
    ki=absc(0)
    iaddo=max(1,Int((kpwri-pwrk_min)/pwrk_step+1))
    absc(number+1)=2.*absc(number)-absc(number-1)

   ff=0.d0
! SCAN OVER SPECTRUM
    sum=0.
   DO i=1,number
     DO it=0,numT
       eb(it)=c1sigt4(it)*wvnm(i)**3/(EXP(hck/T(it)*wvnm(i))-1.d0)
     ENDDO
     sum=sum+eb
       kpwrim1=kpwri
       kim1=ki
       kpwri=absc(i)**pwr
       ki=absc(i)
       iadd=max(1,Int((kpwri-pwrk_min)/pwrk_step+1))
       dtoto=0.d0
       dk=ki-kim1
! New k-cell iadd > iaddo: calculate local detas for each k-cell
     IF(iadd>iaddo) THEN
        DO j=iaddo,iadd-1
           dtot=(k(j+1)-kim1)/dk
           dlcl=dtot-dtoto
           dtoto=dtot
           DO it=0,numT
              ff(it,j)=ff(it,j)+eb(it)*dlcl
           ENDDO
        ENDDO
        DO it=0,numT
           ff(it,iadd)=ff(it,iadd)+eb(it)*(1.d0-dtot)
        ENDDO
! New k-cell iadd < iaddo: calculate local detas for each k-cell
     ELSEIF(iadd<iaddo) THEN
        DO j=iaddo,iadd+1,-1
           dtot=(k(j)-kim1)/dk
           dlcl=dtot-dtoto
           dtoto=dtot
           DO it=0,numT
              ff(it,j)=ff(it,j)+eb(it)*dlcl
           ENDDO
        ENDDO
        DO it=0,numT
           ff(it,iadd)=ff(it,iadd)+eb(it)*(1.d0-dtot)
        ENDDO
! New k-cell iadd = iaddo: entire deta remains in cell
     ELSE
     DO it=0,numT
        ff(it,iadd)=ff(it,iadd)+eb(it)
     ENDDO
     ENDIF
     iaddo=iadd
   ENDDO ! number
! FLAG EMPTY k-BINS
    DO i=1,n_pwrk
      bin1st=i
      IF(ff(0,i)>0.d0) EXIT
    ENDDO
    DO i=n_pwrk,1,-1
      binlst=i
      IF(ff(0,i)>0.d0) EXIT
    ENDDO

! CORRECT K-VALUES BY HALF A BIN UPWARDS
   DO i=1,n_pwrk-1
    k(i)=.5D0*(k(i)+k(i+1))
   ENDDO

! CALCULATE G FUNCTIONS
    DO it=0,numT
      gg(it,binlst)=1.d0
      DO i=binlst,bin1st,-1
        gg(it,i-1)=gg(it,i)-ff(it,i)
! CONVERT FROM F*DELTAK TO F IF DESIRED (comment out if not)
!       ff(it,i)=ff(it,i)/(k(i)-k(i-1))
      ENDDO
! EXTRAPOLATE TO binlst+1 TO ALLOW AF-CALCULATION AT binlst
    ff(it,binlst+1)=ff(it,binlst-1)-2*ff(it,binlst)
      gg(it,binlst+1)=2.d0-gg(it,binlst-1)
! IF (ALMOST) ENTIRE SPECTRUM IS CONSIDERED, SUM(eb)>1 DUE TO QUADRATURE ERROR --> g NEED ADJUSTMENT
      IF(gg(it,bin1st-1)<0.d0) THEN
        DO i=binlst,bin1st-1,-1
          gg(it,i)=(gg(it,i)-gg(it,bin1st-1))/(1.d0-gg(it,bin1st-1))
        ENDDO
      ENDIF
! SET GG(i<bin1st-1)=0 TO ACCOUNT FOR NEGLECTED PARTS OF SPECTRUM
      DO i=0,bin1st-1
        gg(it,i)=0.d0
      ENDDO
! SET GG(i>binlst)=1 FOR COMPATIBILIITTYY
      DO i=binlst+1,n_pwrk
        gg(it,i)=1.0000000000001d0
      ENDDO
!-- set first bin always to zero !! J.Cai
	  gg(it,0) = 0.d0  !! J.Cai
    ENDDO ! it

! CALCULATE A-FUNCTIONS
    numbins=binlst-bin1st+1
    DO it=1,numT
      DO i=bin1st,binlst
        af(it,i)=(ff(it,i+1)+4*ff(it,i)+ff(it,i-1))/(ff(0,i+1)+4*ff(0,i)+ff(0,i-1))
      ENDDO
      DO i=1,bin1st
        af(it,i)=af(it,bin1st)
      ENDDO
      DO i=binlst+1,n_pwrk
        af(it,i)=af(it,binlst)
      ENDDO
    ENDDO   ! it
! do a little smoothing on raw af
      as=af
      DO j=1,25
        DO it=1,numT
          DO i=bin1st,binlst
            im1=i-1+1/i
            ip1=i+1-i/n_pwrk
            as(it,i)=(af(it,ip1)+4*af(it,i)+af(it,im1))/6.d0
          ENDDO
        ENDDO
        af=as
      ENDDO
   write(*,*) 'end of k-dist loop'

! OUTPUT
   DO i=1,n_pwrk
    WRITE(7,50) k(i),(gg(it,i),it=0,numT),(af(it,i),it=1,numT)
   ENDDO
50 FORMAT(1p10d16.8)
   CLOSE(7)

! Find k- and a-values for selected quadrature point g-values gq
    IF(ipr == 2) THEN
! k values for g(Tref)
      it=0
        i=bin1st-1
        ic(0)=bin1st
        DO iq=1,nq
 11       IF(gg(it,i+1)>gq(iq)) THEN
            kq(iq)=k(i)+(k(i+1)-k(i))*(gq(iq)-gg(it,i))/(gg(it,i+1)-gg(it,i))
            ic(iq)=max(i,bin1st) !! J.Cai
          ELSE
            i=i+1
            GOTO 11
          ENDIF
        ENDDO ! iq
        DO iq=1,nq-1
          ic(iq)=(ic(iq)+ic(iq+1))/2
        ENDDO
        ic(nq)=binlst
! Find smoothened a for quadrature points
      DO it=1,numT
        DO iq=1,nq
		  IF (ic(iq).NE.ic(iq-1)) THEN !! J.Cai, DO loop later assumes this condition
            aq(it,iq)=0.d0
            DO i=ic(iq-1),ic(iq)-1
              aq(it,iq)=aq(it,iq)+.5d0*(af(it,i)+af(it,i+1))*(gg(it,i+1)-gg(it,i))
            ENDDO
            aq(it,iq)=aq(it,iq)/(gg(it,ic(iq))-gg(it,ic(iq-1)))
		  ELSE  !! J.Cai
		    aq(it,iq) = 1.d0  !! J.Cai
		  ENDIF !! J.Cai
        ENDDO
      ENDDO   ! it
      DO i=1,nq
         WRITE(8,60) wq(i),gq(i),kq(i),(aq(it,i),it=1,numT)
      ENDDO
      CLOSE(8)
 60   FORMAT(1p10e11.4)
    ENDIF

!
! CALCULATE KPLANCK BY LBL AND FSK TO ASCERTAIN QUALITY OF K-DISTRIBUTION
! LBL
    kplancklbl=0.d0
    DO i=1,number
      kplancklbl=kplancklbl+absc(i)*c1sigt4(0)*wvnm(i)**3/(EXP(hck/T(0)*wvnm(i))-1.d0)
    ENDDO
! FSK
    kplanckfsk=0.d0
    DO i=bin1st,n_pwrk
      kplanckfsk=kplanckfsk+0.5d0*(k(i)+k(i-1))*(gg(0,i)-gg(0,i-1))
    ENDDO
    IF(iwr<2) THEN
        kperr=1d2*(1.d0-kplancklbl/kplancksum)
        write(*,70) kplancksum,kplancklbl,kperr
70      FORMAT(' k_Pl-sum =',e12.4,',  k_Pl-lbl =',e12.4,'; error =',f7.2,'%')
        IF(kperr > .5d0) write(*,*) 'spectral resolution questionable: decrease wvnst!'
    ENDIF
    kperr=1d2*(1.d0-kplanckfsk/kplancklbl)
    write(*,80) kplancklbl,kplanckfsk,kperr
80  FORMAT(' k_Pl-lbl =',e12.4,',  k_Pl-fsk =',e12.4,'; error =',f7.2,'%')
    IF(kperr > .5d0) write(*,*) 'k-distribution questionable: increase n_pwrk or change pwr!'

   END PROGRAM Main

!************************************************************************
   SUBROUTINE Getdata(i)
   USE Key
   IMPLICIT NONE
   INTEGER   :: i,isotp
   INTEGER   :: dummy1
   CHARACTER :: dummy2*10
! data(i,1) = wavenumber
! data(i,2) = intensity
! data(i,3) = b_air
! data(i,4) = b_self
! data(i,5) = E''
! data(i,6) = exponent for b

   i=1
   DO
   READ(lu,FMT=150,END=4) dummy1,isotp,data(i,1),data(i,2),dummy2,data(i,3),    &
    data(i,4),data(i,5),data(i,6)
   If(data(i,1)<wvnm_b) CYCLE
   If(data(i,1)>wvnm_e) GOTO 4
! Ignore if not the most abundent isotope
   If(isotp/=1) CYCLE
   If(data(i,5)<0.d0) THEN
    data(i,5)=0.d0
    write(*,*) 'E"<0 at ', data(i,1)
    Endif
   If(data(i,4)<1.e-5) data(i,4)=5.d0*data(i,3)
   i=i+1
   ENDDO
150 FORMAT(i2,i1,f12.6,es10.3,a10,f5.4,f5.3,f10.4,f4.2)
! The above format specification is for HITRAN 2008
! For HITRAN 96 use the following
!150 FORMAT(i3,f12.6,e10.3,a10,f5.4,f5.4,f10.4,f4.2)
  4 i=i-1
  5 RETURN
   END SUBROUTINE Getdata
!************************************************************************
    FUNCTION sootf(fv,n,k)
    DOUBLE PRECISION    :: fv,n,k,sootf,pi36=1.130973355d2,nsq,ksq
    nsq=n*n
    ksq=k*k
    sootf=pi36*n*k*fv/((nsq-ksq+2.d0)**2+4.d0*nsq*ksq)
    RETURN
    END
!************************************************************************
