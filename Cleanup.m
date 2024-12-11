fclose('all');

cd 'C:\Matlab\development_pantheon_2\Fidfiles'
thing = 'RRthing.fid';

delete (thing);
clear thing


cd 'C:\Matlab\development_pantheon_2\RRfiles'


thing = 'RRthing.in';
delete (thing)
clear thing


cd 'C:\Matlab\development_pantheon_2'
rmdir Fidfiles
rmdir RRfiles
clear
