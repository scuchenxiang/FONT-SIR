function groupMat = getGM(patchSet, index, curMat, searchWin, groupNum, comBin)
N = size(patchSet);
M = size(index);
[m, n] = size(curMat);
WinSize = size(index);
groupMat = zeros(groupNum,2,m*n);

for i = 1:(m*n)
    cur = curMat(i); 
    curCol = ceil(cur/M(1));
    curRow = cur - M(1)*(curCol-1);
    rmin = max(1, curRow-searchWin);
    rmax = min(WinSize(1), curRow+searchWin);
    cmin = max(1, curCol-searchWin);
    cmax = min(WinSize(2), curCol+searchWin);
    winIndex = index(rmin:rmax,cmin:cmax);
    winIndex = winIndex(:);
    t = randperm(length(winIndex));
    winIndex = winIndex(t);
    IndexSize=size(winIndex);
    pca_distance=zeros(IndexSize(1),1);
    [coeff_me, score_me, latent_me ]=pca(patchSet(:,:,cur,comBin));
    parfor j=1:IndexSize(1)
        [coeff, ~, ~ ]=pca(patchSet(:,:,j,comBin));
        pca_distance(j,1)=-dot(coeff_me(1),coeff(1))/(norm(coeff_me(1))*norm(coeff(1)));
    end
    [~, picIndex] = sort(pca_distance(:));
    res = winIndex(picIndex(1:groupNum)); 
    res(1)=cur;
    cols=ceil(res/M(1));
    rows=res - M(1)*(cols-1);
    groupMat(:,1,i) = rows;
    groupMat(:,2,i) = cols; 
end
end





