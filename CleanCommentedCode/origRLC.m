function [oRLCoded, txSize] = origRLC(zzOPVec,numOfBlocks,bSize);

%**************************************************************************
%This function implements the original run length coding which encodes the
%zigzag scanned vector in the form (RUNLENGTH, SIZE)(AMPLITUDE), where:
%8 bits are used to encode (RUNLENGTH, SIZE) i.e. 4 bits for each RUNLENGTH and SIZE. 
%x is the non-zero, quantized AC coefficient. 
%RUNLENGTH is the number of zeroes that came before this non-zero AC coefficient. 
%SIZE is the number of bits required to represent x. 
%AMPLITUDE is the bit-representation of x. 
%For ease and comparison purpose we use 6 bits to encode (RUNLENGTH) & 
%8 bits for encoding (AMPLITUDE), ignoring SIZE.
%This would also help in cases where we get longer than 15 consecutive zeros.
%bSize is block size that is by default 64 and for test purpose 8.
%txSize is the number of bits required to transmit the compressed data in bits.
%**************************************************************************

oRLCoded = zeros();

index = 1;

txSize = 0;

for i=1:numOfBlocks
    for j=1:bSize
        if ((i == numOfBlocks) && (j == bSize))
            oRLCoded(index) = 0;
            oRLCoded(index+1) = 0;
            txSize = txSize + 6 + 8;
        else
            switch j
                case 1
                    oRLCoded(index) = zzOPVec(1,(i-1)*bSize+j);
                    index = index + 1;
                    txSize = txSize + 8;
                case 2
                    if zzOPVec(1,(i-1)*bSize+j) == 0;
                        oRLCoded(index) = 1;
                    else
                        amp = zzOPVec(1,(i-1)*bSize+j);
                        oRLCoded(index + 1) = amp;
                        index = index + 2;
                        oRLCoded(index) = 0;
                        txSize = txSize + 6 + 8;
                    end 
                case bSize
                    oRLCoded(index) = 0;
                    oRLCoded(index+1) = 0;
                    index = index + 2;
                    txSize = txSize + 6 + 8;
                otherwise
                    amp = zzOPVec(1,(i-1)*bSize+j);
                    if amp == 0
                        oRLCoded(index) = oRLCoded(index) + 1;
                    else
                        oRLCoded(index + 1) = amp;
                        index = index + 2;
                        oRLCoded(index) = 0;
                        txSize = txSize + 6 + 8;
                    end
            end
        end
    end
end
end
        
                