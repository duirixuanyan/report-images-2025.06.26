    Program Elsasserkdist
          IMPLICIT NONE

          INTEGER, PARAMETER :: MM=5000
          INTEGER :: i,N1,N2,j
          REAL :: twopi,L,Sod1,b1,d1,bt1,C1,a1,g1,T1,Sod2,b2,d2,bt2,C2,a2,g2,T2,Tc,eta
          REAL :: pi,kmin,kmax,km(MM),gm(MM),gs,dk,k1,kmin2,kmax2,gc,arg
          INTEGER           :: n_pwrk=2000,nq=12,ipr=1
          DOUBLE PRECISION  :: pwr=0.1d0,wvnm(0:MM),absc(0:MM)

          pi=4.*atan(1.)
		  twopi=2*pi
          L=0.5
          N1=40
          SoD1=1.
          b1=0.0025
          d1=1./N1
          bt1=twopi*b1/d1
          C1=SoD1*sinh(bt1)
          a1=cosh(bt1)
          g1=bt1/b1
          N2=70
          SoD2=2.
          b2=0.0005
          d2=1./N2
          bt2=twopi*b2/d2
          C2=SoD2*sinh(bt2)
          a2=cosh(bt2)
          g2=bt2/b2

! Calculate absorption coefficient
           DO i = 0,MM
            wvnm(i)=i/float(MM)
!            absc(i)=C1/(a1-cos(g1*(wvnm(i)-d1*d1)))
!            absc(i)=C2/(a2-cos(g2*(wvnm(i)-d2*d2)))
            absc(i)=C1/(a1-cos(g1*(wvnm(i)-d1*d1)))+C2/(a2-cos(g2*(wvnm(i)-d2*d2)))
          ENDDO
   OPEN(9,FILE='absco.dat',STATUS='unknown')

! READ ABSORPTION COEFFICIENT FROM FILE
      write(9,98) MM+1
      write(9,99) (wvnm(i),absc(i),i=0,MM)
      CLOSE(9)
 98   FORMAT (I5)
 99   FORMAT((2e12.4))

! generate k-distribution
      CALL nbkdistsg(MM+1,n_pwrk,pwr,nq,ipr)
      STOP
      END




! SUBROUTINE TO CALCULATE NBK DISTRIBUTION FOR A GIVEN ARRAY OF ABSORPTION COEFFICIENTS [kap(ETA)]
! FOR A GIVEN DELTA-ETA,
!
! Input parameters:
!   Deta:   wavenumber range for k-distribution
!   numk:   number of absorption coefficient datapoints
!   n_pwrk: number of k-boxes for k-distribution
!   pwr:    exponent for setting of k-box values; in equal steps of k^pwr
!   nq:     number of quadrature points for each k-distribution
! Switches:
!   ipr=0: print k vs. g only for Gaussian quadrature points
!   ipr=1: print k vs. g for Gaussian quadrature points as well as k vs. f and g for all k-bins
!   ipr=2: print k vs. f and g only for all k-bins
! Files (names and paths may be changed):
!   absco.dat: input file for absorption coefficient absco
!               1st line: numk, Deta (in I5,F7.4 format)
!               2nd-(numk+1)th line: wvnm,absco (in e12.4 format)
!   nbkvsg.dat: output file in Tecplot format (if ipr=1 or 2), providing:
!               [eta-range, k, f, g, for n_pwrk k-values]
!   nbkvsgq.dat:output file in Tecplot format (if ipr=0 or 1), providing:
!               [eta-range, k(g), w(g), g, for nq Gaussian quadrature points]
!				w(g) are the Gaussian quadrature weights

   SUBROUTINE nbkdistsg(nabs,n_pwrk,pwr,nq,ipr)
   DOUBLE PRECISION  :: pwr
!
! All length units in constants are in cm
   DOUBLE PRECISION,PARAMETER   :: PI=3.1415926d0
   INTEGER ,PARAMETER           :: nqr=12
   DOUBLE PRECISION  :: wvnm(nabs),absc(0:nabs)
   DOUBLE PRECISION  :: kmin,kmax,pwrk_min,pwrk_max,pwrk_step
   INTEGER           :: n_pwrk,nq,ipr
   INTEGER           :: i,if,icl,j,l,js,jj,lines,imax,ifg,ik
   INTEGER           :: number,iadd,iaddo=0,ng,numrng
   DOUBLE PRECISION  :: k(0:n_pwrk),pwrk(n_pwrk)
   DOUBLE PRECISION  :: kpwri,kpwrim1,ki,kim1,dtot,dtoto,dlcl
   DOUBLE PRECISION  :: ff(0:n_pwrk),gg(0:n_pwrk)
   DOUBLE PRECISION  :: Deta,dk,kbarlbl,kbarfsk,kperr

! Selection of g-values for numerical quadrature, using a Numerical Recipes routine
! If Numerical Recipes is not available, set nq=12, comment out the following 8 lines of code,
! and uncomment the 5-line REAL declaration following it
!   REAL              :: gqs(nq),wqs(nq),kq(nq),gq(nq),wq(nq),gaujac,alf=3.,bet=-.6,sum
! Get quadrature coefficients from Numerical recipies
!    sum=0.
!    CALL GAUJAC(gqs,wqs,nq,alf,bet)
!          do iq=1,nq
!            gq(iq)=0.5*(1.-gqs(iq))
!            wq(iq)=wqs(iq)/(2.**(alf+bet+1)*gq(iq)**alf*(1.-gq(iq))**bet)
!            sum=sum+wq(iq)
!          enddo
! Correction to make sum(wq)=1
!          wq=wq/sum
! End quadrature coefficients from Numerical recipies
! Selection of precalculated g-values for numerical quadrature, for nq=12,alf=3.,bet=0.
   REAL              :: kq(nqr), &
          gq(nqr)=(/ 5.120075E-02,1.170678E-01,2.015873E-01,3.007074E-01,4.095012E-01,5.225285E-01,  &
                     6.341280E-01,7.387071E-01,8.310236E-01,9.064499E-01,9.612060E-01,9.925594E-01/),&
          wq(nqr)=(/ 5.556622E-02,7.576839E-02,9.258290E-02,1.048306E-01,1.118451E-01,1.132605E-01,  &
                     1.090012E-01,9.927844E-02,8.457905E-02,6.563999E-02,4.341329E-02,1.904792E-02/)

! Open output files
   IF(ipr<2) OPEN(7,FILE='nbkvsgq.dat',STATUS='unknown')
   IF(ipr>0) OPEN(8,FILE='nbkvsg.dat',STATUS='unknown')
   OPEN(9,FILE='absco.dat',STATUS='unknown')

! READ ABSORPTION COEFFICIENT FROM FILE
      read(9,98) number
      read(9,99) (wvnm(i),absc(i),i=1,number)
      CLOSE(9)
 98   FORMAT (I5)
 99   FORMAT((2e12.4))

! CALCULATE K-DISTRIBUTION
! pwrK_MAX AND pwrK_MIN DEFINES THE MAXIMUM AND MINIMUM pwr(K) VALUES.
! pwrK_STEP IS THE pwr(K) INTERVAL WE USE TO SCAN THE SPECTRUM.
! pwrK(I): pwr(K) VALUES
! FF(I): F*DELTAK
! GG(I): G FUNCTION (CUMULATIVE K-DISTRIBUTION FUNCTION)
  gg(0)=0.d0
    kmin=1.d10
    kmax=1.d-10
! Find minimum and maximum kappa values
    imax=0
    DO i=1,number
      IF(absc(i)>kmax) then
        kmax=absc(i)
        imax=i
      endif
      IF(absc(i)<kmin) kmin=absc(i)
    ENDDO
    IF(imax==0) THEN
        write(*,38) kmax
    ELSE
        write(*,39) kmax,wvnm(imax)
    ENDIF
 38 FORMAT('   kmax < ', F10.4,'cm-1')
 39 FORMAT('   kmax = ', F10.4,'cm-1 at ',F10.4,'cm-1')
!*****************************************************************************
! K-DISTRIBUTION

    IF(kmin<1.d-6) kmin=1.d-6

    pwrk_min=kmin**pwr
    pwrk_max=kmax**pwr
    pwrk_step=(pwrk_max-pwrk_min)/REAL(n_pwrk-1)

    DO i=1,n_pwrk
     pwrk(i)=REAL(i-1)*pwrk_step+pwrk_min
     k(i)=pwrk(i)**(1./pwr)
    ENDDO

    kpwri=absc(1)**pwr
    ki=absc(1)
    iaddo=max(0,Int((kpwri-pwrk_min)/pwrk_step+1))

   ff=0.d0
! SCAN OVER SPECTRUM
    DO i=2,number
     kpwrim1=kpwri
     kim1=ki
     kpwri=absc(i)**pwr
     ki=absc(i)
     iadd=max(0,Int((kpwri-pwrk_min)/pwrk_step+1))
     dtoto=0.d0
     dk=ki-kim1
! New k-cell iadd > iaddo: calculate local detas for each k-cell
     IF(iadd>iaddo) THEN
        DO j=iaddo,iadd-1
           dtot=(k(j+1)-kim1)/dk
           dlcl=dtot-dtoto
           dtoto=dtot
           ff(j)=ff(j)+dlcl/number
        ENDDO
        ff(iadd)=ff(iadd)+(1.d0-dtot)/number
! New k-cell iadd < iaddo: calculate local detas for each k-cell
     ELSEIF(iadd<iaddo) THEN
        DO j=iaddo,iadd+1,-1
           dtot=(k(j)-kim1)/dk
           dlcl=dtot-dtoto
           dtoto=dtot
           ff(j)=ff(j)+dlcl/number
        ENDDO
        ff(iadd)=ff(iadd)+(1.d0-dtot)/number
! New k-cell iadd = iaddo: entire deta remains in cell
     ELSE
        ff(iadd)=ff(iadd)+1./number
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
      gg(n_pwrk)=1.d0
	  gg(ng)=1.d0-.5d0*ff(ng)
      DO i=ng,1,-1
        gg(i-1)=gg(i)-.5d0*(ff(i-1)+ff(i))
! CONVERT FROM F*DELTAK TO F IF DESIRED
!       ff(i)=ff(i)/(k(i)-k(i-1))
      ENDDO
! OUTPUT of k vs g for all k-bins if desired
   IF(ipr>0) THEN
     WRITE(8,49) wvnm(1),wvnm(number)
     DO i=1,ng
        WRITE(8,50) k(i),ff(i),gg(i)
     ENDDO
   ENDIF

      IF(ipr<2) THEN
! Find k-values for selected g-values gqs
        i=0
        DO iq=1,nq
 12       IF(gg(i+1)>gq(iq)) THEN
            kq(iq)=k(i)+(k(i+1)-k(i))*(gq(iq)-gg(i))/(gg(i+1)-gg(i))
          ELSE
            i=i+1
            GOTO 12
          ENDIF
        ENDDO
      ENDIF

!
! CALCULATE KAPPABAR BY LBL AND NBK TO ASCERTAIN QUALITY OF K-DISTRIBUTION
! LBL
    kbarlbl=0.d0
    DO i=2,number
      kbarlbl=kbarlbl+absc(i)
    ENDDO
      kbarlbl=kbarlbl/number
! NBK
    kbarfsk=0.d0
    DO i=1,ng
      kbarfsk=kbarfsk+0.5d0*(k(i)+k(i-1))*(gg(i)-gg(i-1))
    ENDDO
    kperr=1d2*(1.d0-kbarfsk/kbarlbl)
    write(*,80) kbarlbl,kbarfsk,kperr
80  FORMAT('   k_bar-lbl =',e12.4,',  k_bar-nbk =',e12.4,'; error =',f7.2,'%')
    IF(kperr > .5d0) write(*,*) '   k-distribution questionable: increase n_pwrk or change pwr!'

   write(*,*) 'end of k-dist loop'

! OUTPUT of k vs g for Gaussian quadrature points if desired
   IF(ipr<2) THEN
     WRITE(7,48) wvnm(1),wvnm(number)
     DO iq=1,nq
      WRITE(7,50) gq(iq),wq(iq),kq(iq)
     ENDDO
   ENDIF
48 FORMAT(/'# wvnm_lft=',f12.6,'cm-1, wvnm_rgt=',f12.6,'cm-1'/ &
           'variables ='/'      gq             wq             kq')
49 FORMAT(/'# wvnm_lft=',f12.6,'cm-1, wvnm_rgt=',f12.6,'cm-1'/ &
           'variables ='/'      k              f              g')
50 FORMAT(20d14.6)

   IF(ipr<2) CLOSE(7)
   IF(ipr>0) CLOSE(8)

   END SUBROUTINE nbkdistsg

