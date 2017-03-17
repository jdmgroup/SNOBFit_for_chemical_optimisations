function addOutput(SNOB)
	addlistener(SNOB, 'DataToPlot', @(src,event)snobfitclass.snobHandler.plotOut(src));
	addlistener(SNOB, 'DataToPrint', @(src,event)snobfitclass.snobHandler.printOut(src));
	addlistener(SNOB, 'StatusChange', @(src,event)snobfitclass.snobHandler.changeStatus(src));
	addlistener(SNOB, 'StartingExp', @(src,event)snobfitclass.snobHandler.checkName(src));
	addlistener(SNOB, 'linked', 'PostSet', @(src,event)snobfitclass.snobHandler.setConstraints(SNOB,src,event));
	addlistener(SNOB, 'xyMax', 'PostSet', @(src,event)snobfitclass.snobHandler.setConstraints(SNOB,src,event));
	addlistener(SNOB, 'xyMin', 'PostSet', @(src,event)snobfitclass.snobHandler.setConstraints(SNOB,src,event));
	addlistener(SNOB, 'minRatio', 'PostSet', @(src,event)snobfitclass.snobHandler.setConstraints(SNOB,src,event));
	addlistener(SNOB, 'maxRatio', 'PostSet', @(src,event)snobfitclass.snobHandler.setConstraints(SNOB,src,event));
	addlistener(SNOB, 'zMax', 'PostSet', @(src,event)snobfitclass.snobHandler.setConstraints(SNOB,src,event));
	addlistener(SNOB, 'zMin', 'PostSet', @(src,event)snobfitclass.snobHandler.setConstraints(SNOB,src,event));
	addlistener(SNOB, 'u', 'PostSet', @(src,event)snobfitclass.snobHandler.initialisation(SNOB,src,event));
	addlistener(SNOB, 'v', 'PostSet', @(src,event)snobfitclass.snobHandler.initialisation(SNOB,src,event));
	addlistener(SNOB, 'fcn', 'PostSet', @(src,event)SNOB.defaults);
	addlistener(SNOB, 'filepath', 'PostSet', @(src,event)snobfitclass.snobHandler.checkPath(SNOB,src,event));
	addlistener(SNOB, 'name', 'PostSet', @(src,event)snobfitclass.snobHandler.loadPrevious(SNOB,src,event));
	addlistener(SNOB, 'continuing', 'PostSet', @(src,event)snobfitclass.snobHandler.loadPrevious(SNOB,src,event));
end