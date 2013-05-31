% Bilateral filter service script
% Script filters input image with reference algorithm and save the
% result for futher use
%
% Dan Stefanov, 2013

% input data
in_image = imread ('in.bmp');

% setup sigma
sigma.d = 40;
sigma.r = 40;
radius = 100;

% filltering
ref_image = bf_ref (in_image, sigma, radius);

% writing result
imwrite (ref_image, 'ref.bmp');