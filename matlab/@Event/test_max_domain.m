function [ X Y Z ] = test_max_domain(obj, n)
%TEST_MAX_DOMAIN Summary of this function goes here
%   Detailed explanation goes here
obj = obj.set_domain(n,n,n,n);

[X Y Z] = obj.inverse_signal();

end

