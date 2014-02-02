function data = read_franlc(dir, fieldID)
ncol = 14;
gain = 4.47;
maxepochs = 16;
datafld_names = {'source', 'MJD', 'RA', 'DEC', 'x', 'y', 'flux','e_flux', 'radius', 'bg', 'sky', 'trans', 'modflux', 'errest', 'mag', 'magerr'};

for fld_ind = 1:numel(fieldID)
    epoch = 0;
    for epoch0 = 1:maxepochs
        datname = ['Blind_', fieldID{fld_ind},'_',sprintf('%02d',epoch0), '.fits.fz_proj.fits-sources.dat'];
        fname = [dir,datname];
        if exist(fname) == 0 || epoch0 == 11
            fprintf('%s was not read!\n',datname)
            continue
        else
            epoch = epoch+1;            
            clear data_raw
            headerlines = 2;
            fid = fopen(fname,'r');
            data_raw = textscan(fid, '%f','HeaderLines',2);
            fclose(fid);
            datacell{epoch} = reshape(data_raw{1}, ncol, [])';
            data{fld_ind}.fieldname = fieldID{fld_ind};
            data{fld_ind}.source(:,epoch) = datacell{epoch}(:, 1); % we only need source ID from 1 epoch
            data{fld_ind}.MJD(:,epoch) = datacell{epoch}(:, 2);
            data{fld_ind}.RA(:,epoch) =datacell{epoch}(:,3);
            data{fld_ind}.DEC(:,epoch) =datacell{epoch}(:,4);
            data{fld_ind}.x(:,epoch) =datacell{epoch}(:,5);
            data{fld_ind}.y(:,epoch) =datacell{epoch}(:,6);
            data{fld_ind}.flux(:,epoch) = datacell{epoch}(:, 7);
            data{fld_ind}.e_flux(:,epoch) = datacell{epoch}(:, 8);
            data{fld_ind}.radius(:,epoch) = datacell{epoch}(:, 9);
            data{fld_ind}.bg(:,epoch) = datacell{epoch}(:, 11);
            data{fld_ind}.sky(:,epoch) = datacell{epoch}(:, 12);
            data{fld_ind}.trans(:,epoch) = datacell{epoch}(:, 13);
            data{fld_ind}.modflux(:,epoch) = data{fld_ind}.flux(:,epoch)./data{fld_ind}.trans(:,epoch);
            data{fld_ind}.errest(:, epoch) = sqrt(data{fld_ind}.modflux(:,epoch)/gain + (data{fld_ind}.sky(:,epoch)).^2);
            data{fld_ind}.mag(:, epoch) = real(-2.5*log10(data{fld_ind}.modflux(:,epoch)));
            data{fld_ind}.magerr(:, epoch) = real(2.5/log(10)*data{fld_ind}.errest(:, epoch)./data{fld_ind}.modflux(:,epoch));

        end
    end
    if epoch > 0        
        clear r c rdelete
        [r, c] = find(data{fld_ind}.flux == 0);
        rdelete = unique(r);
        for datafld_ind = 1:numel(datafld_names)
            data{fld_ind}.(datafld_names{datafld_ind}) = removerows(data{fld_ind}.(datafld_names{datafld_ind}), 'ind', rdelete);
        end
        data{fld_ind}.alphacorr = sum( iqr(data{fld_ind}.mag, 2).*median(data{fld_ind}.magerr,2) )/...
            ( sum(  median( data{fld_ind}.magerr,2 ).^2)  );
        fprintf('--Read %d epochs in field %s\n',epoch,data{fld_ind}.fieldname);
    else
        data={};
    end
end
