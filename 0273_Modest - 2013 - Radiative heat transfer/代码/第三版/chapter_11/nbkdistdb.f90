! CODE TO CALCULATE NBK DISTRIBUTIONS FOR A PART SPECTRUM [k(T,g) FOR A NUMBER
! OF Ti AND A NUMBER OF DELTA-ETA],
! FOR MIXTURES OF CO2(ifg=1), H2O(ifg=2) AND CH4(ifg=3), WITH OR WITHOUT SOOT.
!
! Input parameters (set by changing values in front matter):
!   Tmin:   minimum temperature (K)
!   Tmax:   maximum temperature (K)
!   numT:   number of temperatures considered (equally spaced Tmin-->Tmax)
!   P:      total pressure of mixture (bar)
!   xmfr(ifg): mole fraction of component ifg
!   fvsoot: soot volume fraction (-)
!   nsoot,ksoot: soot complex index of refraction (assumed constant across spectrum)
!   wvnm_b: minimum wavenumber to be considered (cm-1)
!   wvnm_e: maximum wavenumber to be considered (cm-1)
!   wvnmbuf: wavenumber range to left and right for lines to be considered in absco calculation (cm-1)
!   wvnmst: wavenumber step for absorption coefficient, equally spaced (cm-1)
!   kdrnge: wavenumber range for each k-distribution
!   klmin:  minimum absorption coefficient evaluated for individual lines (because of
!           line overlap klmin should be 2-3 orders of magnitude lower than desired accuracy)
!   n_pwrk: number of k-boxes for k-distribution
!   pwr:    exponent for setting of k-box values; in equal steps of k^pwr
!   nq:     number of quadrature points for each k-distribution
! Switches:
!   iwr=0: single run for absco and k, no absco stored
!   iwr=1: calculate absco, then k, and absco stored
!   iwr=2: absco from file, calculate  k
!   ipl=0: calculate linear absorption coefficient
!   ipl=1: calculate pressure-based absorption coefficient (only for single absorbing gas!)
!   ipr=0: print k vs. g only for Gaussian quadrature points
!   ipr=1: print k vs. g for Gaussian quadrature points as well as k vs. f and g for all k-bins
!   ipr=2: print k vs. f and g only for all k-bins
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
!   nbkvsg.dat: output file (in Tecplot format), providing:
!               [eta-range
!                g, numT*k(Ti,g)] repeated numkd times
  MODULE Key
   IMPLICIT NONE
!HITRAN/HITEMP DATABASE
   INTEGER  :: lu
   INTEGER,PARAMETER  :: rows=1400000
   DOUBLE PRECISION,PARAMETER   :: wvnm_b=2320.d0,wvnm_e=2380.d0,wvnmbuf=5.d0,wvnmst=0.001d0
   DOUBLE PRECISION   :: data(rows,6),wvnm_l=wvnm_b-wvnmbuf,wvnm_r=wvnm_e+wvnmbuf
  END MODULE Key

   PROGRAM Main
   USE Key
! Input parameters
   INTEGER,PARAMETER :: numT=4,n_pwrk=500,nq=10,iwr=2,ipl=0,ipr=1
   DOUBLE PRECISION,PARAMETER :: P=1.d0,Tmin=300d0,Tmax=1200d0,kdrnge=10.
   DOUBLE PRECISION,PARAMETER :: xmfr(3)=(/0.10d0,0.00d0,0.d0/),pwr=0.1d0,klmin=1.d-9
   DOUBLE PRECISION,PARAMETER :: fvsoot=0.d-6,nsoot=1.89d0,ksoot=0.92d0
!
   INTEGER,PARAMETER :: nabs=140000
   DOUBLE PRECISION,PARAMETER :: molemass(3)=(/44.d0,18.d0,16.d0/)
! All length units in constants are in cm
   DOUBLE PRECISION,PARAMETER :: hhh=6.626076d-34,ccc=2.997925d10
   DOUBLE PRECISION,PARAMETER :: kkk=1.380658d-23,nnn=6.022136d23
   DOUBLE PRECISION,PARAMETER   :: PI=3.1415926d0,T0=296.d0,P0=1.d0
   DOUBLE PRECISION,PARAMETER   :: c1=3.7419d-12,c2=1.4388d0,sigma=5.67d-12
   DOUBLE PRECISION  :: hck,hckt,hckt0,hcktt0,bk,ck,sootf,sootfc,Patm,cnchk
   DOUBLE PRECISION  :: wvnm(nabs),absc(numT,0:nabs),abscof,ri,mass,RR0,VV0
   DOUBLE PRECISION  :: kmin,kmax,pwrk_min,pwrk_max,pwrk_step
   INTEGER           :: i,if,it,icl,j,l,js,jj,lines,imax,ifg,ik
   INTEGER           :: number,iadd,iaddo=0,ng,numkd,numrng
   DOUBLE PRECISION  :: k(0:n_pwrk),pwrk(n_pwrk)
   DOUBLE PRECISION  :: kpwri,kpwrim1,ki,kim1,dtot,dtoto,dlcl,fmult,T(numT)
   DOUBLE PRECISION  :: ff(0:n_pwrk),gg(0:n_pwrk)
   DOUBLE PRECISION  :: V,V0,deta,dk,kbarlbl,kbarfsk,kperr
   DOUBLE PRECISION  :: intensity,line_width,klmax,TT0,cr,crx
   CHARACTER         :: dummy*25,Ta*4,vars(numT)*12
   EXTERNAL sootf
! Selection of g-values for numerical quadrature, using a Numerical Recipes routine
! If Numerical Recipes is not available, set nq=12, comment out the following 8 lines of code,
! and uncomment the 5-line REAL declaration following it
   REAL              :: gqs(nq),wqs(nq),kq(numt,nq),gq(nq),wq(nq),gaujac,alf=3.,bet=-.6,sum
! Get quadrature coefficients from Numerical recipies
    sum=0.
    CALL GAUJAC(gqs,wqs,nq,alf,bet)
          do iq=1,nq
            gq(iq)=0.5*(1.-gqs(iq))
            wq(iq)=wqs(iq)/(2.**(alf+bet+1)*gq(iq)**alf*(1.-gq(iq))**bet)
            sum=sum+wq(iq)
          enddo
! Correction to make sum(wq)=1
          wq=wq/sum
! End quadrature coefficients from Numerical recipies
! Selection of precalculated g-values for numerical quadrature, for nq=12,alf=3.,bet=0.
!   REAL              :: kq(numt,nq), &
!          gq(nq)=(/ 5.120075E-02,1.170678E-01,2.015873E-01,3.007074E-01,4.095012E-01,5.225285E-01,  &
!                    6.341280E-01,7.387071E-01,8.310236E-01,9.064499E-01,9.612060E-01,9.925594E-01/),&
!          wq(nq)=(/ 5.556622E-02,7.576839E-02,9.258290E-02,1.048306E-01,1.118451E-01,1.132605E-01,  &
!                    1.090012E-01,9.927844E-02,8.457905E-02,6.563999E-02,4.341329E-02,1.904792E-02/)

! PRESSURE IN atm
   Patm=P/1.01325
! IF P-BASED absc is requested make sure it is not a mixture
    IF(ipl==1) THEN
        cnchk=xmfr(1)*xmfr(2)+xmfr(1)*xmfr(3)+xmfr(3)*xmfr(2)
        IF(cnchk > 1.d-6) PAUSE 'ERROR: you cannot use pressure-based absorption coefficient for mixture!'
    ENDIF
! Open output files
   IF(ipr<2) OPEN(7,FILE='nbkvsgqco2.dat',STATUS='unknown')
   IF(ipr>0) OPEN(8,FILE='nbkvsgco2.dat',STATUS='unknown')
   IF(iwr>0) OPEN(9,FILE='C:\absco\absctmp.dat',STATUS='unknown')

   hck=hhh*ccc/kkk
   hckt0=hck/T0
   T(1)=Tmin
   DO it=2,numT
    T(it)=Tmin+(Tmax-Tmin)*(it-1.)/(numT-1.)
   ENDDO
   IF(iwr==2) THEN
! READ (GAS-ONLY) ABSORPTION COEFFICIENT FROM FILE
      read(9,97) dummy
      read(9,98) number
      DO i=1,number
      read(9,99) wvnm(i),(absc(it,i),it=1,numT)
      ENDDO
      CLOSE(9)

   ELSE

! CALCULATE NECESSARY WAVENUMBERS AND ABSORPTION COEFFICIENTS
! WVNM(I): WAVENUMBER
! ABSC(I): ABSORPTION COEFFICIENT; INITIALIZE FOR SOOT
   absc=0.d0
   number=(wvnm_e-wvnm_b)/wvnmst+1
   IF(number>nabs) PAUSE 'increase nabs'
   DO i=1,number
    wvnm(i)=wvnm_b+(i-1)*wvnmst
   ENDDO
! Scan over gases
  DO ifg=1,3
  IF(xmfr(ifg)<1.d-3) CYCLE
! Open HITEMP database
  IF(ifg==1) THEN
     lu=11
     write(*,*) 'Reading CO2 data'
     OPEN(lu,FILE='C:\hitemp\co2.dat')
  ELSEIF(ifg==2) THEN
     lu=12
     write(*,*) 'Reading H2O data'
     OPEN(lu,FILE='C:\hitemp\h2o.dat')
  ELSE
     lu=13
     write(*,*) 'Reading CH4 data'
     OPEN(lu,FILE='C:\hitran96\ch4.dat')
  ENDIF
! GET LINE INFORMATION FROM HITEMP (all lines wvnm_l.le.lmbda.le.wvnm_r)
   CALL Getdata(lines)
   CLOSE(lu)
   write(*,*) 'Gas ',ifg,',  lines read: ', lines
   ri=1.d5*molemass(ifg)/8.314d3
   mass=1.d3*molemass(ifg)/nnn
! LOOP OVER TEMPERATURE
   DO it=1,numT
    hckt=hck/T(it)
    hcktt0=hckt0-hckt
! MULTIPLIER FOR PRESSURE-BASED ABSORPTION COEFFICIENT
   cr=nnn/8.314d1/T(it)
! MULTIPLIER FOR LINEAR ABSORPTION COEFFICIENT
   IF(ipl==0) cr=cr*xmfr(ifg)*P
    IF(ifg==1) THEN
     write(*,*) 'start of absc loop for co2 for T =', T(it)
! VIBRATIONAL PARTITION FUNCTION FOR CO2
     V0=(1d0-DEXP(-666d0*hckt0))**2*(1d0-DEXP(-2396d0*hckt0))*   &
            (1d0-DEXP(-1351d0*hckt0))
     V=(1d0-DEXP(-666d0*hckt))**2*(1d0-DEXP(-2396d0*hckt))*   &
            (1d0-DEXP(-1351d0*hckt))
     VV0=V/V0
! ROTATIONAL PARTITION FUNCTION
     TT0=T0/T(it)
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
     TT0=T0/T(it)
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
     TT0=T0/T(it)
     RR0=TT0**1.5
    ENDIF
    VR0=VV0*RR0

!
! Scan over lines
    DO l=1,lines
! print out every 10000 lines so that user sees machine is working
    IF(l-(l/10000)*10000 == 0) write(*,*) 'reading line #',l
      line_width=(Data(l,4)*xmfr(ifg)+Data(l,3)*(1.d0-xmfr(ifg)))*Patm*TT0**Data(l,6)
! molecule-based intensity
      intensity=Data(l,2)*VR0*DEXP(hcktt0*Data(l,5))
! pressure-based or linear intensity
      intensity=intensity*cr*(1d0-DEXP(-data(l,1)*hckt))/(1d0-DEXP(-data(l,1)*hckt0))
! absorption coefficient at line center
      klmax=intensity/(PI*line_width)
      IF(klmax<klmin) CYCLE
! Find wavenumber (subscript) closest to line center
      icl=(data(l,1)-wvnm_b)/wvnmst+1
      icl=min(number,max(1,icl))        ! limit for icl for lines in buffers
! Scan over adjacent wavenumbers to see whether line makes contribution to absco
        DO i=icl,number
          deta=(data(l,1)-wvnm(i))/line_width
          dk=klmax/(1.d0+deta*deta)
          absc(it,i)=absc(it,i)+dk
          IF(dk<klmin) EXIT
        ENDDO
        DO i=icl-1,1,-1
          deta=(data(l,1)-wvnm(i))/line_width
          dk=klmax/(1.d0+deta*deta)
          absc(it,i)=absc(it,i)+dk
          IF(dk<klmin) EXIT
        ENDDO
    ENDDO ! l
   ENDDO ! it
  ENDDO ! ifg
   write(*,*) 'end of absc loop'

! WRITE ABSC TO DATA FILE IF DESIRED
  IF(iwr==1) THEN
      DO it=1,numT
         write(vars(it),95) int(T(it))
      ENDDO
      write(9,96) vars
      write(9,98) number
      DO i=1,number
      write(9,99) wvnm(i),(absc(it,i),it=1,numT)
      ENDDO
      CLOSE(9)
      ENDIF
95 FORMAT(' "absc',i4.4,'K"')
96 FORMAT('variables = "wvn"',20(a12))
97 FORMAT(a25)
98 FORMAT('zone i=',i8)
99 FORMAT(f12.5,20(e14.5))
   ENDIF ! iwr

! ADD SOOT CONTRIBUTION TO ABSCO (AFTER STORING/RETRIEVING GAS-ONLY VALUES)
  sootfc=sootf(fvsoot,nsoot,ksoot)
  IF(sootfc>1.d2*klmin*wvnm_b) THEN
    DO it=1,numT
     DO i=1,number
        absc(it,i)=absc(it,i)+sootfc*wvnm(i)
     ENDDO
    ENDDO
   ENDIF

! CALCULATE K-DISTRIBUTION
! pwrK_MAX AND pwrK_MIN DEFINES THE MAXIMUM AND MINIMUM pwr(K) VALUES.
! pwrK_STEP IS THE pwr(K) INTERVAL WE USE TO SCAN THE SPECTRUM.
! pwrK(I): pwr(K) VALUES
! FF(I): F*DELTAK
! GG(I): G FUNCTION (CUMULATIVE K-DISTRIBUTION FUNCTION)
  gg(0)=0.d0
! Loop over wavenumber ranges
! numkd = number of ranges, numrng = number of wavenumbers in range
  numkd=(wvnm_e-wvnm_b)/kdrnge+1.d-6
  numrng=kdrnge/wvnmst
  DO ik=1,numkd
! Loop over temperatures
  WRITE(7,47) wvnm((ik-1)*numrng+1),wvnm(ik*numrng+1)
  WRITE(*,48) wvnm((ik-1)*numrng+1),wvnm(ik*numrng+1)
  DO it=1,numT
    kmin=1.d10
    kmax=1.d-10
! Find minimum and maximum kappa values
    imax=0
    DO i=(ik-1)*numrng+1,ik*numrng+1
      IF(absc(it,i)>kmax) then
        kmax=absc(it,i)
        imax=i
      endif
      IF(absc(it,i)<kmin) kmin=absc(it,i)
    ENDDO
    write(*,37) T(it)
    IF(imax==0) THEN
        write(*,38) kmax
    ELSE
        write(*,39) kmax,wvnm(imax)
    ENDIF
 37 FORMAT('For T =',F6.0,'K:')
 38 FORMAT('   kmax < ', F10.4,'cm-1')
 39 FORMAT('   kmax = ', F10.4,'cm-1 at ',F10.4,'cm-1')
!*****************************************************************************
! K-DISTRIBUTION

! artificial k-dist linear in g from kmin to kmax for kmax<1e-6
    IF(kmax<1.d-6) THEN
      DO i=1,n_pwrk
        gg(i)=(i-1.)/(n_pwrk-1.)
        k(i)=kmin+(kmax-kmin)*gq(i)
      ENDDO
      IF(ipr<2) THEN
        DO iq=1,nq
          kq(it,iq)=kmin+(kmax-kmin)*gq(iq)
        ENDDO
      ENDIF
      CYCLE
    ENDIF
    IF(kmin<1.d-6) kmin=1.d-6

    pwrk_min=kmin**pwr
    pwrk_max=kmax**pwr
    pwrk_step=(pwrk_max-pwrk_min)/REAL(n_pwrk-1)

   DO i=1,n_pwrk
    pwrk(i)=REAL(i-1)*pwrk_step+pwrk_min
    k(i)=pwrk(i)**(1./pwr)
   ENDDO
   k(0)=.9d0*k(1)

    kpwri=absc(it,(ik-1)*numrng+1)**pwr
    ki=absc(it,(ik-1)*numrng+1)
    iaddo=max(0,Int((kpwri-pwrk_min)/pwrk_step+1))

   ff=0.d0
! SCAN OVER SPECTRUM
    DO i=(ik-1)*numrng+2,ik*numrng+1
     kpwrim1=kpwri
     kim1=ki
     kpwri=absc(it,i)**pwr
     ki=absc(it,i)
     iadd=max(0,Int((kpwri-pwrk_min)/pwrk_step+1))
     dtoto=0.d0
     dk=ki-kim1
! New k-cell iadd > iaddo: calculate local detas for each k-cell
     IF(iadd>iaddo) THEN
        DO j=iaddo,iadd-1
           dtot=(k(j+1)-kim1)/dk
           dlcl=dtot-dtoto
           dtoto=dtot
           ff(j)=ff(j)+dlcl/(numrng+1)
        ENDDO
        ff(iadd)=ff(iadd)+(1.d0-dtot)/(numrng+1)
! New k-cell iadd < iaddo: calculate local detas for each k-cell
     ELSEIF(iadd<iaddo) THEN
        DO j=iaddo,iadd+1,-1
           dtot=(k(j)-kim1)/dk
           dlcl=dtot-dtoto
           dtoto=dtot
           ff(j)=ff(j)+dlcl/(numrng+1)
        ENDDO
        ff(iadd)=ff(iadd)+(1.d0-dtot)/(numrng+1)
! New k-cell iadd = iaddo: entire deta remains in cell
     ELSE
     ff(iadd)=ff(iadd)+1./(numrng+1)
     ENDIF
     iaddo=iadd
   ENDDO ! i
! LAST BIN IS EMPTY
   ng=n_pwrk-1
! CORRECT K-VALUES BY HALF A BIN UPWARDS
   DO i=1,n_pwrk-1
    k(i)=.5D0*(k(i)+k(i+1))
   ENDDO

! CALCULATE RAW G FUNCTIONS
      gg(ng)=1.d0
      DO i=ng,1,-1
        gg(i-1)=gg(i)-ff(i)
! CONVERT FROM F*DELTAK TO F IF DESIRED
!       ff(i)=ff(i)/(k(i)-k(i-1))
      ENDDO
! OUTPUT of k vs g for all k-bins if desired
   IF(ipr>0) THEN
     WRITE(8,49) T(it),wvnm((ik-1)*numrng+1),wvnm(ik*numrng+1)
     DO i=1,ng
        WRITE(8,50) k(i),ff(i),gg(i)
     ENDDO
   ENDIF

      IF(ipr<2) THEN
! Find k-values for selected g-values gqs
        i=0
        DO iq=1,nq
 12       IF(gg(i+1)>gq(iq)) THEN
            kq(it,iq)=k(i)+(k(i+1)-k(i))*(gq(iq)-gg(i))/(gg(i+1)-gg(i))
          ELSE
            i=i+1
            GOTO 12
          ENDIF
        ENDDO
      ENDIF

!
! CALCULATE KAPPABAR BY LBL AND FSK TO ASCERTAIN QUALITY OF K-DISTRIBUTION
! LBL
    kbarlbl=0.d0
    DO i=(ik-1)*numrng+2,ik*numrng+1
      kbarlbl=kbarlbl+absc(it,i)/numrng
    ENDDO
! FSK
    kbarfsk=0.d0
    DO i=1,ng
      kbarfsk=kbarfsk+0.5d0*(k(i)+k(i-1))*(gg(i)-gg(i-1))
    ENDDO
    kperr=1d2*(1.d0-kbarfsk/kbarlbl)
    write(*,80) kbarlbl,kbarfsk,kperr
80  FORMAT('   k_bar-lbl =',e12.4,',  k_bar-fsk =',e12.4,'; error =',f7.2,'%')
    IF(kperr > .5d0) write(*,*) '   k-distribution questionable: increase n_pwrk or change pwr!'

    ENDDO ! it

   write(*,*) 'end of k-dist loop'

! OUTPUT of k vs g for Gaussian quadrature points if desired
   IF(ipr<2) THEN
     DO iq=1,nq
      WRITE(7,50) gq(iq),wq(iq),(kq(it,iq),it=1,numT)
     ENDDO
   ENDIF
47 FORMAT(/'wvnm_lft=',f12.6,'cm-1, wvnm_rgt=',f12.6,'cm-1'/ &
           '      gq             wq           kq(T1)        kq(T2)   ...')
48 FORMAT(/'wvnm_lft=',f12.6,'cm-1, wvnm_rgt=',f12.6,'cm-1')
49 FORMAT(/'T=',f5.0,'K, wvnm_lft=',f12.6,'cm-1, wvnm_rgt=',f12.6,'cm-1'/  &
           '      k              f              g')
50 FORMAT(20d14.6)

   ENDDO ! ik wavenumber range
   IF(ipr<2) CLOSE(7)
   IF(ipr>0) CLOSE(8)

   END PROGRAM Main

!************************************************************************
   SUBROUTINE Getdata(i)
   USE Key
   IMPLICIT NONE
   INTEGER   :: i
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
   READ(lu,FMT=150,END=4) dummy1,data(i,1),data(i,2),dummy2,data(i,3),    &
    data(i,4),data(i,5),data(i,6)
   If(data(i,1)<wvnm_l) CYCLE
   If(data(i,1)>wvnm_r) GOTO 4
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
!150 FORMAT(i2,i1,f12.6,e10.3,a10,f5.4,f5.4,f10.4,f4.2)
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
