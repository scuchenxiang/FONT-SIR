function res = reconstruct(X, Y_t, option,parpoolnum)
lambda1 = option.lambda1;
lambda2 = option.lambda2;
lambda3 = option.lambda3;
rho = option.rho;
patchSize = option.patchSize;
stride = option.stride;
sysmat = option.sysmat;
groupNum = option.groupNum;
searchWin = option.searchWin;
Iteration = option.iter;
zeta=option.zeta;
bicgnum=option.bicgnum;
[N1,N2,N3] = size(X);

patchWin = [N1+1-patchSize, N2+1-patchSize];
index = reshape(1:patchWin(1)*patchWin(2), patchWin);
row = 1:stride:patchWin(1);
col = 1:stride:patchWin(2);

if row(end)<patchWin(1)
    row = [row patchWin(1)];
end
if col(end)<patchWin(2)
    col = [col patchWin(2)];
end

patchNum = length(row)*length(col);
curMat = index(row,col);
curMat = curMat(:);

X_t = zeros(N1,N2,N3);%init_data;
V_t = zeros(patchSize,patchSize, groupNum, N3, patchNum);
L_t = zeros(patchSize,patchSize, groupNum, N3, patchNum);
S_t = zeros(patchSize,patchSize, groupNum, N3, patchNum);
I = 1e6*exp(-Y_t);
error = zeros(N3, Iteration);
psnr = zeros(N3,Iteration);
sim = zeros(N3,Iteration);
rmse = zeros(N3,Iteration);
compareSpect=option.compareSpect;
ATy = zeros(N1,N2,N3);
if parpoolnum~=0
parfor i = 1:N3
    ATy(:,:,i) = bProjGen(Y_t(:,:,i).*I(:,:,i),sysmat,[N1,N2]);
    temp1 = reshape(ATy(:,:,i),[N1*N2,1]);
    [temp,~,~,~] = bicgstab(@(x)(Afun0(x, sysmat, [N1, N2],I(:,:,i))),temp1,[],[]);
    X_t(:,:,i) = reshape(temp,[N1,N2]);
end
patchSet = patchEX(X_t, patchSize);
groupMat = getGM(patchSet, index, curMat, searchWin, groupNum, compareSpect);
groupCoefMat = getGroupCoef(index, patchSize, groupMat);

for i = 1:Iteration
    tic
    patchSet = patchEX(X_t, patchSize);
    V_t = GR(patchSet, groupMat);   
    parfor j = 1:patchNum
        L_t(:,:,:,:,j) = TensorNuclear(V_t(:,:,:,:,j)-S_t(:,:,:,:,j), 2*lambda2/rho,groupNum);
        temp1 = reshape(V_t(:,:,:,:,j)-L_t(:,:,:,:,j),[patchSize,patchSize, groupNum, N3]);
        temp2 =zeros(patchSize,patchSize, groupNum, N3);
        for k = 1:groupNum
            Mattmp=reshape(temp1(:,:,k,:),[patchSize,patchSize,N3]);
            temp2(:,:,k,:)=chambolleAlgorithm3(Mattmp, lambda3/rho, zeta, 20);
        end
        
        S_t(:,:,:,:,j) = temp2;
    end    
    imgTemp = patchReturn(L_t+S_t, [N1,N2,N3], groupMat);
    parfor j = 1:N3
        imgTemp2 = lambda1.* ATy(:,:,j) + rho.*imgTemp(:,:,j);  
        imgTemp2 = imgTemp2(:);
        [temp,~,~,~]=bicgstab(@(x)(Afun(x, sysmat, [N1, N2], groupCoefMat,lambda1,rho,I(:,:,j))),...
                     imgTemp2,[],bicgnum,[],[],reshape(X_t(:,:,j),[N1*N2,1]));
        X_t(:,:,j) = reshape(temp, [N1, N2]);
    end 
    for j =1:N3
        error(j,i) = norm(X(:,:,j)-X_t(:,:,j));
        sim(j,i) = ssim(X(:,:,j),X_t(:,:,j));
    end    
    mse = mean(reshape((X-X_t).^2, [N1*N2,N3]));
    rmse(:,i) = sqrt(mse);
    psnr(:,i)= 10 * log10(1./mse);
    disp([num2str(i), 'th    Iteration']);
    disp(['error(multi-energy):      ', num2str(error(:,i)', '%10.2e')]);    
    disp(['PSNR(multi-energy):      ', num2str(psnr(:,i)', '%10.2f')]);
    disp(['RMSE(multi-energy):      ', num2str(rmse(:,i)', '%10.4f')]);
    disp(['SSIM(multi-energy):      ', num2str(sim(:,i)', '%10.4f')]);
    toc
end
else
for i = 1:N3
    ATy(:,:,i) = bProjGen(Y_t(:,:,i).*I(:,:,i),sysmat,[N1,N2]);
     temp1 = reshape(ATy(:,:,i),[N1*N2,1]);
     [temp,~,~,~] = bicgstab(@(x)(Afun0(x, sysmat, [N1, N2],I(:,:,i))),temp1,[],[]);
     X_t(:,:,i) = reshape(temp,[N1,N2]);
end
patchSet = patchEX(X_t, patchSize);
groupMat = getGM(patchSet, index, curMat, searchWin, groupNum, 1);
groupCoefMat = getGroupCoef(index, patchSize, groupMat);

for i = 1:Iteration
    tic
    patchSet = patchEX(X_t, patchSize);   
    V_t = GR(patchSet, groupMat);    
    for j = 1:patchNum
        L_t(:,:,:,:,j) = TensorNuclear(V_t(:,:,:,:,j)-S_t(:,:,:,:,j), 2*lambda2/rho,groupNum);
        temp1 = reshape(V_t(:,:,:,:,j)-L_t(:,:,:,:,j),[patchSize,patchSize, groupNum, N3]);
        temp2 =zeros(patchSize,patchSize, groupNum, N3);
        for k = 1:groupNum        
            Mattmp=reshape(temp1(:,:,k,:),[patchSize,patchSize,N3]);
            temp2(:,:,k,:)=chambolleAlgorithm3(Mattmp, lambda3/rho, zeta, 20);
        end
        S_t(:,:,:,:,j) = temp2;
    end    
    imgTemp = patchReturn(L_t+S_t, [N1,N2,N3], groupMat);    
    for j = 1:N3
        imgTemp2 =lambda1.*ATy(:,:,j) + rho.*imgTemp(:,:,j);      %
        imgTemp2 = imgTemp2(:);
        [temp,~,~,~]=bicgstab(@(x)(Afun(x, sysmat, [N1, N2], groupCoefMat,lambda1,rho,I(:,:,j))),...
                     imgTemp2,[],bicgnum,[],[],reshape(X_t(:,:,j),[N1*N2,1]));
        X_t(:,:,j) = reshape(temp, [N1, N2]);
    end 
    for j =1:N3
        error(j,i) = norm(X(:,:,j)-X_t(:,:,j));
        sim(j,i) = ssim(X(:,:,j),X_t(:,:,j));
    end
    mse = mean(reshape((X-X_t).^2, [N1*N2,N3]));
    rmse(:,i) = sqrt(mse);
    psnr(:,i)= 10 * log10(1./mse);
    disp([num2str(i), 'th    Iteration']);
    disp(['error(multi-energy):      ', num2str(error(:,i)', '%10.2e')]);    
    disp(['PSNR(multi-energy):      ', num2str(psnr(:,i)', '%10.4f')]);
    disp(['RMSE(multi-energy):      ', num2str(rmse(:,i)', '%10.4f')]);
    disp(['SSIM(multi-energy):      ', num2str(sim(:,i)', '%10.4f')]);
    toc
end
end
res = X_t;
dirname = strcat('result1/lambda_',num2str(zeta),'_',num2str(bicgnum),'_',num2str(lambda1),'_',num2str(lambda2),'_',num2str(lambda3),'_rho_',num2str(rho),...
   '_patch_',num2str(patchSize),'_',num2str(stride),'_win_',num2str(groupNum),'_',num2str(searchWin),'_',num2str(compareSpect));
mkdir(dirname);    
fileName = strcat(dirname,'/','ReconData.mat');    
save(fileName,'X_t','error','rmse','psnr','sim');
end

function p =Afun0(x,sysmat,sz,I)
temp = reshape(x,sz);
p = PoissProjGen(temp,sysmat,I);
p = p(:);
end

function p = Afun(x,sysmat,sz,coef,lambda,rho,I)
temp = reshape(x,sz);
temp1 = lambda*PoissProjGen(temp,sysmat,I);
temp2 = rho*coef.*temp;
p = reshape(temp1+temp2,[sz(1)*sz(2),1]);
end
