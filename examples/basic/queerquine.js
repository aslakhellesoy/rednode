// print myself *almost* like a quine
var sys = require('sys'),
    fs = require('fs');

sys.puts(fs.readFileSync(__filename));
