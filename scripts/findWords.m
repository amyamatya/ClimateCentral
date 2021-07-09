function [outNames] = findWords(inArray, outArray)
% Separate character array into words after removing weird symbols
% Last modified 06/08/21 @aamatya
%-------------Input-----------------------------
% inArray           - boolean array of non-weird characters
% outArray          - array of original characters
%-------------Output----------------------------
% outNames          - string array of words
%-----------------------------------------------
current = 1;
count = 1;
for i = 1:length(inArray)-1
% if current character is not part of current word, end word
    if inArray(i+1) - inArray(i) > 1
        outNames(count) = string(outArray(inArray(current:i)));
        current = i+1;
        count = count+1;
    end
    
end
end

