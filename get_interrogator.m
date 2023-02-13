function interrogator = get_interrogator(addr,pt)
%addpath FBG_ROS2/

% load python3.8
pe = pyenv;
if pe.Version ~= '3.8'
    disp("load python3.8 interpreter");
    pyenv('Version','/usr/bin/python3.8');
    py.list;
end

interrogator = pyrunfile("get_interrogator.py",'interrogator',address = addr,port = pt);
% test
% tic
%     ans = interrogator.getData(); 
% toc
end
