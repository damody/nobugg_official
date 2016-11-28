lapis = require "lapis"

class extends lapis.Application
	@enable "etlua"
	"/": =>
 		layout: false, render: "index"

