function blocks = revZigZag(zzOPVec,numOfBlocks)
%reverse ZigZag algorithm

blocks = zeros(8,8,numOfBlocks);

indexes = [1 2 9 17 10 3 4 11 18 25 33 26 19 12 5 6 ...
    13 20 27 34 41 49 42 35 28 21 14 7 8 15 22 29 36 ...
    43 50 57 58 51 44 37 30 23 16 24 31 38 45 52 59 60 ...
    53 46 39 32 40 47 54 61 62 55 48 56 63 64];

for i = 0:numOfBlocks-1    
    blockvect = zeros(1,64);
    for j = 1:64
        blockvect(indexes(j)) = zzOPVec(i*64+j);     
    end
    blocks(:,:,i+1) = reshape(blockvect,[8 8])';     
end

end

