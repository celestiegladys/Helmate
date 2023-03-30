for i=1:11
    figure(); % create a new figure for each i
    for a=1:5
        plot(EEG.times,transpose(EEG.data(i,:,a))); % plot the i-th data
        hold on;
    end  
   title(compose('data %d', i)); % create a legend string
    legend('epoch1','epoch2','epoch3','epoch4','epoch5','bestOutside');
    xlabel('Time (ms)');
    ylabel( compose('acclerometer and channels %d',i));
end 
 