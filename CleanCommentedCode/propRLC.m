function [pRLCoded, txSize] = propRLC(zzOPVec,numOfBlocks,bSize);

%**************************************************************************
%This function implements the optimized run length coding which encodes the
%zigzag scanned vector in the form (0,RUNLENGTH)(AMPLITUDE) only if a non zero integer in the block is preceded by a zero, where:
%x is the non-zero, quantized AC coefficient. 
%RUNLENGTH is the number of zeroes that came before this non-zero AC coefficient. 
%0 is a flag variable, that is transmitted onlyif zeros precede AC coefficient. 
%AMPLITUDE is the bit-representation of x. 
%For ease and comparison purpose we use 6 bits to encode (RUNLENGTH), 
%as the maximum number of consecutive zeros can be 63 (for 8 x 8 blocks) & 
%8 bits for encoding (AMPLITUDE) & the flag variable (0).
%bSize is block size that is by default 64 and for test purpose 8.
%txSize is the number of bits required to transmit the compressed data in bits.
%**************************************************************************

pRLCoded = zeros();

index = 1;

txSize = 0;

for i=1:numOfBlocks
    for j=1:bSize
        if ((i == numOfBlocks) && (j == bSize))
            if zzOPVec(1,(i-1)*bSize+j-1) == 0
                pRLCoded(index-1) = 0;
                txSize = txSize + 6 + 8;
            else
                pRLCoded(index) = 0;
                pRLCoded(index+1) = 0;
                txSize = txSize + 6 + 8;
            end
        else
            switch j
                case 1
                    pRLCoded(index) = zzOPVec(1,(i-1)*bSize+j);
                    index = index + 1;
                    txSize = txSize + 8;
                case 2
                    if zzOPVec(1,(i-1)*bSize+j) == 0
                        pRLCoded(index) = 0;
                        pRLCoded(index + 1) = 1;
                        index = index + 2;
                    else
                        amp = zzOPVec(1,(i-1)*bSize+j);
                        pRLCoded(index) = amp;
                        index = index + 1;
                        txSize = txSize + 8;
                    end 
                case bSize
                    if zzOPVec(1,(i-1)*bSize+j-1) == 0
                        pRLCoded(index-1) = 0;
                        txSize = txSize + 6 + 8;
                    else
                        pRLCoded(index) = 0;
                        pRLCoded(index+1) = 0;
                        index = index + 2;
                        txSize = txSize + 6 + 8;
                    end
                otherwise
                    prevAmp = zzOPVec(1,(i-1)*bSize+j-1);
                    amp = zzOPVec(1,(i-1)*bSize+j);
                    if amp == 0
                        if prevAmp == 0
                            pRLCoded(index-1) = pRLCoded(index-1) + 1;
                        else
                            pRLCoded(index) = 0;
                            pRLCoded(index+1) = 1;
                            index = index + 2;
                        end
                    else
                        if prevAmp == 0
                            pRLCoded(index) = amp;
                            index = index + 1;
                            txSize = txSize + 6 + 8 + 8;
                        else
                            pRLCoded(index) = amp;
                            index = index + 1;
                            txSize = txSize + 8;
                        end
                    end
            end
        end
    end
end
end
        
                