 MODULE basics
  IMPLICIT NONE
  REAL(8) :: pi
  REAL(8) :: alpha
  REAL(8) :: beta
  REAL(8) :: gamma
 END MODULE basics


    PROGRAM Deltacalc
! Program to calculate rotation matrix Delta_(m,m')^n for PN boundary conditions
! Uses Eqs (16.65) -- (16.67)
    USE basics
    IMPLICIT NONE
    INTEGER :: in, im, iq
    REAL(8) :: D, F, G, u, s, t, delta
    pi  = ACOS(-1.d0)
! Set rotation angles for forward or backward rotation
! forward
!    alpha = -pi/2.d0
!    beta = 3*pi/2.d0
!    gamma =  pi/2.d0
! backward
    alpha = -pi/2.d0
    beta =   pi/2.d0
    gamma =  pi/2.d0

    open(50, file = 'delta.dat')
    write(50,10)
      DO in = 0,4
         DO im = -in,in
            DO iq = -in,in
                delta =  s(iq)*u(im,alpha)*u(iq,gamma)*F(in,im,iq) &
                        -s(im)*u(-im,alpha)*u(-iq,gamma)*G(in,im,iq)

                write(50,20)in,im,iq,delta
            ENDDO
         ENDDO
      ENDDO

10 FORMAT("   n   m  m'    Delta")
20 FORMAT (3i4.1,f10.4)
   close (50)

 END PROGRAM Deltacalc




    REAL(8) FUNCTION D(n,m,q)
    USE basics
    IMPLICIT NONE
    INTEGER,INTENT(in) :: n, m, q
    INTEGER :: k, jmin, jmax
    REAL(8) :: sum, frac1, frac2
    REAL(8) :: fact, t
!
    jmin = max(0, q-m)
    jmax = min(n-m, n+q)
    sum  = 0.d0
 !
    DO k = jmin,jmax
       frac1 = ((COS(beta/2))**(2*n - 2*k - m + q)) &
              *((SIN(beta/2))**(2*k + m - q))
       frac2 = fact(k)*fact(n - m - k) &
              *fact(n + q - k)*fact(m - q + k)
       sum = sum + ((-1)**k)*frac1/frac2
    ENDDO
    D = ((-1)**(m+q))*t(m)*fact(n + ABS(q))*fact(n - ABS(m))*sum
!
    RETURN
  END FUNCTION D

   REAL(8) FUNCTION FACT(N)
   IMPLICIT NONE
   INTEGER :: n, j
!
   FACT=1.0
   DO J=2,N
   FACT=FACT*REAL(J)
   ENDDO
   RETURN
   END FUNCTION fact

   REAL(8) FUNCTION t(N)
   IMPLICIT NONE
   INTEGER :: N
!
   IF (ABS(N).GE.1) t = 1.d0
   IF (N.EQ.0) t = 0.5d0
   END FUNCTION t

   REAL(8) FUNCTION s(N)
   IMPLICIT NONE
   INTEGER :: N
!
   IF (N.GE.0) s =  1.d0
   IF (N.LT.0) s = -1.d0
   END FUNCTION s

   REAL(8) FUNCTION u(m,x)
   IMPLICIT NONE
   INTEGER :: m
   REAL(8) :: x
!
   IF (m.GE.0) u =  COS(m*x)
   IF (m.LT.0) u =  SIN(-m*x)
   END FUNCTION u

   REAL(8) FUNCTION F(n,m,q)
   IMPLICIT NONE
   INTEGER :: n,m,q
   REAL(8) :: D
!
   F = D(n,ABS(m),ABS(q)) + ((-1)**q)*D(n,ABS(m),-ABS(q))
   END FUNCTION F

   REAL(8) FUNCTION G(n,m,q)
   IMPLICIT NONE
   INTEGER :: n,m,q
   REAL(8) :: D
!
   G = D(n,ABS(m),ABS(q)) - ((-1)**q)*D(n,ABS(m),-ABS(q))
   END FUNCTION G


