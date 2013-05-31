function [filtered_image] = deriche_filter(image, alpha)
    % Initialize parameters for smoothing mode
    k = ((1.0 - exp(-alpha)) ^ 2.0) / (1.0 + 2.0 * alpha * exp(-alpha) - exp(-2.0 * alpha));

    a = zeros(1,8);
    a(1) = k;
    a(2) = k * exp(-alpha) * (alpha - 1);
    a(3) = k * exp(-alpha) * (alpha + 1);
    a(4) = -k * exp(-2.0 * alpha);
    for i=1:4
        a(i+4) = a(i);
    end
    b = zeros(1,2);
    b(1) = 2.0 * exp(-alpha);
    b(2) = -exp(-2.0 * alpha);

    c = zeros(1,2);
    c(1) = 1.0;
    c(2) = 1.0;
    
    filtered_image = zeros(size(image));
    for layer = 1:size(image,1)
        temp = treat(squeeze(image(layer,:,:)), a(1:4), b, c(1));
        filtered_image(layer,:,:) = (treat(temp', a(5:8), b, c(2)))'; 
    end
end

function [treated_image] = treat(image, a, b, c)
    out1 = zeros(size(image));
    out2 = zeros(size(image));
    
    % from left to right
    for j = 1:size(image,2)
        if j > 2
            out1(:,j) = a(1) * image(:,j) + a(2) * image(:,j-1) + b(1) * out1(:,j-1) + b(2) * out1(:,j-2);
        end
        if j == 1
            out1(:,j) = a(1) * image(:,j);
        end
        if j == 2
            out1(:,j) = a(1) * image(:,j) + a(2) * image(:,j-1) + b(1) * out1(:,j-1);
        end
    end
   
    % from right to left
    for j = size(image,2):1
        if j < size(image,2)-1
            out2(:,j) = a(3) * image(:,j+1) + a(4) * image(:,j+2) + b(1) * out2(:,j+1) + b(2) * out2(:,j+2);
        end
        if j == size(image,2);
        end
        if j == size(image,2)-1
            out2(:,j) = a(3) * image(:,j+1) + b(1) * out2(:,j+1);
        end
    end
    
    treated_image = (out1 + out2) * c;
end