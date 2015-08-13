function [ dist ] = getPixelDist( pixel1,pixel2 )
%GETPIXELDIST Summary of this function goes here
%   Detailed explanation goes here

dist = norm(pixel1-pixel2);

end

