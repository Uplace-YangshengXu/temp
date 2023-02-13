%addpath FBG_ROS2/

addr = '192.168.1.11';
pt = 1852;

interrogator = get_interrogator(addr,pt);

RawData = Read_interrogator_python(1,3,4,interrogator)
