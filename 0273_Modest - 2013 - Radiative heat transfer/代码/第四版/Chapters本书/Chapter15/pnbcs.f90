    program pnbc
! Program to calculate PN boundary condition parameters p_(n,j)^m, {u,v,w}_(l,i)^m
    implicit none
    integer, parameter :: NN=5,NN2=(NN-1)/2,NN3=(NN+1)*(NN+2)*(NN+3)/6-1
    integer :: m,n,j,fact,i,l,k
    real*8  :: Pnm0,p(0:NN,0:NN,0:NN),u(0:NN,0:NN2,NN2+1),v(0:NN,0:NN2,NN2+1),w(0:NN,0:NN2,NN2+1),pnlm(0:NN3)
    external Pnm0
    OPEN(unit=9,name='PNbc.dat')
!pnjm
    DO m=0,NN
      write(9,10) m,(j,j=m,NN)
      DO n=m,NN
         IF(n>m+1) THEN
            DO j=m,n-2
               p(m,n,j)=((2*n-1)*(Pnm0(n-1,m)*Pnm0(j,m)-(j-m+1)*p(m,n-1,j+1)) &
                                 +(n+j-1)*(n+m-1)*p(m,n-2,j))/((n-j)*(n-m))
               p(m,j,n)=p(m,n,j)
            ENDDO !j
            p(m,n,n-1)=((2*n-1)*Pnm0(n-1,m)**2+2*(n-1)*(n+m-1)*p(m,n-1,n-2))/dfloat(2*n*(n-m))
            p(m,n-1,n)=p(m,n,n-1)
         ELSEIF(n>m) THEN
            p(m,n,n-1)=(2*n-1)*Pnm0(n-1,m)**2/dfloat(2*n)
            p(m,n-1,n)=p(m,n,n-1)
         ENDIF
         p(m,n,n)=dfloat(fact(n+m))/dfloat((2*n+1)*fact(n-m))
         DO l=m,n
           k=n*(n+1)*(n+2)/6+l*(l+1)/2+m
           pnlm(k)=p(m,n,l)*(n+l+1)*2**(n-m)
         ENDDO
         write(9,20) n,(p(m,n,j)/10**m,j=m,n)
      ENDDO !n
    ENDDO !m
!u,v,w
    DO m=0,NN
      write(9,30) m,(i,i=1,NN2+1)
      l=0  
        DO i=1,NN2+1
           u(m,l,i)=-p(m,2*l+1,2*i-1)/(2*(4*l+1))
           v(m,l,i)=-(2*l-m)*(2*l-m+1)*p(m,2*l+1,2*i-1)/(2*(4*l+1))
           w(m,l,i)=(2*l-m+1)*p(m,2*l+1,2*i-1)/(4*l+1)
        ENDDO
        write(9,31) l,(u(m,l,i)/10**m,i=1,NN2+1)
        write(9,32) (v(m,l,i)/10**m,i=1,NN2+1)
        write(9,33) (w(m,l,i)/10**m,i=1,NN2+1)
      DO l=1,NN2
        DO i=1,NN2+1
           u(m,l,i)=(p(m,2*l-1,2*i-1)-p(m,2*l+1,2*i-1))/(2*(4*l+1))
           v(m,l,i)=((2*l+m)*(2*l+m+1)*p(m,2*l-1,2*i-1)-(2*l-m)*(2*l-m+1)*p(m,2*l+1,2*i-1))/(2*(4*l+1))
           w(m,l,i)=((2*l+m)*p(m,2*l-1,2*i-1)+(2*l-m+1)*p(m,2*l+1,2*i-1))/(4*l+1)
        ENDDO
        write(9,31) l,(u(m,l,i)/10**m,i=1,NN2+1)
        write(9,32) (v(m,l,i)/10**m,i=1,NN2+1)
        write(9,33) (w(m,l,i)/10**m,i=1,NN2+1)
      ENDDO !n
    ENDDO !m
10  FORMAT(///'*** p_nj^m *** m =',I2//4X,'n\j',20I10)
20  FORMAT(I5,5x,20f10.5)
30  FORMAT(///'*** u,v,w *** m =',I2//4X,'l\i',20I10)
31  FORMAT(I5,3x,'u',20f10.5)
32  FORMAT(8x,'v',20f10.5)
33  FORMAT(8x,'w',20f10.5)
    CLOSE(9)
    stop
    end
    Function fact(n)
    implicit none
    integer :: n,i,fact
    fact=1
    IF(n<2) RETURN
    DO i=2,n
        fact=fact*i
    ENDDO
    RETURN
    END
    Function Pnm0(n,m)
    implicit none
    integer :: n,m,i1,i2,fact
    real*8  :: Pnm0
    Pnm0=0.d0
    i1=(n+m)/2
    i2=(n-m)/2
    IF(i1+i2<n) RETURN
    Pnm0=(2-1/(n+1))*(-1)**i1*dfloat(fact(n+m-1))/dfloat(2**n*fact(i1-1)*fact(i2))
    RETURN
    END
    



    
