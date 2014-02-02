function tau = computeTau(omega, time)
    nom  = sum(sin(2*omega.*time)); 
    dnom = sum(cos(2*omega.*time)); 
    tau = atan(nom/dnom)/(2*omega);
end