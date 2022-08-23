function res = chambolleAlgorithm3(in, alpha, step, iter)
N = size(in);
px = zeros(N);
py = zeros(N);
pz=zeros(N);
for i = 1:iter
    temp = div(px, py,pz)-in/alpha;
    dx = gradx(temp);
    dy = grady(temp);
    dz=gradz(temp);
    tv = sqrt(dx.^2+dy.^2+dz.^2);
    px = (px+step*dx)./(1+step*tv);
    py = (py+step*dy)./(1+step*tv);
    pz=(pz+step*dz)./(1+step*tv);
    
end
res = in-alpha*div(px, py,pz);
end

function res = gradx(in)
[m,~,~,~] = size(in);
res = in([2:m m],:,:,:)-in;
end

function res = grady(in)
[~,n,~,~] = size(in);
res = in(:,[2:n n],:,:)-in;
end

function res=gradz(in)
[~,~,t,~] = size(in);
res = in(:,:,[2:t t],:)-in;
end
function res = div(inx, iny,inz)
[m,n,t] = size(inx);
dx = inx - inx([1 1:m-1],:,:);
dx(1,:,:) = inx(1,:,:);
dx(m,:,:) = -inx(m-1,:,:);
dy = iny - iny(:,[1 1:n-1],:);
dy(:,1,:) = iny(:,1,:);
dy(:,n,:) = -iny(:,n-1,:);
dz = inz - inz(:,:,[1 1:t-1]);
dz(:,:,1) = inz(:,:,1);
dz(:,:,t) = -inz(:,:,t-1);
res = dx+dy+dz;
end