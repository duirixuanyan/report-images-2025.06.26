    function emmet(n,k)
! Calculates spectral, hemispherical emittance of a metal, eq(3.77)
! (accurate for k>=n only; do not use for dielectrics (k=0)!!
    real*8 emmet,emparl,emperp,n,k,c1,c2,c3
    c1=n*n+k*k
    c2=n*n-k*k
    c3=(n+1)*(n+1)+k*k
    k=max(k,1.d-5)  ! guard against k=0
    emparl=8.d0*n/c1*(1.d0-n/c1*log(c3)+c2/(k*c1)*atan(k/(n+1.d0)))
    emperp=8.d0*n*(1.d0-n*log(c3/c1)+c2/k*atan(k/(n+c1)))
    
    emmet=.5d0*(emparl+emperp)
    return
    end
