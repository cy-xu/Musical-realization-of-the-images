%       This function separates the digits of a number 
%  Thus,,,,, digits=numsep(567),,,,,will give ,, digits=[5 6 7]

function output=numsep(a)

numcheck=10;
numdig=1;
while 1
if((a/numcheck)>1)
    numdig = numdig + 1;
    numcheck = numcheck * 10;
else,break
end
end

output = [];
for (i = 1:numdig)
    num = a - floor(a/10) * 10;
    output = [output num];
    a = floor(a/10);
end

output = fliplr(output);