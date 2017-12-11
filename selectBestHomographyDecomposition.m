function [ R, T, N ] = selectBestHomographyDecomposition( Ra, Ta, Na, Rb, Tb, Nb, X1, X2 )
%UNTITLED20 Summary of this function goes here
%   Detailed explanation goes here
a_score1 = Na.' * X1.';
a_score2 = (Ra*Na).' * X2.';
a_score1 = sum(sign(a_score1)) / size(a_score1,2);
a_score2 = sum(sign(a_score2)) / size(a_score2,2);
a_score = (a_score1 + a_score2)/2;
fprintf('Score of solution A = %.2f%%,%.2f%% => %.2f%%\n', 100*a_score1, 100*a_score2, 100*a_score);

b_score1 = Nb.' * X1.';
b_score2 = (Rb*Nb).' * X2.';
b_score1 = sum(sign(b_score1)) / size(b_score1,2);
b_score2 = sum(sign(b_score2)) / size(b_score2,2);
b_score = (b_score1 + b_score2)/2;
fprintf('Score of solution B = %.2f%%,%.2f%% => %.2f%%\n', 100*b_score1, 100*b_score2, 100*b_score);

if a_score >= b_score
    R = Ra; T = Ta; N = Na;
else
    R = Rb; T = Tb; N = Nb;
end

end

