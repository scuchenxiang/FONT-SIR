function p = GetTPr_SM(I,SM,theta,pSize)


 ND=size(SM.lsect{1},2);
 p=zeros(pSize);

 for t=1:length(theta)
     for k=1:ND
         if ~isempty(SM.isect{t}{k})
             p(SM.isect{t}{k})=p(SM.isect{t}{k}) + SM.lsect{t}{k}*I(t,k);
         end;
     end
 end

