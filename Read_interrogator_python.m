function RawData = Read_interrogator_python(ReadCount,ChannelNumber,AANumber,Interrogator)

RawData = zeros(ReadCount,AANumber*ChannelNumber);
count = 1;
for i = 1:ReadCount

    data = double(Interrogator.getData());
    % the return value is a chnum * aanum ndarray
    % connver the ndarray to matlab matrix
    %temp = zeros(1,AANumber*ChannelNumber);
    for j = 1:ChannelNumber
        RawData(i,(j-1)*AANumber+1:1:(j-1)*AANumber+4) = data(j,:);
    end
    count = count + 1;
end
%disp(RawData);
end