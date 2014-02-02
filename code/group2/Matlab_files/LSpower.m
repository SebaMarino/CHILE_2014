function power = LSpower( omega, normedData, t, tau)
    term1nom = (sum(normedData.*cos(omega*(t-tau))))^2; 
    term1dnom = sum( (cos(omega.*(t - tau)) ).^2 ) ; 
    term2nom = (sum(normedData.*sin(omega*(t-tau))))^2; 
    term2dnom = sum( (sin(omega.*(t - tau)) ).^2 ) ; 
    power = 1/2*(term1nom/term1dnom + term2nom/term2dnom); 
end