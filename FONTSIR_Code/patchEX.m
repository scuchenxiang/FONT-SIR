function patchSet = patchEX(I, patchSize)
N = size(I);
patchWin = [N(1)-patchSize+1, N(2)-patchSize+1];
patchSet=zeros(patchSize,patchSize,patchWin(1)*patchWin(2),N(3));

for i=1:patchSize
    for j=1:patchSize
        patchSet(j,i,:,:)=reshape(I(j:j+patchWin(1)-1,i:i+patchWin(2)-1,:),[1,1,patchWin(1)*patchWin(2),N(3)]);%matlab¡–”≈œ»
    end
end
end