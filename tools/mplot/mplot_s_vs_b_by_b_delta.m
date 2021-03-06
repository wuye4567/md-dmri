function mplot_s_vs_b_by_b_delta(S, xps, fun_data2fit, fun_fit2data, fun_opt, h, h2, ind)
% function mplot_s_vs_b_by_b_delta(S, xps, fun_data2fit, fun_fit2data, fun_opt, h, h2)

if (nargin < 7), h2 = []; end
if (nargin < 8), ind = []; end

% fit function
if (nargin < 8)   
    m = fun_data2fit(S, xps, fun_opt());
else
    m = fun_data2fit(S(ind), mdm_xps_subsample(xps, ind), fun_opt());
end


% find unique b_delta
b_delta_input = round(xps.b_delta * 100) / 100;

[b_delta_uni,~] = unique(b_delta_input);

b_delta_uni = sort(b_delta_uni);

if (numel(b_delta_uni) == 1)
    cmap = [0 0 0];
else
    cmap = hsv(numel(b_delta_uni));
end

cla(h);
hold(h, 'off');
for c = 1:numel(b_delta_uni)
    
    ind = b_delta_input == b_delta_uni(c);
    
    semilogy(h, xps.b(ind) * 1e-9, S(ind) / m(1), 'o', 'color', cmap(c,:), ...
        'markersize', 5, 'markerfacecolor', cmap(c,:));
    hold(h, 'on');
    
    clear xps2;
    xps2.n = 32;
    xps2.b = linspace(eps, max(xps.b(ind)) * 1.1, xps2.n);
    xps2.b_delta = mean(xps.b_delta(ind));
    xps2.b_eta   = mean(xps.b_eta(ind));
    
    S_fit = fun_fit2data(m, xps2);
    
    semilogy(h, xps2.b * 1e-9, S_fit / m(1), '-', 'color', cmap(c,:), 'linewidth', 2);
end

axis(h, 'on');
box(h, 'off');
set(h, 'tickdir','out');



ylim(h, [10^floor(log10(min(S(S(:) > 0) / m(1)))) 1.1]);

xlabel(h, 'b [um^2/ms]');
ylabel(h, 'Signal');



% show legend
if (~isempty(h2))
    
    l_str = cell(1,numel(b_delta_uni));
    for c = 1:numel(b_delta_uni)
        plot(h2,10,10,'-', 'color', cmap(c,:), 'linewidth', 2);
        hold(h2, 'on');
        l_str{c} = ['b_\Delta = ' num2str(b_delta_uni(c))];
    end
    ylim(h2, [-1 1]);
    legend(h2, l_str, 'location', 'northwest');
    axis(h2, 'off');
    
    
end