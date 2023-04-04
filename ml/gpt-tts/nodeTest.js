const http = require('http'); // or 'https' for https:// URLs
const fs = require('fs');
const maxApi = require('max-api');
const { StringDecoder } = require('string_decoder');

var myKey = "You_need_to_put_in_your_key";

maxApi.addHandler('setKey', (key) => {
	myKey = key;
});

maxApi.addHandler('say', (words) => {
	const urlWords = encodeURI(words)
	const fileWords = words.replace(/ /g,"_").replace(/\./g,"").replace(/\!/g,"").replace(/\?/g,"");
	fileName = "tts_"+fileWords+".wav"
	if (fs.existsSync(fileName)) {
		// they've already asked for it and we can just return what they did before
		maxApi.outlet("exists "+fileName);
		return;
  }
	var errorMessage = "";
	var isError = false;
	const file = fs.createWriteStream(fileName);
	const request = http.get("http://api.voicerss.org/?key="+myKey+"&hl=en-us&src="+words, function(response) {
		response.pipe(file);	
		response.on('data', function (chunk) {
			const decoder = new StringDecoder('utf8');
	    isError = decoder.write(chunk).startsWith("ERROR")
	    errorMessage = decoder.write(chunk)
	  });
	  response.on('end', function () {
	  	if(isError){
	  		maxApi.outlet("error "+errorMessage);
	  	}else{
				maxApi.outlet("success "+fileName);
	  	}
	  	console.log("isError: "+isError);
	  });	
	
	});
});