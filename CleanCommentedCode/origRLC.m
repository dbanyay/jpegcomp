function oRLCoded = origRLC(zzOPVec,numOfBlocks);

%**************************************************************************
%This function implements the original run length coding which encodes the
%zigzag scanned vector in the form (RUNLENGTH, SIZE)(AMPLITUDE), where:
%8 bits are used to encode (RUNLENGTH, SIZE) i.e. 4 bits for each RUNLENGTH and SIZE. 
%x is the non-zero, quantized AC coefficient. 
%RUNLENGTH is the number of zeroes that came before this non-zero AC coefficient. 
%SIZE is the number of bits required to represent x. 
%AMPLITUDE is the bit-representation of x. 
%For ease and comparison purpose we use 8 bits to encode (RUNLENGTH) & (AMPLITUDE) each ignoring SIZE.
%This would also help in cases where we get longer than 15 consecutive zeros.
%**************************************************************************

oRLCoded = zeros();

index = 1;

for i=1:numOfBlocks
    for j=1:8
        if index == numOfBlocks*8
            oRLCoded(index) = 0;
            oRLCoded(index+1) = 0;
        else
            switch j
                case 1
                    oRLCoded(index) = zzOPVec(1,(i-1)*8+j);
                    index = index + 1;
                case 2
                    if zzOPVec(1,(i-1)*8+j) == 0;
                        oRLCoded(index) = 1;
                    else
                        amp = zzOPVec(1,(i-1)*8+j);
                        oRLCoded(index + 1) = amp;
                        index = index + 2;
                        oRLCoded(index) = 0;
                    end 
                case 8
                    oRLCoded(index) = 0;
                    oRLCoded(index+1) = 0;
                    index = index + 2;

                otherwise
                    amp = zzOPVec(1,(i-1)*8+j);
                    if amp == 0
                        index
                        oRLCoded(index) = oRLCoded(index) + 1;
                    else
                        oRLCoded(index + 1) = amp;
                        index = index + 2;
                        oRLCoded(index) = 0;
                    end
            end
        end
        oRLCoded
    end
end
end
        
                