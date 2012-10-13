 function copy = copyobj2(obj)
    save('temp','obj');
    copy = load('temp');
    copy = copy.obj;
 end

