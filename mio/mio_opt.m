function opt = mio_opt(opt)
% function opt = mio_opt(opt)

if (nargin < 1), opt = []; end

opt = mdm_opt(opt);

opt.mio.present = 1;

opt.mio = msf_ensure_field(opt.mio, 'no_parfor', 0); 

opt.mio.coreg.present = 1;
opt.mio.coreg = msf_ensure_field(opt.mio.coreg, 'clear_header', 1);
opt.mio.coreg = msf_ensure_field(opt.mio.coreg, 'assume_las', 1);
opt.mio.coreg = msf_ensure_field(opt.mio.coreg, 'pad_xyz', [0 0 0]);
opt.mio.coreg = msf_ensure_field(opt.mio.coreg, 'adjust_intensity', 0);
