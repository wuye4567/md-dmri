function s = mdm_mask(s, mask_fun, path, opt)
% function s = mdm_mask(s, mask_fun, path, opt)
%
% Mask the data in s.nii_fn using mask_fun (e.g. mio_mask_simple)
%
% Save the mask as a nifti to s.mask_fn. This field is created if it does
% not exist already

% init
if (nargin < 3) || (isempty(path)), path = fileparts(s.nii_fn); end
if (nargin < 4), opt.present = 1; end

opt = mdm_opt(opt);

msf_log(['Starting ' mfilename], opt);    


% construct the filename
if (~isfield(s,'mask_fn'))
    [~,name] = msf_fileparts(s.nii_fn);
    s.mask_fn = fullfile(path, [name '_' opt.mdm.mask_suffix opt.nii_ext]);
end

if (exist(s.mask_fn, 'file') && (~opt.do_overwrite))
    disp(['Skipping, output file already exists: ' s.mask_fn]); return;
end

% write the mask, don't care if we overwrite anything
if (opt.do_mask)
    [I,h] = mdm_nii_read(s.nii_fn);
    if (any(imag(I(:)) ~= 0)), I = abs(I); end
    M = mask_fun(I, opt);
    mdm_nii_write(uint8(M), s.mask_fn, h);
end