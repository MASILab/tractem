function updatePARfile(tarPar,srcPar)
% History: 5/2/06: Updated to support coronal files
% 3/20/08: Bug fix for multi-echo, single dynamic volumes
par = loadPAR(srcPar);
newpar = loadPAR(tarPar);
par.scn.fov = newpar.scn.fov;
par.scn.recon_res = newpar.scn.recon_res;
par.scn.slicethk = newpar.scn.slicethk;
last = 0;
for j=1:length(par.img)
    q(j) = par.img(j).info.dynamic_scan_num;
    r(j) = par.img(j).info.echo_num;
    SRC_image_flip_angle(par.img(j).info.dynamic_scan_num) = par.img(j).special.image_flip_angle;
    SRC_diffusion_b_factor(par.img(j).info.dynamic_scan_num) = par.img(j).special.diffusion_b_factor;
    SRC_echo_time(par.img(j).info.echo_num) = par.img(j).special.echo_time;
end
qq=q;
%UQ = unique(q*(1+max(r(:)))+r);
%Nvol = length(UQ);
clear q;
for j=1:length(newpar.img)
    q(j) = newpar.img(j).info.dynamic_scan_num+...
        newpar.img(j).info.echo_num*(1+max(r(:)));
end
onevol = find((q==q(1)));
par.img = [];
% for j=1:Nvol
%     for k=1:length(onevol)
%         img = newpar.img(onevol(k));
%         img.info.dynamic_scan_num = j;
%         img.special.image_flip_angle = SRC_image_flip_angle(find(UQ==UQ(j)));
%         img.special.diffusion_b_factor = SRC_diffusion_b_factor(find(UQ==UQ(j)));
%         img.special.echo_time = SRC_echo_time(find(UQ==UQ(j)));
%         if(isempty(par.img))
%             par.img = img;
%         else
%         par.img(end+1) = img;
%         end
%     end
% end
for j=1:length(unique(qq)) % dynamic scans
    for jj=1:length(unique(r)) % echos
        for k=1:length(onevol)
            img = newpar.img(onevol(k));
            img.info.dynamic_scan_num = j;
            img.info.echo_num = jj;
            img.special.image_flip_angle = SRC_image_flip_angle(j);
            img.special.diffusion_b_factor = SRC_diffusion_b_factor(j);
            img.special.echo_time = SRC_echo_time(jj);
            if(isempty(par.img))
                par.img = img;
            else
                par.img(end+1) = img;
            end
        end
    end
end

par.max.num_dynamics = length(par.img);
switch(par.img(1).orient.orient)
    case 'TRA'
        par.max.num_slices = par.scn.fov(2)/par.scn.slicethk;
    case 'COR'
        par.max.num_slices = par.scn.fov(1)/par.scn.slicethk;
    case 'SAG'
        par.max.num_slices = par.scn.fov(3)/par.scn.slicethk;
end
par.max.num_slices=round(par.max.num_slices);

savePAR(par, srcPar);