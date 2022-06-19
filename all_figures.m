for i=1:16
    step=i;
    try
        %system('./figures_paper '+step);
        figures_paper;
        close
    catch
        continue
    end
end
for i=19:26
    step=i;
    try
        %system('./figures_paper '+step);
        figures_paper;
        close
    catch
        continue
    end
end