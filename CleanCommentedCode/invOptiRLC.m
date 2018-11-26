function [toBiZZOpti] = invOptiRLC(pRLCoded,bSize)

%**************************************************************************
%This function does the inverse of Optimized Run length encoded data in
%pRLCoded with block size defined by bSize and returns the input to inverse
%Zig Zag Sanning as toBiZZOpti
%**************************************************************************

toBiZZOrig = zeros();

numElOptRLC = numel(pRLCoded);

indRLC = 1;
indZZS = 1;

while indRLC < numElOptRLC
    counter = 1;
    toBiZZOpti(indZZS) = pRLCoded(indRLC);
    indRLC = indRLC + 1;
    indZZS = indZZS + 1;
    
    while counter < bSize
        switch pRLCoded(indRLC)
            case 0
                switch pRLCoded(indRLC + 1)
                    case 0
%                         counter
%                         indZZS
%                         indZZS:indZZS+bSize-counter-1
%                         disp('Case III');
                        toBiZZOpti(indZZS:indZZS + bSize - counter - 1) = zeros();
                        indZZS = indZZS + bSize - counter;
                        indRLC = indRLC + 2;
                        counter = bSize;
                    otherwise
%                         disp('Case II');
                        toBiZZOpti(indZZS:indZZS+pRLCoded(indRLC + 1)-1) = zeros();
                        indZZS = indZZS + pRLCoded(indRLC + 1);
                        counter = counter + pRLCoded(indRLC + 1);
                        indRLC = indRLC + 2;
                end
            otherwise
%                 disp('Case I');
                toBiZZOpti(indZZS) = pRLCoded(indRLC);
                indRLC = indRLC + 1;
                indZZS = indZZS + 1;
                counter = counter + 1;
        end
    end
end

end