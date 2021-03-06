function xps = mdm_xps_from_gdir(gdir_fn, delimeter)
% function xps = mdm_xps_from_gdir(gdir_fn, delimeter)
%
% read a gradient textfile in the Lund format, which is defined as follows
%   n_x, n_y, n_z, b
% 
% units of b are in s/mm2, i.e., b = 1000 s/mm2 for a standard DTI
%
% the xps is always in SI units

if (nargin < 2), delimeter = ','; end


% read text and split by delimeter, keeping only non-empty entries to solve
% problems of multiple consequtive delimeters such as spaces
txt = mdm_txt_read(gdir_fn);
f = @(x) x(~cellfun(@isempty, x));

tmp = cellfun(@(x) strsplit(x, delimeter), txt, 'uniformoutput', 0);
tmp = cellfun(f, tmp, 'uniformoutput', 0);
tmp = cellfun(@(x) str2double(x)', tmp, 'uniformoutput', 0);
tmp = cell2mat(tmp);

% compile the output
xps.b   = tmp(4,:)' * 1e6; 
xps.u   = tmp(1:3,:)';
xps.n   = numel(xps.b);
xps.bt  = tm_1x3_to_1x6(xps.b, zeros(size(xps.b)), xps.u);
xps.bt2 = tm_1x6_to_1x21(xps.bt);



