%This function returns the univariate probability distribution, The function requires the input as mean, sigma and the input vector whose probability distribution has to be computed.
function f=probDist(x,m,sig)

for ii = 1:length(x)
f(ii) = 1/(sig*sqrt(2*pi)) .* exp(-((x(ii)-m)^2 / (2*(sig)^2)));

end

end
