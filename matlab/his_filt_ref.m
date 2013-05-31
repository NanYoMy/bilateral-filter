% Bilateral filter
% Unoptimized historgram filtration algorithm
%
% Dan Stefanov, 2013

function [his_filt_im] = his_filt_ref (his_im, dim, sigma, r)
    his_filt_im = zeros (size(his_im));
    for his = 1:size(his_im,1)
        his_filt_im (his,:,:) = filt_im (squeeze(his_im(his,:,:)), dim, sigma,r);
    end
end

function [filt_im] = filt_im (in_im, dim, sigma,r)
    v_filt = filt_im_v (in_im, dim, sigma, r);
    filt_im = filt_im_v (v_filt', dim, sigma, r)';
end
 
function [filt_im] = filt_im_v (in_im, dim, sigma,r)
    mask = comp_mask (sigma,r);
    line_im = reshape (in_im,1,size(in_im,1)*size(in_im,2));
    line_filt_im = conv (line_im, mask,'same');
    filt_im = reshape (line_filt_im, size(in_im));
end

function [mask] = comp_mask (sigma,r)
    line = (-r):r;
    mask = exp(-0.5*(line/sigma).^2);
end

