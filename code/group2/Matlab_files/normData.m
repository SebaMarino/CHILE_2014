function dataout = normData(datain)
    hmean = mean(datain);
    hstd = std(datain);
    dataout = (datain - hmean)./hstd;
end