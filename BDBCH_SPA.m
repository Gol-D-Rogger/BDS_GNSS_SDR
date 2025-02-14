function output = BDBCH_SPA(input_frame,H,llr)

success = 0; 
max_iterations = 10; 
current_iteration = 1;
% SNR = 1.25;

 
p = 0.2; % p is the crossover probability (probability that 1 sent and 0 received for example). Used only if the channel is BSC

current_frame = input_frame;
nb_c_nodes = size(H,1);
nb_v_nodes = size(H,2);


%--------- error checking  -------------
% if the syndrome is already null, no errors !
areErrorsPresent = check_errors(H, input_frame);
if areErrorsPresent == 0
    success = 1;
end

%----------------------------------------------------------------------

    
if success == 0
    
    r_vector = llr;
%     r_vector = a_priori_log_likehood_AWGN(input_frame,SNR);
    Mji_matrix_first_iteration = generate_Mji_matrix_first_iteration(H, r_vector, nb_c_nodes, nb_v_nodes);
    Eji_matrix = generate_Eji_matrix(Mji_matrix_first_iteration,nb_c_nodes, nb_v_nodes);
    Lj_vector = generate_Lj_vector(r_vector, Eji_matrix, nb_v_nodes);
    current_frame = update_frame(Lj_vector, nb_v_nodes);   
    
    %check again if all the errors are corrected
    areErrorsPresent = check_errors(H, current_frame);
    if areErrorsPresent == 0
        success = 1;
    end
    
    
end
%------------end of 1st exchange between c and v nodes--------------



%-------- DECODE LOOP ---------------

while success==0 && current_iteration<max_iterations
    
    current_iteration = current_iteration + 1;   
    Mji_matrix = generate_Mji_matrix(H, Eji_matrix, r_vector, nb_c_nodes, nb_v_nodes);
    Eji_matrix = generate_Eji_matrix(Mji_matrix,nb_c_nodes, nb_v_nodes);
    Lj_vector = generate_Lj_vector(r_vector, Eji_matrix, nb_v_nodes);
    current_frame = update_frame(Lj_vector, nb_v_nodes);
   
    areErrorsPresent = check_errors(H, current_frame);
    if areErrorsPresent == 0
        success = 1;
    end
    
    
end
    if success ~= 1
%         disp("correction failed");
    end
    
    output = current_frame;
end



%------------- OTHER FUNCTIONS -----------



%return 1 if there's errors in the frame
% return 0 if not
function res = check_errors(H, current_frame)

    syndrome =  H * transpose(current_frame); % syndrome = H * v^t
    areErrors = any(mod(syndrome,2)); %  if there's something else than 0 in the syndrome, ERROR detected
    
    res = areErrors;
end


%returns a vector r containig a priori log likehood for each received bit
% This function represents the channel and can be modified. This one is to
% get LLR of of a BSC (binary symetric channel), where only p is needed
function r = a_priori_log_likehood(input_frame,p)
    r = zeros(1,size(input_frame,2));
    for i = 1: size(input_frame,2)
        if input_frame(i) == 1
            r(i) = log(p/(1-p));
        else
            r(i) = log((1-p)/p);
        end
    end
end

% example of function to get the LLR of AWGN channel. Signal to Noise Ratio
% needed
function r = a_priori_log_likehood_AWGN(input_frame,SNR)
    r = zeros(1,size(input_frame,2));
    for i = 1: size(input_frame,2)
        r(i) = 4 * input_frame(i) * SNR;%LLR computation
    end
end

% creates the Mji matrix which will be "sent" to check nodes. In the first
% iteration, Mji=ri
function Mji_matrix_first_iteration = generate_Mji_matrix_first_iteration(H, r, nb_c_nodes, nb_v_nodes)
    Mji_matrix_first_iteration = zeros(nb_c_nodes, nb_v_nodes);
    for i = 1:nb_c_nodes
        for j=1:nb_v_nodes
            if H(i,j) == 1
                Mji_matrix_first_iteration(i,j) = r(j);
            end
        end
    end  
end


% creates the Mji matrix which will be "sent" to check nodes
function Mji_matrix = generate_Mji_matrix(H, Eji_matrix, r_vector, nb_c_nodes, nb_v_nodes)
    Mji_matrix = zeros(nb_c_nodes, nb_v_nodes);
    for i = 1:nb_c_nodes
        for j=1:nb_v_nodes
            if H(i,j) == 1
                Mji = generate_Mji(Eji_matrix, r_vector, nb_c_nodes, i, j);
                Mji_matrix(i,j) = Mji;
            end
        end
    end  
end


function Mji = generate_Mji(Eji_matrix, r_vector, nb_c_nodes, i, j)
    tmp = 0;
    forbidden_index = i;
    for i= 1:1:nb_c_nodes
       if (Eji_matrix(i,j) ~= 0) && (i ~= forbidden_index)
           tmp = tmp + Eji_matrix(i,j);
       end
    end
    Mji = tmp + r_vector(j);
end

% creates the Eji matrix, aka matrix of extrinsic probabilities. for each
% probability of Mji, the extrinic probability is the """sum""" of the
% other probabilities except the current one
function Eji_matrix = generate_Eji_matrix(Mji_matrix, nb_c_nodes, nb_v_nodes)
    Eji_matrix = zeros(nb_c_nodes, nb_v_nodes);
    for i = 1:1:nb_c_nodes %iteative parsing of Mji
        for j = 1:1:nb_v_nodes
            if Mji_matrix(i,j) ~= 0 % we compute the extrinsic probability only if there's a probability in these coordinates
                Eji = generate_Eji(i,j,Mji_matrix,nb_v_nodes);
                Eji_matrix(i,j) = Eji;
            end
        end 
    end
end

% for a given probability, generates its extrinsic probability. This
% functions is performed by check nodes
function Eji = generate_Eji(i,j,Mji_matrix,nb_v_nodes)
    tmp = 1;
    forbidden_index = j;
    for j = 1:1:nb_v_nodes % iteration on each proability get by the i-th c_node
        if (j ~= forbidden_index) && (Mji_matrix(i,j) ~= 0)
            not_current_Mji = Mji_matrix(i,j);
            tmp = tmp * tanh(not_current_Mji / 2);
        end
    end
    Eji = log((1+tmp)/(1-tmp)); % the said """sum"""
end

% creates the new log likehood ratio vector after 1 iteration
function Lj_vector = generate_Lj_vector(r_vector, Eji_matrix, nb_v_nodes)
    Lj_vector = zeros(1,nb_v_nodes); 
    for j = 1:1:nb_v_nodes % iteration of Eji column by column (ie for each v_node)
       Lj = generate_Lj(j, r_vector, Eji_matrix(:,j));
       Lj_vector(j) = Lj;
    end
end

% creates the j-th new log likehood ratio after 1 iteration. It is the sum
% of all extrinsic probabilities received by the v_node + initial log
% likehood ratio 
function Lj = generate_Lj(j, r_vector, extrinsic_probabilities)
    Lj = sum(extrinsic_probabilities) + r_vector(j);
end

% updating the current frame with the inforation of the new LLR
% the sign gives the bit ( minus means it should be 1) and the |value|
% is the reliability
function current_frame = update_frame(Lj_vector, nb_v_nodes)
    current_frame = zeros(1, nb_v_nodes);
    for j=1:1:nb_v_nodes
        if Lj_vector(j) < 0
            current_frame(j) = 1;
        end
    end
end

