% Two pulse canceller.
% H(z) = 1- z^-1

z = tf([1 0],1,44.1e3^-1);
Filter = 1-z^-1;