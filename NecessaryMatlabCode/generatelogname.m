function [logname] = generatelogname()
%%  determine filenames within the current directory
list = dir;
%% process the current date
callendar{1,1} = 'Jan'; callendar{1,2} = 'Feb'; callendar{1,3} = 'Mar'; callendar{1,4} = 'Apr'; 
callendar{1,5} = 'May'; callendar{1,6} = 'Jun'; callendar{1,7} = 'Jul'; callendar{1,8} = 'Aug';
callendar{1,9} = 'Sep'; callendar{1,10} = 'Oct'; callendar{1,11} = 'Nov'; callendar{1,12} = 'Dec';
D = date();
        dy =  num2str(D(1:2),'%02.f');
        for n = 1:size(callendar,2)
            if strcmp(D(4:6),callendar{1,n}) > 0;
                mo =  num2str(n,'%02.f');
            end
        end
        yr = num2str(D(10:11),'%02.f');
 datecode = [yr mo dy];  
  %datecode = ['220418'];  
  
%%  
conflict = 1; it = 0;
while conflict > 0
    it = it+ 1;
    its = num2str(it,'%03.f');
    nm = ['matlog_' datecode '_' its '.mat'];
    
    for n = 1:size(list) 
            x(n) = strcmp(nm,list(n).name);
    end
    if sum(x) == 0
        conflict = 0;
    elseif sum(x) > 0
    end
end

logname = nm;

