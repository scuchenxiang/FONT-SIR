clear;
clc;
% The size of data need to be [Nrow, Ncol, Nchannel]
load IMGData;
oringImg =X;
[option,params]=initialParams();
parpoolnum =2;
Xsz = size(oringImg);
sysmat = GetSysMat(option);
params.sysmat = sysmat;
load projData;


delete(gcp('nocreate'));
parpool(parpoolnum);

reconImg = reconstruct(oringImg, projData, params,parpoolnum);

delete(gcp('nocreate'));
