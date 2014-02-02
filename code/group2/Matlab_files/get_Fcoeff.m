function Fcoeff = get_Fcoeff(data, Pinfo, Nseries)
fouriermethod = ['fourier', num2str(Nseries)];
show_plot = 0;
for fld_ind = 1:numel(data)
    [nobj, Nnights] = size(data{fld_ind}.MJD);
    for obj = 1:nobj
        peakperiod = Pinfo{fld_ind}.peakperiods(obj,1);
        peakw = 2*pi/peakperiod;
        
        options = fitoptions(fouriermethod);
        
        options.Lower = [-ones(1,2*Nseries+1)*Inf 0.99*peakw];
        options.Upper = [ones(1,2*Nseries+1)*Inf 1.01*peakw];
        MJD = data{fld_ind}.MJD(obj,:)';
        lc = data{fld_ind}.mag(obj,:)';
        %tic
        f = fit(MJD - MJD(1) , lc, fouriermethod, options);
        %toc

        
        if show_plot
            figure(1)
            clf
            plot(f, mod(MJD-MJD(1), 2*pi/f.w), lc)
            title( sprintf('Fit method: %s\n', fouriermethod) )
            cont = input('Continue?', 's');
            if cont == 'n'
                break
            end
        end
        
                
        A1 = sqrt(f.a1.^2 + f.b1.^2);
        A2 = sqrt(f.a2.^2 + f.b2.^2);
        A3 = sqrt(f.a3.^2 + f.b3.^2);
        
        phi1 = atan(-f.b1./f.a1);
        phi2 = atan(-f.b2./f.a2);
        phi3 = atan(-f.b3./f.a3);
        
        Fcoeff{fld_ind}.R21(obj)   = A2./A1;
        Fcoeff{fld_ind}.R31(obj)   = A3./A1;
        Fcoeff{fld_ind}.phi21(obj) = phi1-2*phi2;
        Fcoeff{fld_ind}.phi31(obj) = phi1-3*phi3;
    end
end
