    program reversemc
! Program to calculate energy hitting small detector 
! from collimated light source, through an absorbing/scattering slab,
! using backward Monte Carlo
! includes absorption via energy partitioning
    USE DFLIB
    IMPLICIT NONE
    INTEGER :: i,N,in,idum=12345,numsmpl,numsmplhf,ns1=1
    REAL    :: L,kap,sig,beta,QT,DQ,x0,dx,dy,R,qd(50),thd,psi,xi,yi,zi
    REAL    :: sx,sy,sz,qdav,stddev,xe,ye,ze,sinth,ri,re,lzi,lze,lz1,lz2
    REAL    :: lscat,lend,szdet,Ibndl,z1,z2,lpart,a,b,c,d,Qadj,omg,den,var,stddevmax
    REAL, PARAMETER :: pi=3.1415927
    REAL, EXTERNAL :: RAN1
    open(unit=8,file='revmck2.dat',status='unknown')
    write(8,1)
    write(*,1)
  1 format('no. of bundles     q_det     variance    rel.var.(%)')
!
    L=1.        ! m
    sig=1.      ! 1/m
    kap=1.      ! 1/m
    N=1000
    QT=100.     ! W
    R=.1        ! m
    x0=.2       ! m
    dx=0.10     ! m
    dy=0.10     ! m
    thd=10.     ! deg
    N=1000
    numsmpl=10
    stddevmax=0.05
!    
    numsmplhf=numsmpl/2
    szdet=cos(thd*pi/180.)
    beta=kap+sig
    omg=kap/beta
    Qadj=QT/(4.*pi*R*R)*dx*dy*(1.-szdet*szdet)*sig/beta
    IF(kap<1.e-8) kap=1.e-8
    
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
! total distance until zi
          lzi=0.
! local distance to scattering event
 10       lscat=-alog(ran1(idum))/sig
          lend=lscat
! location of scattering event
 15       xe=xi+lend*sx
          ye=yi+lend*sy
          ze=zi+lend*sz
! check whether bundle leaves domain
          IF(ze<-1.e-7) THEN
              lend=-zi/sz
              GOTO 15
          ENDIF
          IF(ze>L) THEN
              lend=(L-zi)/sz
              GOTO 15
          ENDIF
! total distance until ze
          lze=lzi+(ze-zi)/sz
! check what part of lend is inside collimated beam
          ri=sqrt(xi*xi+yi*yi)
          re=sqrt(xe*xe+ye*ye)
          a=ri*ri-R*R
          b=sx*xi+sy*yi
          c=sx**2+sy**2
          d=b*b-a*c
          den=sz+omg
          IF(ri<R) THEN
! initial point is inside
             IF(re<R) THEN
                 Ibndl=Ibndl+(exp(-beta*zi-kap*lzi)-exp(-beta*ze-kap*lze))/den
             ELSE
                 lpart=-(b-sqrt(d))/c       ! distance to collimated beam exit point
                 lz2=lzi+lpart
                 z2=zi+lpart*sz
                 Ibndl=Ibndl+(exp(-beta*zi-kap*lzi)-exp(-beta*z2-kap*lz2))/den
             ENDIF
          ELSE
! initial point is outside
             IF(re<R) THEN
                 lpart=-(b+sqrt(d))/c       ! distance to collimated beam entry point
                 lz1=lzi+lpart
                 z1=zi+lpart*sz
                 Ibndl=Ibndl+(exp(-beta*z1-kap*lz1)-exp(-beta*ze-kap*lze))/den
             ELSE
                 IF(d<0.) GOTO 25           ! bundle's path does not intersect beam
                 lpart=-(b+sqrt(d))/c       ! distance to collimated beam entry point
                 IF(lpart>lend .or. lpart<0.) GOTO 25     ! never reaches collimated beam
                 lz1=lzi+lpart
                 z1=zi+lpart*sz
                 lpart=-(b-sqrt(d))/c       ! distance to collimated beam exit point
                 IF(lpart>lend) lpart=lend
                 lz2=lzi+lpart
                 z2=zi+lpart*sz
                 Ibndl=Ibndl+(exp(-beta*z1-kap*lz1)-exp(-beta*z2-kap*lz2))/den
             ENDIF
          ENDIF
! bundle leaves slab: tally up and go to next bundle 
 25       IF(ze<0.00001*L .or. ze>0.99999*L) THEN
              qd(i)=qd(i)+DQ*Ibndl
              CYCLE
          ENDIF
          xi=xe
          yi=ye
          zi=ze
          lzi=lze
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
