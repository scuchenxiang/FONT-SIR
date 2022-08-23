function groupPatch = GR(patchSet, groupMat)
N = size(patchSet);
[m,~,n] = size(groupMat);
groupPatch = zeros(N(1),N(2), m, N(4), n);
for i = 1:n    
    groupPatch(:,:,:,:,i) = patchSet(:,:,(groupMat(:,2,i)-1)*sqrt(N(3))+(groupMat(:,1,i)),:);    
end
end