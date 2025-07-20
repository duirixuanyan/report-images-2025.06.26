    program callemdiel
    real*8 emdiel,n,emnml
 5  write(*,*) 'input n'
    read(*,*) n
	IF(n <= 1.d0) THEN
		WRITE(*,*) '*** n must be > 1!! ***'
		GOTO 5
	ENDIF
    emnml=1.d0-((n-1)/(n+1))**2
    write(*,10) n,emnml,emdiel(n)
10  format('n=',f5.2,';   normal eps =',f5.3,',  hemispherical eps =',f5.3)
    stop
    end

    function emdiel(n)
! Calculates spectral, hemispherical emittance of dielectric, eq(3.82)
    real*8 emdiel,n
    emdiel=(4.d0*n+2.d0)/3.d0/(n+1.d0)**2+2.d0*n**3*(n*n+2.d0*n-1.d0) &
                    /(n*n+1.d0)/(n**4-1.d0) &
                    -(n*(n*n-1.d0))**2/(n*n+1.d0)**3*dlog((n-1.d0)/(n+1.d0)) &
                    -8.d0*n**4*(n**4+1.d0)*dlog(n)/(n*n+1.d0)/(n**4-1.d0)**2
    return
    end
