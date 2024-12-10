fclose('all');

cd 'C:\Users\charl\Documents\MATLAB stuff\The God Code\Fidfiles'
thing = 'RRthing.fid';

delete (thing);
clear thing


cd 'C:\Users\charl\Documents\MATLAB stuff\The God Code\RRfiles'


thing = 'RRthing.in';
delete (thing)
clear thing


cd 'C:\Users\charl\Documents\MATLAB stuff\The God Code'
rmdir Fidfiles
rmdir RRfiles
clear
