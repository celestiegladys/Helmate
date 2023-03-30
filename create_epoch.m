data_epoch = cell(numel(heel_strike_locations)-1, 1);
for i = 1:numel(heel_strike_locations)-2
    if mod(i,2)==1
     %if heel_strike_locations(i)<1668
        x = heel_strike_locations(i);
        y = heel_strike_locations(i+2);
        data_epoch{i} = filtered_acc_z(x:y);
    % else
      % x = heel_strike_locations(i);
       % data{i} = filtered_acc_z(x:end);
    % end 
    end
end    
