function img = patchReturn(patch, N, groupMat)
M = size(patch);
patchSize = M(1);
img = zeros(N);
patchWin = [N(1)-patchSize+1, N(2)-patchSize+1, N(3)];
temp = zeros(M(1),M(2), patchWin(1)*patchWin(2), N(3));
for i = 1:M(5)
    temp(:,:,(groupMat(:,2,i)-1)*patchWin(1)+(groupMat(:,1,i)),:) = temp(:,:,(groupMat(:,2,i)-1)*patchWin(1)+(groupMat(:,1,i)),:) + patch(:,:,:,:,i);
end


for i = 1:patchSize
    for j = 1:patchSize
        img(j:j+patchWin(1)-1, i:i+patchWin(2)-1,:) = img(j:j+patchWin(1)-1, i:i+patchWin(2)-1,:)+ reshape(temp(j,i,:,:), patchWin);
    end
end


end