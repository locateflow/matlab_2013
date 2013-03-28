function phraseModel = makeMarkovPhraseModelFromElementMat(elementMat)
% Adapted from:
% function phraseModel = makePhrasePoissonModelFromElementMat(elementMat)
% and
% function phraseModel = makePhraseMarkovElementModelFromMarkovMat(inputMarkovMat, elementMat)
% edited 3/27/2013, previus version posted to github
elementMat(isnan(elementMat)) = -77;
[rows, cols] = size(elementMat);
phraseModel = zeros(1000, cols);
% gives all unique phrases in a row.
uPhrase = unique(elementMat, 'rows')
numPhrases = length(uPhrase(:,1))

% make markov matrix
markov = zeros(numPhrases);
for i = 1:numPhrases
    % f1 gives the row #s where this unique phrase is found.
    f1 = find(ismember(elementMat, uPhrase(i, :), 'rows'));
    % remove the last index if it corresponds to the last row.
    if f1(end) == length(elementMat(:,1))
        f1 = f1(1:end-1);
    end
    next = f1+1;
    next = elementMat(next, :);
    uNext = unique(next, 'rows');
    for j = 1:length(uNext(:,1))
        numerator = sum(ismember(next, uNext(j, :), 'rows'));
        denominator = length(next(:,1));
        element_p = numerator/denominator;
        markov_col = find(ismember(uPhrase, uNext(j, :), 'rows'));
        markov(i, markov_col) = element_p;
    end
end

r = ceil(numPhrases*rand(1));
lastPhrase = uPhrase(r, :);
phraseModel(1,:) = uPhrase(r, :);
iLast = r;

for i = 2:1000   
    size(markov)   
    size(numPhrases)
    probabilities = markov(iLast, :)
    sumProb = cumsum(probabilities)
    if sumProb == 0
       probabilities(1:numPhrases) = 1/numPhrases;
       sumProb = cumsum(probabilities)
    end
    r = rand(1)
    iNext = find(sumProb > r, 1, 'first')
    nextPhrase = uPhrase(iNext, :);
    phraseModel(i,:) = nextPhrase;
    iLast = iNext
end

phraseModel(phraseModel == -77) = NaN;
    

    
    

    