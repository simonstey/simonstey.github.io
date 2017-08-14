var Module;
var outputElement = document.getElementById('output');
var runButton = document.getElementById('run');
var input = ace.edit("input");
var ex = document.getElementById("examples");
var output = "";
var odrl_core = "";

input.setTheme("ace/theme/textmate");
input.$blockScrolling = Infinity;
input.setOptions({
  useSoftTabs: true,
  tabSize: 2,
  maxLines: Infinity,
  mode: "ace/mode/gringo",
  autoScrollEditorIntoView: true
});

function example() {
	if(ex.value.indexOf("&") == -1) {
		load_example(ex.value);
	} else {
	var examples = getFiles(ex.value).example;
		load_example("clingo/run/examples/" + examples[0]);
		for (var i=1;i<examples.length;i++) {
			insert_example("clingo/run/examples/" + examples[i]);
		}
		console.log(examples[0])
	}
	load_odrl();
}

function load_odrl() {
  var request = new XMLHttpRequest();
  request.onreadystatechange = function() {
    if (request.readyState == 4 && request.status == 200) {
      odrl_core += request.responseText;
    }
  }
  request.open("GET", "odrl_core.lp", true);
  request.send();
}


function load_example(path) {
  var request = new XMLHttpRequest();
  request.onreadystatechange = function() {
    if (request.readyState == 4 && request.status == 200) {
      input.setValue(request.responseText, -1);
    }
  }
  request.open("GET", path, true);
  request.send();
}

function insert_example(path) {
  var request = new XMLHttpRequest();
  request.onreadystatechange = function() {
    if (request.readyState == 4 && request.status == 200) {
	  input.insert(request.responseText);
    }
  }
  request.open("GET", path, true);
  request.send();
}



function solve() {

options = "";
  if (document.getElementById("stats").checked) { options += " --stats"; }
  if (document.getElementById("project").checked) { options += " --project"; }
  var index = document.getElementById("mode").selectedIndex;
  if (index >= 0) {
    if (index == 1) {
      options += " --opt-mode=optN --enum-mode=brave";
    }
    else if (index == 2) {
      options += " --opt-mode=optN --enum-mode=cautious";
    }
    else if (index == 3) {
      options += " --opt-mode=optN 0";
    }
  }
  //options += " --help=3";
  output = "";
  Module.ccall('run', 'number', ['string', 'string'],[input.getValue()+" "+odrl_core, options])

  var regEx = new RegExp('(?:Answer: .*\n)(.+)\n','gm')
  var html = '';
  var sol = 1;
  while (result = regEx.exec(output)) {
   var rules = result[1].split(" ");
    html += '<div class="accordion"><h3>Answer '+sol+'</h3><div><ul data-role="listview" data-inset="true">';
	rules.forEach(function(entry) {
		html += '<li class="row">'+entry+'</li>';
	});
html += '</ul></div></div>';
sol++;
}
 var menulistitem = html;
    document.getElementById("menu-content").innerHTML = menulistitem;
	  $( ".accordion" ).accordion({
  collapsible: true
});

  updateOutput();
}

function clearOutput() {
  output = "";
  updateOutput();
}

function updateOutput() {
  if (outputElement) {
    outputElement.textContent = output;
    outputElement.scrollTop = outputElement.scrollHeight; // focus on bottom
  }
}

Module = {
  preRun: [],
  postRun: [],
  print: (function() {
    return function(text) {
      if (arguments.length > 1) text = Array.prototype.slice.call(arguments).join(' ');
      output += text + "\n";
    };
  })(),
  printErr: function(text) {
    if (arguments.length > 1) text = Array.prototype.slice.call(arguments).join(' ');
    if (text == "Calling stub instead of signal()") { return; }
    var prefix = "pre-main prep time: ";
    if (typeof text=="string" && prefix == text.slice(0, prefix.length)) { text = "Ready to go!" }
    output += text + "\n";
    updateOutput();
  },
  setStatus: function(text) {
    if (text == "") { runButton.disabled = false; }
    else {
      output += text + "\n";
      updateOutput();
    }
  },
  totalDependencies: 0,
  monitorRunDependencies: function(left) {
    this.totalDependencies = Math.max(this.totalDependencies, left);
    Module.setStatus(left ? 'Preparing... (' + (this.totalDependencies-left) + '/' + this.totalDependencies + ')' : 'All downloads complete.');
  }
};
Module.setStatus('Downloading...');
window.onerror = function(event) {
  Module.setStatus('Exception thrown, see JavaScript console');
};

function getFiles(files) {
  var query_string = {};
  var query = files;//window.location.search.substring(1);
  var vars = query.split("&");
  //console.log(vars[0]);
  for (var i=0;i<vars.length;i++) {
    var pair = vars[i].split("=");
	//console.log(pair[0]);
	//console.log(decodeURIComponent(pair[1]));
    if (typeof query_string[pair[0]] === "undefined") {
      query_string[pair[0]] = decodeURIComponent(pair[1]);
    } else if (typeof query_string[pair[0]] === "string") {
      var arr = [ query_string[pair[0]],decodeURIComponent(pair[1]) ];
      query_string[pair[0]] = arr;
    } else {
      query_string[pair[0]].push(decodeURIComponent(pair[1]));
    }
  }
  return query_string;
}

var QueryString = function () {
  var query_string = {};
  var query = ex.value;//window.location.search.substring(1);
  var vars = query.split("&");
  for (var i=0;i<vars.length;i++) {
    var pair = vars[i].split("=");
    if (typeof query_string[pair[0]] === "undefined") {
      query_string[pair[0]] = decodeURIComponent(pair[1]);
    } else if (typeof query_string[pair[0]] === "string") {
      var arr = [ query_string[pair[0]],decodeURIComponent(pair[1]) ];
      query_string[pair[0]] = arr;
    } else {
      query_string[pair[0]].push(decodeURIComponent(pair[1]));
    }
  }
  return query_string;
}();

if (QueryString.example !== undefined) {
  ex.value = "clingo/run/examples/" + QueryString.example;
  load_example("clingo/run/examples/" + QueryString.example);
  console.log("heeey");
}

