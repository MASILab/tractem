function data = read_cpx(filename,Nx,Ny,Nz,Ne,Nc)
% Example usage:
% % read order
% % slice 1:65
% Nz=65;
% % echo 1:2
% Ne=2;
% % channel 1:6
% Nc=6;
% % y: 1:109
% Ny=109;
% % x: 1:256
% Nx=256;
% %  complex data
% filename = 'cpx_60703.data'; 

fp = fopen(filename,'rb','ieee-le');
clear data
data = zeros([Nx Ny Nz Ne Nc],'single');
for slice=1:Nz
    for echo=1:Ne
        for channel=1:Nc
            disp([slice echo channel]); drawnow;
            for y=1:109
                dat = fread(fp,512,'float');
                data(:,y,slice,echo,channel) = single(dat(1:2:end)+i*dat(2:2:end));
            end
        end
    end
end
fclose(fp)