!      Main program for calculation of nondimensional temperature distribution
!      in a slab with coupled gray radiation+conduction with P1-approximation.
!      Example 21.2 (Radiative Heat Transfer, 4th Edition, Modest & Mazumder)
!      Both EXPLICIT  and SEMI-IMPLICIT coupling are implemented (user input).

!      Written by Sandip Mazumder
!      For queries, contact: mazumder.2@osu.edu
!----------------------------------------------------------------------------------------------------------------

    program CpldP1En1D

! Declaration of variables
    IMPLICIT NONE

! User Inputs
! Physical
    REAL(8), PARAMETER :: length = 1.0d0, & ! Thickness of slab
                                            abs=1.0d0, & ! absorption coefficient
                                            em1=1.0d0,em2=1.0d0, & ! Emittance of walls
                                            theta_l=2.0D0, & ! Boundary T ratio
                                            con_to_rad=1.0d0 ! Conduction to radiation number
! Numerical
    INTEGER(8), PARAMETER :: n_nodes=101, & ! Number of nodes
                                                  loop_out=1000 ! Maximum number of outer loop iterations
    REAL(8), PARAMETER :: tol_out=1.0D-6, & ! Tolerance for outer loop residual
                                            relax = 0.7d0 ! Relaxation factor (only for explicit)

    INTEGER(8), PARAMETER ::  semi_implicit=2, explicit = 1
    INTEGER(8) :: i,iter,method
    REAL(8), PARAMETER :: one=1.0D0,two=2.0d0,zero=0.0d0, sigma=5.67d-8,half=0.5d0
    REAL(8) :: t14,emcon1,emcon2,dt,dt2,res,res_g,res_t,res_total, &
                    res_total_1,dx,xx,theta_avg,res_total_g,res_total_t, &
                    res_total_g1,res_total_t1
    REAL(8), DIMENSION(n_nodes) :: theta,grad,g_old,th_old
    REAL(8), DIMENSION(n_nodes) :: aaa,rrr,ccc,ddd
!----------------------------------------------------------------------------------------------------------------

! Open necessary files for output
     OPEN(unit=11,file="CpldP1En1D_residual.dat",status="unknown") ! For residual
     OPEN(unit=10,file="CpldP1En1D.dat",status="unknown") ! For theta
    
!   User input
    method = semi_implicit ! Choices are "explicit" and "semi_implicit"

    dt = (length*abs)/(n_nodes-1)
    dt2 = dt*dt
    emcon1 = 3.0D0*em1/(two*(two-em1))
    emcon2 = 3.0D0*em2/(two*(two-em2))
    theta(:) = one
    theta(1) = one
    theta(n_nodes) = theta_l
    theta_avg = half*(one+theta_l)
    grad(:) = 4.0d0*sigma*(theta_avg**4)
    th_old(:) = theta(:)
    g_old(:) = grad(:)

! Branch out based on method
    SELECT CASE (method)

    CASE(semi_implicit)

    DO iter = 1,loop_out

!  First solve for G
      ddd(1) = two/dt2+two*emcon1/dt+3.0d0
      ccc(1) = -two/dt2
      rrr(1) = two*emcon1/dt+3.0d0
      DO i = 2,n_nodes-1
        ddd(i) = two/dt2 + 3.0D0
        ccc(i) = -one/dt2
        aaa(i-1) = -one/dt2
        rrr(i) = 3.0d0*(theta(i)**4)
      ENDDO 
      ddd(n_nodes) = two/dt2+two*emcon2/dt+3.0D0
      aaa(n_nodes-1) = -two/dt2
      ccc(n_nodes) = zero
      rrr(n_nodes) = (two*emcon2/dt+3.0d0)*(theta_l**4)
      CALL TRI(n_nodes,aaa,ddd,ccc,rrr,grad)
! Next solve for T
      res = zero
      ddd(1) = one
      ccc(1) = zero
      rrr(1) = one
      DO i = 2,n_nodes-1
        ddd(i) = two/dt2 + 4.0d0*(theta(i)**3)/con_to_rad
        ccc(i) = -one/dt2
        aaa(i-1) = -one/dt2
        rrr(i) = (3.0d0*(theta(i)**4)+grad(i))/con_to_rad
      ENDDO 
      ddd(n_nodes) = one
      ccc(n_nodes) = zero
      aaa(n_nodes-1) = zero
      rrr(n_nodes) = theta_l
      CALL TRI(n_nodes,aaa,ddd,ccc,rrr,theta)

!  Calculate Global Residual
      res_total_g = zero
      res_total_t = zero
      DO i=2,n_nodes-1
        res_g = (grad(i+1)-two*grad(i)+grad(i-1))/dt2+ &
                 3.0d0*(theta(i)**4-grad(i))
        res_t = (theta(i+1)-two*theta(i)+theta(i-1))/dt2 - &
                 (theta(i)**4-grad(i))/con_to_rad
        res_total_g = res_total_g + res_g*res_g
        res_total_t = res_total_t + res_t*res_t
      ENDDO
      res_g = two*(grad(2)-grad(1)+dt*emcon1*(theta(1)**4-grad(1)))/dt2 + &
              3.0D0*(theta(1)**4-grad(1))
      res_total_g = res_total_g + res_g*res_g
      res_g = two*(grad(n_nodes-1)-grad(n_nodes)+dt*emcon2* &
              (theta(n_nodes)**4-grad(n_nodes)))/dt2 + &
              3.0D0*(theta(n_nodes)**4-grad(n_nodes))
      res_total_g = res_total_g + res_g*res_g
      res_total_g = SQRT(res_total_g)
      res_total_t = SQRT(res_total_t)
      IF(iter == 1)THEN
        res_total_g1 = res_total_g
        res_total_t1 = res_total_t
      ENDIF
      res_total_g = res_total_g/res_total_g1
      res_total_t = res_total_t/res_total_t1
      print *, iter, res_total_t,res_total_g
      WRITE(11,*) iter, res_total_t,res_total_g
      IF(res_total_g < tol_out .and. res_total_t < tol_out) EXIT
    ENDDO  ! Outer iteration

    CASE(explicit)

    DO iter = 1,loop_out

! First solve for G
      ddd(1) = two/dt2+two*emcon1/dt+3.0d0
      ccc(1) = -two/dt2
      rrr(1) = two*emcon1/dt+3.0d0
      DO i = 2,n_nodes-1
        ddd(i) = two/dt2 + 3.0D0
        ccc(i) = -one/dt2
        aaa(i-1) = -one/dt2
        rrr(i) = 3.0d0*(theta(i)**4)
      ENDDO 
      ddd(n_nodes) = two/dt2+two*emcon2/dt+3.0D0
      aaa(n_nodes-1) = -two/dt2
      ccc(n_nodes) = zero
      rrr(n_nodes) = (two*emcon2/dt+3.0d0)*(theta_l**4)
      CALL TRI(n_nodes,aaa,ddd,ccc,rrr,grad)
! Next solve for T
      th_old(:) = theta(:)
      res = zero
      ddd(1) = one
      ccc(1) = zero
      rrr(1) = one
      DO i = 2,n_nodes-1
        ddd(i) = two/dt2 
        ccc(i) = -one/dt2
        aaa(i-1) = -one/dt2
        rrr(i) = (-(theta(i)**4)+grad(i))/con_to_rad
      ENDDO 
      ddd(n_nodes) = one
      ccc(n_nodes) = zero
      aaa(n_nodes-1) = zero       
      rrr(n_nodes) = theta_l
      CALL TRI(n_nodes,aaa,ddd,ccc,rrr,theta)
      theta(:) = relax*theta(:) + (one-relax)*th_old(:)  ! Under-relax Temperature

! Calculate Global Residual
      res_total_g = zero
      res_total_t = zero
      DO i=2,n_nodes-1
        res_g = (grad(i+1)-two*grad(i)+grad(i-1))/dt2+ &
                 3.0d0*(theta(i)**4-grad(i))
        res_t = (theta(i+1)-two*theta(i)+theta(i-1))/dt2 - &
                 (theta(i)**4-grad(i))/con_to_rad
        res_total_g = res_total_g + res_g*res_g
        res_total_t = res_total_t + res_t*res_t
      ENDDO
      res_g = two*(grad(2)-grad(1)+dt*emcon1*(theta(1)**4-grad(1)))/dt2 + &
              3.0D0*(theta(1)**4-grad(1))
      res_total_g = res_total_g + res_g*res_g
      res_g = two*(grad(n_nodes-1)-grad(n_nodes)+dt*emcon2* &
              (theta(n_nodes)**4-grad(n_nodes)))/dt2 + &
              3.0D0*(theta(n_nodes)**4-grad(n_nodes))
      res_total_g = res_total_g + res_g*res_g
      res_total_g = SQRT(res_total_g)
      res_total_t = SQRT(res_total_t)
      IF(iter == 1)THEN
        res_total_g1 = res_total_g
        res_total_t1 = res_total_t
      ENDIF
      res_total_g = res_total_g/res_total_g1
      res_total_t = res_total_t/res_total_t1
      print *, iter, res_total_t,res_total_g
      WRITE(11,*) iter, res_total_t,res_total_g
      IF(res_total_g < tol_out .and. res_total_t < tol_out)EXIT
    ENDDO  ! global iteration

    END SELECT

! Print Tempearture Distribution to file
    xx = -dt
    DO i=1,n_nodes
      xx = xx + dt
      WRITE(10,*) xx,theta(i)
    ENDDO

    CLOSE(unit=10)
    CLOSE(unit=11)

    END Program CpldP1En1D

!--------------------------------------------------------------------------
! Tridiagonal solver (uses Thomas Algorithm)

    SUBROUTINE TRI(n,a,d,c,b,x)

    INTEGER(8), INTENT(in) :: n
    INTEGER(8) :: i
    REAL(8) :: xmult
    REAL(8), DIMENSION(n) :: a,b,c,d,x

    DO i = 2,n
      xmult = a(i-1)/d(i-1)
      d(i) = d(i) - xmult*c(i-1)
      b(i) = b(i) - xmult*b(i-1)
    ENDDO

    x(n) = b(n)/d(n)
    DO i = n-1,1,-1
      x(i) = (b(i)-c(i)*x(i+1))/d(i)
    ENDDO

    END SUBROUTINE TRI
