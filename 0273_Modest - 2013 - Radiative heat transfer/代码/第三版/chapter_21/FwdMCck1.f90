    program forwardmc
! Program to calculate energy hitting small detector 
! from collimated light source, through an absorbing and 
! isotropically scattering slab, using forward Monte Carlo
! Uses standard ray tracing for absorption
    IMPLICIT NONE
    INTEGER :: i,N,in,idum=12345,numsmpl,numsmplhf,ns1=1
    REAL    :: L,kap,sig,QT,DQ,x0,dx,dy,R,qd(50),thd,ri,psi,xi,yi,zi,lscat,szdet
    REAL    :: sx,sy,sz,lbot,qdav,stddev,xe,ye,ze,sinth,labs,labsi,lend,stddevmax,var
    REAL, PARAMETER :: pi=3.145927
    REAL, EXTERNAL :: RAN1
    open(unit=8,file='fwdmck1.dat',status='unknown')
    write(8,1)
    write(*,1)
  1 format('no. of bundles     q_det     variance    rel.var.(%)')
!
    L=1.        ! m
    sig=1.      ! 1/m
    kap=1.      ! 1/m
    N=100000
    QT=100.     ! W
    R=.1        ! m
    x0=.2       ! m
    dx=0.10     ! m
    dy=0.10     ! m
    thd=10.     ! deg
    numsmpl=10
    stddevmax=0.05
!    
    numsmplhf=numsmpl/2
    szdet=cos(thd*pi/180.)
    IF(kap<1.e-8) kap=1.e-8

! loop to generate numsmpl 'samples'
  5 DQ=QT/N     ! W
    DO i=ns1,numsmpl
! initialize detector irradiation qd
    qd(i)=0.
! loop over N bundles
    DO in=1,N
! point of emission
    ri=R*sqrt(ran1(idum))
    psi=2.*pi*ran1(idum)
    xi=ri*cos(psi)
    yi=ri*sin(psi)
    zi=0.
! direction of emission
    sx=0.
    sy=0.
    sz=1.
! distance until absorption
    labs=-alog(ran1(idum))/kap
    labsi=0.
! distance to scattering event
 10 IF(labsi>labs) CYCLE
    lscat=-alog(ran1(idum))/sig
    IF(labsi+lscat>labs) THEN
        lend=labs-labsi
    ELSE
        lend=lscat
    ENDIF
! total photon path at scattering event (or more)
    labsi=labsi+lscat
! location of scattering event
 15 xe=xi+lend*sx
    ye=yi+lend*sy
    ze=zi+lend*sz
! check whether bundle leaves domain
    IF(ze<0.) CYCLE
    IF(ze>L) THEN
        IF(sz<szdet) CYCLE
        lbot=(L-zi)/sz
        xe=xi+lbot*sx
        ye=yi+lbot*sy
        IF(xe<x0 .or. xe>x0+dx .or. ye<0. .or. ye>dy) CYCLE
        qd(i)=qd(i)+DQ
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
    IF(stddev<stddevmax .and. qdav>1.e-12) GOTO 20
! combine pairs of samples and double number of bundles
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
