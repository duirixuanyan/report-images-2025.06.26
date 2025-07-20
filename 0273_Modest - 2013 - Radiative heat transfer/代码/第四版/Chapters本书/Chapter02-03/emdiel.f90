    function emdiel(n)
! Calculates spectral, hemispherical emittance of dielectric, eq(3.82)
    real*8 emdiel,n
    emdiel=(4.d0*n+2.d0)/3.d0/(n+1.d0)**2+2.d0*n**3*(n*n+2.d0*n-1.d0) &
                    /(n*n+1.d0)/(n**4-1.d0) &
                    -(n*(n*n-1.d0))**2/(n*n+1.d0)**3*dlog((n-1.d0)/(n+1.d0)) &
                    -8.d0*n**4*(n**4+1.d0)*dlog(n)/(n*n+1.d0)/(n**4-1.d0)**2
    return
    end
