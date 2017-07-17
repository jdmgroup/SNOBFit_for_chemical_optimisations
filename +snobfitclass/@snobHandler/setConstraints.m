function setConstraints(SNOB,src,event)
	if ~isempty(SNOB.xyMin) & ~isempty(SNOB.xyMax) & ~isempty(SNOB.maxRatio) & ~isempty(SNOB.minRatio)
		x1 = SNOB.xyMin / (1 + 1/SNOB.maxRatio);
		y1 = x1 / SNOB.maxRatio;
		x2 = SNOB.xyMin / (1 + 1/SNOB.minRatio);
		y2 = x2 / SNOB.minRatio;
		x3 = SNOB.xyMax / (1 + 1/SNOB.minRatio);
		y3 = x3 / SNOB.minRatio;
		x4 = SNOB.xyMax / (1 + 1/SNOB.maxRatio);
		y4 = x4 / SNOB.maxRatio;

		SNOB.trapezoid = [x1, x2, x3, x4; y1, y2, y3, y4];
		[ux, vx] = snobfitclass.TrapezoidToSquare(SNOB.trapezoid);

		if ~isempty(SNOB.zMin) & ~isempty(SNOB.zMax)			
			SNOB.x_lower = [min(ux); min(vx); SNOB.zMin];
			SNOB.x_upper = [max(ux); max(vx); SNOB.zMax];
		else
			SNOB.x_lower = [min(ux); min(vx)];
			SNOB.x_upper = [max(ux); max(vx)];
		end
	end
end