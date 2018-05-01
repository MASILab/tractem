function viewPARREC(parrec, idx)
% function viewPARREC(parrec, idx)
%
% View the idx-th image volume in the parrec image stack object. 
%
% (C)opyright 2005, Bennett Landman, bennett@bme.jhu.edu
% Revision History:
% Created: 2/11/2005
% Bug fix: 6/6/2005 Corrected A/P axis. 
parrec.avw.img = double(parrec.scans{idx}(:,end:-1:1,:)); % AVW is R->L,P->A, REC is R->L,A->P
avw_view(parrec.avw);