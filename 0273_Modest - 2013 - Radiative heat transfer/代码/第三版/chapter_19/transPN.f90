    program transPN
! Program to calculate energy transmitted as a function of time 
! from a pulsed collimated laser source, through absorbing-scattering slab,
! using P1 and P1/3
    IMPLICIT NONE
    INTEGER, PARAMETER :: Nx=200
    INTEGER :: i,n
    DOUBLE PRECISION    :: L,tp,tps,beta,omga,tauL,dx,dt,trmsv,reflc,Bp,Bm,tme,tc
    DOUBLE PRECISION    :: G(0:Nx),Gx(0:Nx),Gt(0:Nx),G5(0:Nx),Gx5(0:Nx),Gt5(0:Nx)
    DOUBLE PRECISION    :: alf,c1,c2,c3,c4,Gc,Gc5,Gcp,Gcp5,Heav,y,E1,E2,D1,D2,f1,f2,f3,f4
    DOUBLE PRECISION    :: tmax,a,sumpls,sumtrn,sumref
    Heav(y)=FLOAT(INT(1.+.5*y/(abs(y)+1.d-15)))
! *******************   Pulse shape  ***********************************
! uncomment only one set of laser data below!!
! the following 4 lines simulate a top hat laser starting at n*dt=0
    Gc(n,i)=(Heav(n*dt-i*dx)-Heav(n*dt-i*dx-tps))*exp(-i*dx)
    Gc5(n,i)=(Heav(n*dt-(i+.5)*dx)-Heav(n*dt-(i+.5)*dx-tps))*exp(-(i+.5)*dx)
    Gcp(n,i)=Gc(n,i)  
    Gcp5(n,i)=Gc5(n,i)
! the following 6 lines simulate a clipped Gaussian laser centered at n*dt=tc
!    Gc(n,i)=exp(-i*dx-((n*dt-i*dx-tc)/tp)**2) &
!            *(Heav(n*dt-i*dx)-Heav(n*dt-i*dx-2.*tc))
!    Gcp(n,i)=Gc(n,i)*(1.-2.*a*(n*dt-i*dx-tc)/tp**2)
!    Gc5(n,i)=exp(-(i+.5)*dx-((n*dt-(i+.5)*dx-tc)/tp)**2) &
!            *(Heav(n*dt-(i+.5)*dx)-Heav(n*dt-(i+.5)*dx-2.*tc))
!    Gcp5(n,i)=Gc5(n,i)*(1.-2.*a*(n*dt-(i+.5)*dx-tc)/tp**2)
!
! ********************  Output file  ***********************************
    open(unit=8,file='transP3rd-5-100.dat',status='unknown')
! ****************  Input data  ****************************************
    a=1.d0/3.d0 ! =1 for P1, =1/3 for P1/3 approximation
    L=1.        ! m
    beta=5.     ! 1/m
    omga=1
    tmax=80.    ! maximum t* to be considered
! pulse data: make sure to uncomment only 1 starting time "tme"
! pulse width for top-hat laser
    tps=0.3             ! total pulse duration = total pulse power
    tme=-tps/2.         ! non-zero value moves beginning of pulse; -tps/2 centers pulse at 0
! pulse shape for clipped Gaussian laser
    tc=0.5
    tp=tps/1.77245d0    ! total pulse power/sqrt(pi)
!   tme=-tc
! ****************  End of input data  *********************************
    
! Output header formatted for TECPLOT
    write(8,5)
 5  format('VARIABLES = tme,trmsv,reflc'/'zone')
!
    tauL=beta*L
! signal speed=characteristic
    alf=1/sqrt(3.*a)
    dx=taul/Nx
    dt=dx/(2.*alf)
!
    c1=.25*dx*(1.-omga+1./a)
    c2=(1.-omga)/(4.*a)*dx
    c3=omga/(4.*a)*dx
    c4=alf*alf
    Bp=c1+alf
    Bm=c1-alf
    
! initialize incident radiation
    n=0
    G=0.
    Gx=0.
    Gt=0.
    sumtrn=0.d0
    sumref=0.d0
    sumpls=.5*Gc(n,0)
! odd time step without boundary condition
 10 n=n+1
    tme=tme+dt
    DO i=0,Nx-1
        E1=-Bm*Gt(i)-c4*Gx(i)-c2*G(i)+c3*(Gcp5(n,i)+Gcp(n-1,i))
        E2=-Bm*Gt(i+1)+c4*Gx(i+1)-c2*G(i+1)+c3*(Gcp5(n,i)+Gcp(n-1,i+1))
        Gx5(i)=(E2-E1)/(2.*c4)
        D1=.5*(E1+E2)
        D2=.5*(G(i)+G(i+1))+.125*dx*(Gx(i)-Gx(i+1))+.25*dt*(Gt(i)+Gt(i+1))
        Gt5(i)=(D1-c2*D2)/(c2*.5*dt+Bp)
        G5(i)=(.5*dt*D1+Bp*D2)/(c2*.5*dt+Bp)
    ENDDO 
    sumpls=sumpls+Gc(n,0)
! even time step with boundary condition
    n=n+1
    tme=tme+dt
    DO i=1,Nx-1
        E1=-Bm*Gt5(i-1)-c4*Gx5(i-1)-c2*G5(i-1)+c3*(Gcp(n,i)+Gcp5(n-1,i-1))
        E2=-Bm*Gt5(i)+c4*Gx5(i)-c2*G5(i)+c3*(Gcp(n,i)+Gcp5(n-1,i))
        Gx(i)=(E2-E1)/(2.*c4)
        D1=.5*(E1+E2)
        D2=.5*(G5(i-1)+G5(i))+.125*dx*(Gx5(i-1)-Gx5(i))+.25*dt*(Gt5(i-1)+Gt5(i))
        Gt(i)=(D1-c2*D2)/(c2*.5*dt+Bp)
        G(i)=(.5*dt*D1+Bp*D2)/(c2*.5*dt+Bp)
    ENDDO
    i=0
    E2=-Bm*Gt5(i)+c4*Gx5(i)-c2*G5(i)+c3*(Gcp(n,i)+Gcp5(n-1,i))
    D2=G5(i)-.25*dx*Gx5(i)+.5*dt*Gt5(i)
    f1=Bp+.5
    f2=c2+1.5*c4
    f3=.125*dx/c4-.5*dt
    f4=1.+.375*dx
    Gt(i)=(f4*E2-f2*D2)/(f1*f4-f2*f3)
    G(i)=(f1*D2-f3*E2)/(f1*f4-f2*f3)
    Gx(i)=1.5*G(i)+.5/c4*Gt(i)
    i=Nx
    E1=-Bm*Gt5(i-1)-c4*Gx5(i-1)-c2*G5(i-1)+c3*(Gcp(n,i)+Gcp5(n-1,i-1))
    D2=G5(i-1)+.25*dx*Gx5(i-1)+.5*dt*Gt5(i-1)
    Gt(i)=(f4*E1-f2*D2)/(f1*f4-f2*f3)
    G(i)=(f1*D2-f3*E1)/(f1*f4-f2*f3)
    Gx(i)=-1.5*G(i)-.5/c4*Gt(i)
! transmissivity
    trmsv=.5*G(Nx)+Gc(n,i)
    reflc=.5*G(0)
    sumpls=sumpls+Gc(n,0)
    sumtrn=sumtrn+trmsv
    sumref=sumref+reflc
    write(8,20) tme,trmsv,reflc
 20 format(f8.3,2e13.4)
    IF(tme<tmax) GOTO 10
    sumpls=sumpls*dt
    sumtrn=sumtrn*2*dt
    sumref=sumref*2*dt
    write(8,30) sumtrn,sumref,sumtrn+sumref,sumpls
 30 format(/'Total transmission:',1pe13.3/'Total reflection:  ',1pe13.3/&
            'Total trans+reflec:',1pe13.3/'Total pulse enrg:  ',1pe13.3)
    STOP
    END
    
