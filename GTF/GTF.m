function result = GTF(I,V)
warning off;
addpath(genpath(cd));

I = double(I(:,:,1))/255;
V = double(V(:,:,1))/255;
nmpdef;
pars_irn = irntvInputPars('l1tv');

pars_irn.adapt_epsR   = 1;
pars_irn.epsR_cutoff  = 0.01;   % This is the percentage cutoff
pars_irn.adapt_epsF   = 1;
pars_irn.epsF_cutoff  = 0.05;   % This is the percentage cutoff
pars_irn.pcgtol_ini = 1e-4;
pars_irn.loops      = 5;
pars_irn.U0         = I-V;
pars_irn.variant       = NMP_TV_SUBSTITUTION;
pars_irn.weight_scheme = NMP_WEIGHTS_THRESHOLD;
pars_irn.pcgtol_ini    = 1e-2;

pars_irn.adaptPCGtol   = 1;

U = irntv(I-V, {}, 2, pars_irn);

X=U+V;
X=uint8(X*255);
result = X;
end