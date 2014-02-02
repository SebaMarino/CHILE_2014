function fa = falsealarm(Pn,N)
    fa = (1-2*Pn/(N-1)).^((N-3)/2);
end