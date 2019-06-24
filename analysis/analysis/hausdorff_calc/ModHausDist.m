function [ mhd ] = ModHausDist( A, B )

    % Calculating the forward HD
    minf = 0; 
    for ax = 1:size(A,1)      
        for ay = 1:size(A,2) 
            for az = 1:size(A,3) 
                fhd = 0; 
                if A(ax, ay, az) ~= 0
                    temp_matrixB = Inf(1, sum(B(:)));
                    idx=1;
                    for bx = 1:size(B,1) 
                        for by = 1:size(B,2)
                            for bz = 1:size(B,3)
                                if B(bx, by, bz) ~=0
                                    A_pixel = [ax, ay, az];
                                    B_pixel = [bx, by, bz];
                                    fhd = sqrt(sum((A_pixel - B_pixel) .^ 2));
                                    temp_matrixB(idx) = fhd;
                                    idx = idx+1;
                                end
                            end
                        end
                    end
                    minf = minf + min(temp_matrixB);        % Sum the forward distances
                end
            end
        end
    end        
    
    % Calculating the reverse HD
    minr = 0;
    for bx = 1:size(B,1) 
        for by = 1:size(B,2)
            for bz = 1:size(B,3)
                rhd = 0;
                if B(bx, by, bz) ~=0
                    temp_matrixA = Inf(1, sum(A(:)));
                    indx=1;
                    for ax = 1:size(A,1)  
                        for ay = 1:size(A,2) 
                            for az = 1:size(A,3) 
                                if A(ax, ay, az) ~= 0
                                    A_pixel = [ax, ay, az];
                                    B_pixel = [bx, by, bz];
                                    rhd = sqrt(sum((B_pixel - A_pixel) .^ 2));
                                    temp_matrixA(indx) = rhd;
                                    indx = indx+1;
                                end
                            end
                        end
                    end
                    minr = minr + min(temp_matrixA);        % Sum the reverse distances
                end
            end
        end
    end  
 
    minf = minf/sum(A(:));         % Divide by the total no. to get average
    minr = minr/sum(B(:));         % Divide by the total no. to get average
    mhd = max(minf,minr);         % Find the minimum of fhd/rhd as the mod hausdorff dist
end
