% Bilateral filter
% Straight forward realization
%
% Dan Stefanov, 2013

% implemets staight forward algorithm 
function [filtered_image_fxp] = bf_ref (input_image_fxp, sigma, r)
    input_image = double (input_image_fxp);
    [extended_image, od] = extend_image (input_image, r);
    filter_mask = comp_filter_mask (sigma.d,r);
    filtered_image = zeros (size(extended_image));
     
    for x = od.a(2):od.b(2)
        for y = od.a(1):od.b(1)
            filtered_image(y,x) = ...
               filter_point(extended_image,[y x],sigma.r,filter_mask,r);
        end
    end

    filtered_image_crop = filtered_image(od.a(1):od.b(1),od.a(2):od.b(2));
    filtered_image_fxp = uint8(filtered_image_crop);            
end

% exteds image borders with flipt copy to radius pixes
function [res_im, orig_dim] = extend_image (in_im, radius)
    im_size = size (in_im);
    ext_h = extend_image_h (in_im, radius);
    ext_v = extend_image_h (ext_h', radius)';
    res_im = ext_v;
    orig_dim.a = [1 1] + radius;
    orig_dim.b = im_size + radius;
end

function [res_im] = extend_image_h (in_im, radius)
    ext_left = in_im (:,1:radius);
    ext_right = in_im (:,(end+1-radius):end);
    res_im = [fliplr(ext_left),in_im,fliplr(ext_right)];
end

% creates gaus mask
function [mask] = comp_filter_mask (sigma,r)
    line = -r:r;
    line_mask = exp (-(line / sigma).^2);
    mask = line_mask' * line_mask;
end

% computes single point
function [value] =  filter_point(in_im,p0,sigma,mask,radius)
    f_p0 = in_im (p0(1),p0(2));
    window = crop_radius (in_im,p0,radius);
    window_gaus = comp_gaus (window, f_p0, sigma);
    window_mask = window_gaus .* mask;
    value_h = sum(sum(window_mask .* window));
    value_k = sum(sum(window_mask));
    value = value_h / value_k;
end

% crop a squere window
function [crop_image] = crop_radius (in_im,p0,radius)
    side = (-radius):radius;
    crop_image = in_im (p0(1)+side,p0(2)+side);
end


function [gaus_im] = comp_gaus (window, f_p0, sigma)
    gaus_im = exp (-((window-f_p0)/sigma).^2);
end