hold on
 for j= 1:size(filtered_acc,2)-1
     offset = max(data1(:, j));
     dataoffset = data1(:,j)+offset;
     plot(dataoffset);
     legend(''x','y','z','o1','c5','Fp1','cz','fz','fp2','c6','o2','location','bestoutside');
 end
 hold off 