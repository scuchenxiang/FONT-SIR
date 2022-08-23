function pj=GetPr_SM(I,SM,theta)


 ND=size(SM.lsect{1},2);%num of detector
 pj=zeros(length(theta),ND);

 for t=1:length(theta)
     
 %    if mod(t,10)==0 disp(strcat('angle:',num2str(t))); end;    by Liang
 
     for k=1:ND
         if ~isempty(SM.isect{t}{k})
             pj(t,k)=sum(I(SM.isect{t}{k}).*SM.lsect{t}{k});
         end;
     end
 end
 %imagesc(pj);
