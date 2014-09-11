var minimist = require("minimist");
var fs = require("fs");
var PEG = require("pegjs");

var grammar = fs.readFileSync("./grammar.pegjs", {encoding: "UTF-8"});
var parser = PEG.buildParser(grammar);

function main() {
    var args = minimist(process.argv.slice(2));

    if (args._.length !== 1) {
        console.error("Error: one argument expected");
        process.exit(1);
    }

    var comment = args._[0];

    try {
        var result = parser.parse(comment);
        console.dir(result);
        console.log(JSON.stringify(result, null, 4));
    }
    catch(e) {
        console.dir(e);

        console.error("\nPosition:")
        console.error(comment.replace("\n", "␤").replace("\r", "␍"));
        console.error(new Array(e.offset + 1).join(" ") + "^");
    }
}

main();
