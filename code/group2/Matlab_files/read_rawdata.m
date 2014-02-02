function data = read_rawdata(dir, prefix, FIELDid, CCDid)
    matchstring = [dir, prefix,'*', FIELDid,'_',CCDid,'*'];
    filels= ls(matchstring);
    if numel(filels) == 0
        fprintf('no match for %s\n', matchstring);
    end
    fnamelist = textscan(filels, '%s', 'delimiter',' ');
    for fname_ind = 1:numel(fnamelist)
        fprintf('Loading frame %s\n', fnamelist{fname_ind});
        data{fname_ind} = load(fnamelist{fname_ind});
    end
end