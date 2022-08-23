function out = w_nuclearOptimal(in, tau,groupNum)
verymin=1e-16;
C=sqrt(2*groupNum);
[U, S, V] = svd(in, 'econ');
index = find(S>0);
c2=power((S(index)+verymin),2)-4*C*tau;
c1=S(index)-verymin;
sizec=size(c1);
tmp=zeros(size(c1));
for i=1:sizec(1)
    if c2(i)>=0
        tmp(i)=(c1(i)+sqrt(c2(i)))/2;
    else
        tmp(i)=0;
    end
end

S(index) =tmp;
out = U*S*V';

end