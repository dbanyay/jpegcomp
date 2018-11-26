function [toBiZZOrig] = invOrigRLC(oRLCoded,bSize)

%**************************************************************************
%This function does the inverse of Original Run length encoded data in
%oRLCoded with block size defined by bSize and returns the input to inverse
%Zig Zag Sanning as toBiZZOrig
%**************************************************************************

toBiZZOrig = zeros();

numElOriRLC = numel(oRLCoded);

indRLC = 1;
indZZS = 1;

while indRLC < numElOriRLC
    
    counter = 1;
    toBiZZOrig(indZZS) = oRLCoded(indRLC);
    indRLC = indRLC + 1;
    indZZS = indZZS + 1;
        
    while (counter <= bSize)
        switch (oRLCoded(indRLC))
            case 0
                if(oRLCoded (indRLC + 1) ~= 0)
%                     disp('Case I')
                    toBiZZOrig (indZZS) = oRLCoded (indRLC + 1);
                    counter = counter + 1;
                    indZZS = indZZS + 1;
                    indRLC = indRLC + 2;
                elseif (oRLCoded (indRLC + 1) == 0)
%                     disp('Case II')
                    toBiZZOrig (indZZS:(indZZS+(bSize-counter)-1)) = zeros ();
                    indRLC = indRLC + 2;
                    indZZS = indZZS + (bSize - counter);
                    counter = bSize + 1;
                end
            otherwise
%                 disp('Case III')
                toBiZZOrig (indZZS:(indZZS+oRLCoded(indRLC)-1)) = zeros ();
                indZZS = indZZS + oRLCoded(indRLC);
                toBiZZOrig (indZZS) = oRLCoded(indRLC+1);
                indZZS = indZZS + 1;
                counter = counter + oRLCoded(indRLC) + 1;
                indRLC = indRLC + 2;
        end
    end
end
end