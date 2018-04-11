function [ guess ] = denoise( image, theta_1, theta_2)
    probs = rand([28 28]);
    avg_diff = 1;
    while avg_diff > 1e-8
        prev_probs = probs;
        for x = 1:28
            for y = 1:28
                neighhhhbors = [];
                if x ~= 1
                    neighhhhbors = [neighhhhbors [x-1 y]'];
                end
                if y ~= 1
                    neighhhhbors = [neighhhhbors [x y-1]'];
                end
                if x ~= 28
                    neighhhhbors = [neighhhhbors [x+1 y]'];
                end
                if y ~= 28
                    neighhhhbors = [neighhhhbors [x y+1]'];
                end

                a = 0;
                for i = 1:length(neighhhhbors)
                    x_ = neighhhhbors(1, i);
                    y_ = neighhhhbors(2, i);

                    a = a + (theta_1 * (2 * prev_probs(x_, y_) - 1) + theta_2 * double(image(x_, y_)));
                end
                a_exp = exp(a);
                b_exp = exp(-a);

                probs(x, y) = (a_exp / (a_exp + b_exp));
            end
        end
        
        avg_diff = sum(sum(abs(probs - prev_probs)))/28;
        %disp(avg_diff)
    end
    
    guess = probs;
    guess(guess >= 0.5) =  1;
    guess(guess <  0.5) = -1;
    guess = int8(guess);

end

