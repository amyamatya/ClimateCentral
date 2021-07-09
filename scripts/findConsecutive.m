function [inNums] = findConsecutive(inNums)
% Keep first of a series of consecutive numbers 
% Last modified 06/08/21 @aamatya
%-------------Variables-----------------------------
% inNums           - index array, return original with 
%                    consecutive numbers removed
%-----------------------------------------------
current = 1;
badNum = [];
while current < length(inNums)
% if current character is not part of current word, end word
    if inNums(current+1) - inNums(current) == 1
        badNum = [badNum current+1];
        current = current+1;
    end
    current = current+1;
end
inNums(badNum) = [];
end

