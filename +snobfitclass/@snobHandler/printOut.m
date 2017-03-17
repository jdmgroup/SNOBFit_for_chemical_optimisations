function printOut(SNOB)
	fprintf('ncall:\t%d to %d\n', (SNOB.ncall0 - SNOB.nreq + 1), SNOB.ncall0)

	prnt = 'xbest:\t%f';
	for i = 1:SNOB.n-1
		prnt = [prnt,', %f'];
	end
	prnt = [prnt,'\n'];

	fprintf(prnt, SNOB.xbest)
	fprintf('fbest:\t%f\r\n', SNOB.fbest)
end