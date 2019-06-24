function [hd, hdmean, modHausdd, hd90] = HD(A, B)
    % HD, HDmean, HD90
    [a_x, a_y, a_z] = ind2sub(size(A), find(A));
    a_coords = cat(2, a_x, a_y, a_z);
    [b_x, b_y, b_z] = ind2sub(size(B), find(B));
    b_coords = cat(2, b_x, b_y, b_z); 
    clear a_x a_y a_z b_x b_y b_z
    [hd, hdmean, modHausdd, hd90] = HausdorffDists(a_coords,b_coords);
end
