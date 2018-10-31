clear
warning off all
clc
aToz = 1;

S = double(imread('lena512.bmp'));
SS = size(S);

%To convert rgb to gray use --> if numel(SS) > 2

%Normalizing the values of the image around zero
S = S - 128;


%Making blocks of 8x8 pixels and taking dct of those 8x8 blocks

SS(1) = SS(1) - rem(SS(1),8);
SS(2) = SS(2) - rem(SS(2),8);

TotalImageSizeForRawTransmission = SS(1)*SS(2);

rowsmax = (SS(1)/8);
columnsmax = (SS(2)/8);

MatrixForEbyE = zeros(8,8);
BlockDCT  = zeros(8,8);             %Temporary storage of dct coefficients

for ro = 1:rowsmax
    for co = 1:columnsmax
      MatrixForEbyE = S([8*(ro-1)+1:8*ro],[8*(co-1)+1:8*co]);
      BlockDCT = dct2(MatrixForEbyE);
      CompleteDCT ([8*(ro-1)+1:8*ro],[8*(co-1)+1:8*co]) = BlockDCT;
    end
end

CompleteDCT;                        %Final DCT Coefficients


for QF = [0:0.2:2,3:1:10]
tic
QF;
    clear RLC

%Defining Quantization Matrix
for i = 1:8
    for j = 1:8
        Q(i,j) = 1+((i+j-1)*QF);
    end
end

n = 1;
nn = 0;
nz= 0;
t = 1;
tt = 2;
ForRMS = 0;

for ro = 1:rowsmax
    for co = 1:columnsmax
        
        BlockDCT = CompleteDCT ([8*(ro-1)+1:8*ro],[8*(co-1)+1:8*co]) ;
        
        for i = 1:8
            for j = 1:8
                BlockDCT(i,j) = round(BlockDCT(i,j)/Q(i,j));
            end
        end

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

RLC(t) = Zigzag(1);
t=2;
tt=3;

for i = 1+(nn*64):64+(nn*64)
    if (i~=64+(nn*64))
        if(i~=1)
            if(Zigzag(i)== 0)
            nz = nz + 1;
            RLC(t) = nz;
            elseif (Zigzag(i)~=0)
                RLC(tt) = Zigzag(i);
                t = t + 2;
                tt = tt + 2;
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
nn = nn +1;
end
end
QF;
RLC;
if (QF == 2)
    break
end


x(aToz) = QF;
l(aToz) = length(RLC);
length(RLC);
toc
time(aToz) = toc;
aToz = aToz + 1;
end

figure(1)
hold on
plot(x,l,'-^')
xlabel('Quality Factor')
ylabel('Image Data Size in Bytes')
figure(2)
hold on
plot(x,time,'-k')
figure(2)
xlabel('Quality Factor')
ylabel('Time Taken for Compression in Seconds')