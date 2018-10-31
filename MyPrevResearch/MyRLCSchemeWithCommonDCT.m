clear
warning off all
clc

aToz = 1;
% All Black & White Pictures
% S = imread('westconcordorthophoto.png');
% SS = size(S);
% S = imread('moon.tif');
% SS = size(S);
% S = imread('coins.png');
% SS = size(S);
% S = imread('eight.tif');
% SS = size(S);
S = (imread('lena512.bmp'));
SS = size(S);
%S = double(imread('earth.jpg'));
%S = rgb2gray(S);
%SS = size(S);




S = S -128;

SS(1) = SS(1) - rem(SS(1),8);
SS(2) = SS(2) - rem(SS(2),8);
% Thresh = input('Enter the value of threshold value: ');
% QF = input('Enter the value of Quality Factor:  ')
TotalImageSizeForRawTransmission = SS(1)*SS(2);
rowsmax = (SS(1)/8);
columnsmax = (SS(2)/8);


for ro = 1:rowsmax
    for co = 1:columnsmax

      MatrixForEbyE = zeros(8,8);
        MatrixForEbyE = S([8*(ro-1)+1:8*ro],[8*(co-1)+1:8*co]);
        BlockDCT  = zeros(8,8);
          BlockDCT = dct2(MatrixForEbyE);
          CompleteDCT ([8*(ro-1)+1:8*ro],[8*(co-1)+1:8*co]) = BlockDCT;
    end
end

%imshow(CompleteDCT)


for QF = [0:0.2:2,3:1:10]
tic
    QF
    clear RLC
%Defining the Quantization Matrix Q
for i = 1:8
            for j = 1:8
                Q(i,j) = 1+((i+j-1)*QF);
            end
end
        

% TotalBlocks = rowsmax*columnsmax;

%Dividing image into block of 8x8 blocks
n = 1;
nn = 0;
nz= 0;
t = 1;
tt = 2;
ForRMS = 0;
% BlockPassed = 1;
for ro = 1:rowsmax
    for co = 1:columnsmax
        
        BlockDCT  = zeros(8,8);
        BlockDCT =   CompleteDCT ([8*(ro-1)+1:8*ro],[8*(co-1)+1:8*co]) ;


        %******************************************************************
        %         %Quantizing Using Thresholding
        %         BlockDCT(abs(BlockDCT)<Thresh)=0;
        %Quantizing Using Quantization Matrix
        for i = 1:8
            for j = 1:8
        BlockDCT(i,j) = round(BlockDCT(i,j)/Q(i,j));
            end
        end
        %******************************************************************
        %Reading in ZigzagPattern
        Zigzag(n) = BlockDCT(1,1);
        n = n+1;
        for i = 2:2*8-1
                if (i<=8)                                      %Applying ZigZag on the diagnols where the total no. of elements in each diagnol is equal to or less than 16
                    if (rem(i,2)==0)                            %Applying Zigzag on the even numbered diagnols
                        for j = 1:i
                            Zigzag(n) = BlockDCT(j,i-j+1);
                            n = n+1;
                        end
                    else
                        for j = i:-1:1
                            Zigzag(n) = BlockDCT(j,i-j+1);
                            n = n+1;
                        end
                    end
                else
                    k = 2*8-i;                                 %Applying Zigzag on the odd numbered diagnols
                    if (rem(k,2)==0)
                        for j = 1:k
                            Zigzag(n) = BlockDCT(8-k+j,8-j+1);
                            n = n+1;
                        end
                    else
                        for j = k:-1:1
                            Zigzag(n) = BlockDCT(8-(k-j),8-j+1);
                            n = n+1;
                        end
                    end
                end
        end

        
        

        %*****************************************************************
        %Applying RLC (Mine Scheme)
        %*****************************************************************

RLC(t) = 0;
for i = 1+(nn*64):64+(nn*64)
    if (i~=64+(nn*64))
        if(Zigzag(i)== 0)
            nz = nz + 1;
            RLC(t) = 0;
            RLC(tt) = nz;
        elseif (Zigzag(i)~=0)
            if nz ~= 0
                RLC(t+2) = Zigzag(i);
                t = t + 3;
                tt = tt + 3;
                nz = 0;
            elseif nz ==0
                RLC(t) = Zigzag(i);
                t = t + 1;
                tt = tt + 1;
                nz = 0;
            end
        end
    elseif(i==64+(nn*64))
        RLC(t)=0;
        RLC(tt)=0;
        t= t+2;
        tt = tt+2;
        nz = 0;
    end
end
abcdefg = tt-2;
RLC(abcdefg:abcdefg);
nn = nn +1;

end
end
% dlmwrite('my_data1.out',Zigzag', ';')
% ForRMS = sqrt(ForRMS / TotalImageSizeForRawTransmission)            %Can be used to determine the threshold value
x(aToz) = QF;
l(aToz) = length(RLC)*8;
g(aToz) = TotalImageSizeForRawTransmission*8;
toc
time(aToz) = toc;
aToz = aToz + 1;
length(RLC);
end
figure(1)
hold on 
plot(x,l,'-*r')
hold on
plot(x,g,'--g')
legend('Original Run Length Coding Results','Optimized Run Length Coding Results','Uncompressed Image Size')
figure(2)
hold on
plot(x,time,'--k')
legend('Original Run Length Coding Results','Optimized Run Length Coding Results')
