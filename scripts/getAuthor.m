% function [finalName] = getAuthor(queryExcel);
% Get author names from online articles
% Last modified 06/08/21 @aamatya
%-------------Input-----------------------------
% queryExcel        - excel filename
%                     column 1: URL
%                     column 2: Headline
%-------------Output----------------------------
% finalName         - (optional) array of names
% queryExcel        - colunn 3: author name
%-----------------------------------------------
% Go to directory
cd /Users/aamatya/Documents/MATLAB/ClimateCentral/scripts
addpath /Users/aamatya/Documents/MATLAB/ST2021/functions
addpath /Users/aamatya/Documents/MATLAB/ClimateCentral/data
% Load list of possible first names
namez = readtable('names.xlsx');
namez = table2cell(namez);
namez = string(namez);
% Load URLs
spreadSheet = readtable('urls.xlsx');
spreadSheet = table2cell(spreadSheet);
spreadSheet = string(spreadSheet);
urls = spreadSheet(:,1);
headLines = spreadSheet(:,2);
for i = 1:length(urls)
    i
    % See if article has already been found
    if i > 1
        thisHL = char(headLines(i));
        thisHL = thisHL(isstrprop(headLines(i), 'alpha'));
        lastHL = char(headLines(i-1));
        lastHL = lastHL(isstrprop(headLines(i-1), 'alpha'));
        if strncmpi(thisHL, lastHL, 10) && ~strcmp(finalName(end), "")
            finalName(i) = finalName(i-1);
            continue;
        end
    end
    % Inspect webpage code for mentions of 'author'
    try
        x = webread(urls(i));
        nameMatches = [strfind(x, 'author') strfind(x, 'article_author') strfind(x, 'articleAuthor')...
            strfind(x, 'author_name') strfind(x, 'authorName') strfind(x, 'authorname')];
        if isempty(nameMatches)
            finalName(i) = "";
            continue
        end
    catch
        finalName(i) = "";
        continue
    end
    % Grab 50 characters after 'author', exclude weird symbols, parse into words
    for j = 1:length(nameMatches)
        match = x(nameMatches(j):nameMatches(j)+150);
        strMatch = string(match);
        charCut = find(isstrprop(strMatch, 'alpha'));
        try
            wordz = findWords(charCut, match);
        catch
            finalName(i) = "";
            continue
        end
        % Find words that resemble common first names
        [~, found,~] = intersect(wordz, namez);
        [~, uniqueFinds, ~] = unique(wordz(found));
        found = sort(found(uniqueFinds));
        found = findConsecutive(found);
        if isempty(found) | found >= length(wordz)
            finalName(i) = "";
            continue
        elseif length(found) == 1
            finalName(i) = append(wordz(found),' ', wordz(found+1));
            break
        elseif length(found) == 2 & (found(2)-found(1) == 1)
            finalName(i) = append(wordz(found(1)),' ', wordz(found(1)+1));
            break
        else
            count = 1;
            finalName(i) = "";
            while count <= length(found)
                if found(count) == length(wordz)
                    finalName(i) = append(finalName(i), ' ', wordz(found(count)));                    
                elseif finalName(i) == ""
                    finalName(i) = append(wordz(found(count)),' ',wordz(found(count)+1));
                    count = count+1;
                else
                    finalName(i) = append(finalName(i),' and ', wordz(found(count)),' ',wordz(found(count)+1));
                    count = count+1;
                end
            end
            break
        end
    end
end
finalName = finalName';
% Go back and fill names found later

% Add replacements here
finalName(strcmp(finalName, 'Alan Comfort')) = 'Guy Walton';
finalName(strcmp(finalName, 'Robert A')) = 'Robert Cronkleton';
finalName(strcmp(finalName, 'Mark Pe')) = 'Mark Pena';
finalName(strcmp(finalName, 'Ana Cristina')) = 'Ana Sanchez';
% Save to file
writetable(array2table(finalName),'/Users/aamatya/Documents/MATLAB/ClimateCentral/urls.xlsx', 'Range','C1');
% end