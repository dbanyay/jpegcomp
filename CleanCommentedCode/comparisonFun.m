function comparisonFun(numOfBlocks,sizeOfRawTxIm,im_8x8_DCT,bSize)

index = 1;

for QF = [0:0.2:2,3:1:10];                                                                     %Quantization Factor
    for i = 1:8
        for j = 1:8
            quantMJpeg(i,j) = 1+((i+j-1)*QF);
        end
    end
    im_8x8_Quant(1:8,1:8,:) = floor(im_8x8_DCT(1:8,1:8,:)./quantMJpeg(1:8,1:8));
    zzOPVec = ZigZagscan(im_8x8_Quant,numOfBlocks);
    [oRLCoded, txSizeOri] = origRLC(zzOPVec,numOfBlocks,bSize);
    sizeOrig (index) = ceil(ceil(txSizeOri/8)/1024);
    [pRLCoded, txSizeOpt] = propRLC(zzOPVec,numOfBlocks,bSize);
    sizeOpti (index) = ceil(ceil(txSizeOpt/8)/1024);
    quantizF (index) = QF;
    sizeUc (index) = ceil(sizeOfRawTxIm/1024);
    index = index + 1;
end

figure()
plot(quantizF,sizeUc)
hold on;
plot(quantizF,sizeOrig,'*-g')
hold on;
plot(quantizF,sizeOpti,'^--r')
title('Quantization Versus Compression Tradeoff')
xlabel('Quantization Factor')
ylabel('Size of compressed Image in kiloBytes')
legend('Original Uncompressed Image','Image comression using original JPEG','Image compression using proposed JPEG')
hold off;


end
