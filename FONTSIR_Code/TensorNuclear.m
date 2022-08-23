function out = TensorNuclear(in, tau,groupNum)%v-s in 
N = size(in);
[in1, in2, in3,in4] = unfold(in);
out = (fold1(w_nuclearOptimal(in1,tau,groupNum),N) + fold2(w_nuclearOptimal(in2,tau,groupNum),N)+fold3(w_nuclearOptimal(in3,tau,groupNum),N)+fold4(w_nuclearOptimal(in4,tau,groupNum),N))/4;
end

function y = fold1(X, N)
y = zeros(N);
for i = 1:N(2)
    for j = 1:N(3)
        for k=1:N(4)
            y(:,i,j,k) = X(:,((k-1)*N(3)*N(2)+(j-1)*N(2)+i));%
        end
    end
end
end

function y = fold2(X,N)
    y = zeros(N);
    for i = 1:N(1)
        for j = 1:N(3)
           for k=1:N(4)
                y(i,:,j,k) = X(:,((k-1)*N(3)*N(1)+(j-1)*N(1)+i));%
            end
            
        end
    end
end

function y = fold3(X,N)
    y = zeros(N);
    for i = 1:N(1)
        for j = 1:N(2)
            for k=1:N(4)
                y(i,j,:,k) = X(:,((k-1)*N(2)*N(1)+(j-1)*N(1)+i));%
            end
        end
    end
end

function y = fold4(X,N)
    y = zeros(N);
    for i = 1:N(1)
        for j = 1:N(2)
            for k=1:N(3)
                y(i,j,k,:) = X(:,((k-1)*N(2)*N(1)+(j-1)*N(1)+i));%
            end
        end
    end
end

function [ Y1, Y2, Y3,Y4 ] = unfold( Y_t )
%UNFOLD Summary of this function goes here
%   Turn tensor Y to matrix Y1, Y2, Y3 as the unfold rules.

Ysiz = size(Y_t);
Y1 = zeros(Ysiz(1), Ysiz(2) *Ysiz(3)*Ysiz(4));
Y2 = zeros(Ysiz(2), Ysiz(1) *Ysiz(3)*Ysiz(4));
Y3 = zeros(Ysiz(3), Ysiz(2) *Ysiz(1)*Ysiz(4));
Y4 = zeros(Ysiz(4), Ysiz(2) *Ysiz(1)*Ysiz(3));
for i = 1:Ysiz(2)
    for j = 1:Ysiz(3)
        for k=1:Ysiz(4)
            Y1(:, (Ysiz(2)*(k-1)*Ysiz(3)+(j-1)*Ysiz(3) + i)) = Y_t(:, i,j,k);
        end
    end
end

for i = 1:Ysiz(1)
    for j = 1:Ysiz(3)
        for k=1:Ysiz(4)
            Y2(:, (Ysiz(3)*(k-1)*Ysiz(1)+(j-1)*Ysiz(1) + i)) = Y_t(i,:,j,k);
        end
    end
end

for i = 1:Ysiz(1)
    for j = 1:Ysiz(2)
        for k=1:Ysiz(4)
            Y3(:, (Ysiz(2)*(k-1)*Ysiz(1)+(j-1)*Ysiz(1) + i)) = Y_t(i,j,:,k);
        end
    end
end

for i = 1:Ysiz(1)
    for j = 1:Ysiz(2)
        for k=1:Ysiz(3)
            Y4(:, (Ysiz(2)*(k-1)*Ysiz(1)+(j-1)*Ysiz(1) + i)) = Y_t(i,j,k,:);
        end
    end
end
end