function [ Ra, Ta, Rb, Tb, Na, Nb ] = decomposeHomographyMatrix( H, X1, X2 )
%UNTITLED19 Summary of this function goes here
%   Detailed explanation goes here
[~,S,V] = svd(H.' * H);

V = V * sign(det(V));
v1 = V(:,1); v2 = V(:,2); v3=V(:,3);

sqrt3 = sqrt(1-S(3,3));
sqrt1 = sqrt(S(1,1)-1);
sqrt13 = sqrt(S(1,1)-S(3,3));
u1 = (sqrt3*v1+sqrt1*v3) / sqrt13;
u2 = (sqrt3*v1-sqrt1*v3) / sqrt13;

U1 = [v2 u1 skew(v2)*u1];
U2 = [v2 u2 skew(v2)*u2];
W1 = [H*v2 H*u1 skew(H*v2)*H*u1];
W2 = [H*v2 H*u2 skew(H*v2)*H*u2];

% solution 1
R1 = W1 * U1.';
N1 = skew(v2)*u1;
T1 = (H-R1)*N1;

% solution 2
R2 = W2 * U2.';
N2 = skew(v2)*u2;
T2 = (H-R2)*N2;

% solution 3
R3 = R1;
N3 = -N1;
T3 = -T1;

% solution 4
R4 = R2;
N4 = -N2;
T4 = -T2;

if N1(3) > 0
    Na = N1;
    Ra = R1;
    Ta = T1;
else
    Na = N3;
    Ra = R3;
    Ta = T3;
end

if N2(3) > 0
    Nb = N2;
    Rb = R2;
    Tb = T2;
else
    Nb = N4;
    Rb = R4;
    Tb = T4;
end
end

