function [child_sep, child_del] = generateChildDelayAndSep(separator_cell, delayed_cell, rand_parent)
    % Calculate the middle positions of the arrays in 'separator_cell' and 'delayed_cell'
    pos_sep = round(size(cell2mat(separator_cell), 2) / 2);
    pos_delayed = round(size(cell2mat(delayed_cell), 2) / 2);

    % Generate children based on 'rand_parent'
    if rand_parent == 1
        % For 'separator_cell', take the first half from the first cell and the second half from the second cell
        child_sep = [separator_cell{1}(1:pos_sep), separator_cell{2}(pos_sep+1:end)];
        
        % For 'delayed_cell', take the first half from the first cell and the second half from the second cell
        child_del = [delayed_cell{1}(1:pos_delayed), delayed_cell{2}(pos_delayed+1:end)];
    else
        % For 'separator_cell', take the first half from the second cell and the second half from the first cell
        child_sep = [separator_cell{2}(1:pos_sep), separator_cell{1}(pos_sep+1:end)];
        
        % For 'delayed_cell', take the first half from the second cell and the second half from the first cell
        child_del = [delayed_cell{2}(1:pos_delayed), delayed_cell{1}(pos_delayed+1:end)];
    end
end
