function saveFigureOwn(name)
export_fig(sprintf('Results/%s.pdf', name),...
        '-pdf','-transparent');
end