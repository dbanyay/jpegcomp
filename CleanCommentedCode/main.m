close all;
clear all;
clc;
%% Reading Image and pre-processing

%Read the image in Uint8 format and convert any rgb image to grayscale.

im = imread('lena512.bmp');

if numel(size(im)) > 2
    im = rgb2gray(im);
end

%Change the image into double format which is necessary for the next step,
%i.e. centering all the values around zero

im = double(im);
    
im = im - 128;
% im = round(254*rand(8,18));                                                           %Test Image matrix

% txt = sprintf('Number of Bytes required to transmit raw image = %d', size(im,1)*size(im,2));
% disp(txt)
%% 8x8 Blocks Formation + DCT Transformation

bSize = 64;
%Making 8x8 blocks of image and taking DCT of each block
[numOfBlocks, im_8x8_DCT, newIm_size] = blocks_8x8(im);

sizeOfRawTxIm = newIm_size(1)*newIm_size(2);

txt = sprintf('Number of Bytes required to transmit raw image = %d bytes', sizeOfRawTxIm);
disp(txt)

% numOfBlocks
% size(imBlocks_8x8)
% imBlocks_8x8

%% Graphs for Comparison

comparisonFun(numOfBlocks,sizeOfRawTxIm,im_8x8_DCT,bSize);


%% Quantization

QF = 2;

txt = sprintf('Quantization Factor used to quantize the image for compression = %0.5f', QF);
disp(txt)

% for QF = [0:0.2:2,3:1:10];                                                                     %Quantization Factor
    for i = 1:8
        for j = 1:8
            quantMJpeg(i,j) = 1+((i+j-1)*QF);
        end
    end

%     % Standard JPEG Quantization Matrix
%     quantMJpeg = [16 11 10 16 24 40 51 61; ...
%         12 12 14 19 26 58 60 55; ...
%         14 13 16 24 40 57 69 56; ...
%         14 17 22 29 51 87 80 62; ...
%         18 22 37 56 68 109 103 77; ...
%         24 35 55 64 81 104 113 92; ...
%         49 64 78 87 103 121 120 101; ...
%         72 92 95 98 112 100 103 99;];
%         quantMJpeg = ones(8);

    %Quantizing the DCT Matrix using standard JPEG Quantization Matrix
    im_8x8_Quant(1:8,1:8,:) = floor(im_8x8_DCT(1:8,1:8,:)./quantMJpeg(1:8,1:8));

    %% Zig Zag Scanning

    %Zigzag scan transform of all 8x8 quantized matrices to conacatenated row vectors
    %size of zzOPVec = (1, 8*8*numOfBlocks)
    zzOPVec = ZigZagscan(im_8x8_Quant,numOfBlocks);
%     size(zzOPVec);
%     8*8*numOfBlocks;

    % sVec = size(zzOPVec)
    % sBlo = 64*numOfBlocks

    %% Run Length Coding

    %This section encodes the zigzag scanned row vector and it is of importance
    %to note here that zigzag scanned vector is a row vector.

    bSize = 64;

%     zzOPVec = [64 52 -1 0 1 0 0 8 19 0 0 0 8 0 0 0];
%     numOfBlocks = 2;
%     bSize = 8;

    %Original Run Length Encoder
    [oRLCoded, txSizeOri] = origRLC(zzOPVec,numOfBlocks,bSize);
    sizeOrig = ceil(txSizeOri/8);
    txt = sprintf('Number of Bytes required to transmit image compressed with original JPEG = %d bytes', sizeOrig);
    disp(txt)

    % txBytes = ceil(txSize/8)                                                    %Number of bytes required to tranmit or store compressed image

    %Optimized Run Length Encoder
    [pRLCoded, txSizeOpt] = propRLC(zzOPVec,numOfBlocks,bSize);
    sizeOpti = ceil(txSizeOpt/8);
    txt = sprintf('Number of Bytes required to transmit image compressed with optimized JPEG = %d bytes', sizeOpti);
    disp(txt)

    % txBytes = ceil(txSize/8)                                                    %Number of bytes required to tranmit or store compressed image
%     QuantizationValue(qInd) = QF;
%     qInd = qInd + 1;

% end

% figure()
% plot(QuantizationValue,sizeOpti,'*-g')
% hold on;
% plot(QuantizationValue,sizeOrig)

%% Reverse Run Length Coding

%Inverse Original RLC

input2ZZScanOrig = invOrigRLC(oRLCoded,bSize);
% error = zzOPVec - input2ZZScanOrig;
% stem(error)

%Inverse Optimized RLC

input2ZZScanOpti = invOptiRLC(pRLCoded,bSize);
% error2 = zzOPVec - input2ZZScanOpti;
% stem(error2)
%Inverse Optimized RLC

%% Reverse Zig-Zag

blocksOrig  = revZigZag(input2ZZScanOrig,numOfBlocks);
blocksOrig(1:8,1:8,:) = floor(blocksOrig(1:8,1:8,:).*quantMJpeg(1:8,1:8));

blocksOpti  = revZigZag(input2ZZScanOpti,numOfBlocks);
blocksOpti(1:8,1:8,:) = floor(blocksOpti(1:8,1:8,:).*quantMJpeg(1:8,1:8));

%% Reverse Quantization

%% Reverse DCT and Block formation

im_deblockOrig = deblock(blocksOrig,newIm_size);
im_deblockOrig = im_deblockOrig + 128;
figure()
imshow(uint8(im_deblockOrig));

% im_deblockOpti = deblock(blocksOpti,newIm_size);
% im_deblockOpti = im_deblockOpti + 128;
% figure()
% imshow(uint8(im_deblockOpti));
% error = im(1:newIm_size(1),1:newIm_size(2)) - im_deblock 

%% Tests
