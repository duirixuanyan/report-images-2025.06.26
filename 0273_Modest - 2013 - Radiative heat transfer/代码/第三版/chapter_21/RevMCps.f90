    program reversemcps
! Program to calculate energy hitting small detector 
! from a point source, through a purely scattering slab,
! using backward Monte Carlo 
! assumes no direct radiation hits detector
    IMPLICIT NONE
    INTEGER :: i,j,N,in,idum=12345,numsmpl,numsmplhf,ns1=1,numint
    REAL    :: L,sig,QT,DQ,x0,dx,dy,qd(50),thd,psi,xi,yi,zi,zps
    REAL    :: sx,sy,sz,lbot,qdav,stddev,xe,ye,ze,sinth,ri,re,mu,sint,ds
    REAL    :: lscat,szdet,Ibndl,Qadj,si,rsq,rminsq,tminsq,smin,fac,pmc,var,stddevmax
    REAL, PARAMETER :: pi=3.1415927
    REAL, EXTERNAL :: RAN1
    open(unit=8,file='revmcps.dat',status='unknown')
    write(8,1)
    write(*,1)
  1 format('no. of bundles     q_det     variance    rel.var.(%)')
!
    L=1.        ! m
    sig=1.      ! 1/m
    N=1000
    QT=100.     ! W
    zps=.5      ! m
    x0=.2       ! m
    dx=0.10     ! m
    dy=0.10     ! m
    thd=10.     ! deg
    numsmpl=10
    stddevmax=0.05
!    
    numsmplhf=numsmpl/2
    szdet=cos(thd*pi/180.)
    Qadj=sig*QT/(16.*pi)*dx*dy*(1.-szdet*szdet) 
! guard against direct radiation hitting detector
    IF(thd > 180./pi*atan(x0/(L-zps))) THEN
       write(*,*) 'WARNING: thd too large (direct radiation hits detector)!!'
       STOP
    ENDIF
    
! loop to generate numsmpl 'samples'
  5 DQ=Qadj/N       ! W
    DO i=ns1,numsmpl
! initialize detector irradiation qd
       qd(i)=0.
! loop over N bundles
       DO in=1,N
          Ibndl=0.
! point of emission
          xi=x0+dx*ran1(idum)
          yi=dx*ran1(idum)
          zi=L
! direction of emission
          sz=-sqrt(1.-(1.-szdet*szdet)*ran1(idum))
          sinth=sqrt(1.-sz*sz)
          psi=2.*pi*ran1(idum)
          sx=sinth*cos(psi)
          sy=sinth*sin(psi)
! distance to scattering event
 10       lscat=-alog(ran1(idum))/sig
! location of scattering event
 15       xe=xi+lscat*sx
          ye=yi+lscat*sy
          ze=zi+lscat*sz
! check whether bundle leaves domain
          IF(ze<-1.e-7) THEN
              lscat=-zi/sz
              GOTO 15
          ENDIF
          IF(ze>L) THEN
              lscat=(L-zi)/sz
              GOTO 15
          ENDIF
! calculate integral of path contribution by random function evaluation
          rsq=xi**2+yi**2+(zi-zps)**2
          numint=5+1./rsq
          sint=0.
          DO j=1,numint
             si=ran1(idum)*lscat
             rsq=(xi+sx*si)**2+(yi+sy*si)**2+(zi-zps+sz*si)**2
             sint=sint+exp(-sig*sqrt(rsq))/rsq
          ENDDO   ! j
          sint=sint*lscat/numint
          Ibndl=Ibndl+sint
! bundle leaves slab: tally up and go to next bundle
 25       IF(ze<0.000001*L .or. ze>0.999999*L) THEN
              qd(i)=qd(i)+DQ*Ibndl
              CYCLE
          ENDIF
          xi=xe
          yi=ye
          zi=ze
! new direction after isotropic scattering
          sz=1.-2.*ran1(idum)
          sinth=sqrt(1.-sz*sz)
          psi=2.*pi*ran1(idum)
          sx=sinth*cos(psi)
          sy=sinth*sin(psi)
          GOTO 10
       ENDDO   !in
    ENDDO   !i
!
! find average value and std dev
    qdav=0.
    DO i=1,numsmpl
       qdav=qdav+qd(i)
    ENDDO   !i
    qdav=qdav/numsmpl
    stddev=0.
    DO i=1,numsmpl
       stddev=stddev+(qd(i)-qdav)**2
    ENDDO   !i
    var=sqrt(stddev/(numsmpl*(numsmpl-1)))
    stddev=var/qdav
    write(8,2) N*numsmpl,qdav,var,stddev*100
    write(*,2) N*numsmpl,qdav,var,stddev*100
  2 format(4x,i10,2e12.4,f11.2)
    IF(stddev<stddevmax) GOTO 20
! combine pairs of samples and double number of bundeles
    DO i=1,numsmplhf
       qd(i)=0.5*(qd(i)+qd(i+numsmplhf))
    ENDDO   !i
    N=2*N
    ns1=numsmplhf+1
    GOTO 5
 20 close(8)
    STOP
    END


      FUNCTION ran1(idum)
      INTEGER idum,IA,IM,IQ,IR,NTAB,NDIV
      REAL ran1,AM,EPS,RNMX
      PARAMETER (IA=16807,IM=2147483647,AM=1./IM,IQ=127773,IR=2836,&
        NTAB=32,NDIV=1+(IM-1)/NTAB,EPS=1.2e-7,RNMX=1.-EPS)
      INTEGER j,k,iv(NTAB),iy
      SAVE iv,iy
      DATA iv /NTAB*0/, iy /0/
      if (idum.le.0.or.iy.eq.0) then
        idum=max(-idum,1)
        do 11 j=NTAB+8,1,-1
          k=idum/IQ
          idum=IA*(idum-k*IQ)-IR*k
          if (idum.lt.0) idum=idum+IM
          if (j.le.NTAB) iv(j)=idum
11      continue
        iy=iv(1)
      endif
      k=idum/IQ
      idum=IA*(idum-k*IQ)-IR*k
      if (idum.lt.0) idum=idum+IM
      j=1+iy/NDIV
      iy=iv(j)
      iv(j)=idum
      ran1=min(AM*iy,RNMX)
      return
      END
