function coefMat = getCoef(index, row, col, patchSize)
patchWin = size(index);
coefMat = zeros(patchWin(1)+patchSize-1,patchWin(2)+patchSize-1);
mask = ones(patchSize);
for i = 1:length(row)
    for j = 1:length(col)
        rowIn = row(i);
        colIn = col(j);
        coefMat(rowIn:rowIn+patchSize-1,colIn:colIn+patchSize-1) = coefMat(rowIn:rowIn+patchSize-1,colIn:colIn+patchSize-1)+mask;
    end
end

end