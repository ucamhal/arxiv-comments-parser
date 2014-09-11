var Promise = require("promise");
var fs = require("fs");
var PEG = require("pegjs");
var _ = require("lodash");

var grammar = fs.readFileSync("./grammar.pegjs", {encoding: "UTF-8"});
var parser = PEG.buildParser(grammar);

function readStream(stream) {
    return new Promise(function(resolve, reject) {
        var text = "";
        stream.on("data", function(chunk) {
            text += chunk;
        });
        stream.on("error", function(error) {
            reject(error);
        });
        stream.on("end", function() {
            resolve(text);
        });
    });
}

function jsonParse(stream) {
    return readStream(stream).then(JSON.parse);
}

function parseComments(comments) {
    var parsedComments = _.map(comments, function(comment) {
        return {
            comment: comment,
            parsed: parser.parse(comment)
        }
    });

    _.each(parsedComments, function(parsed, i) {
        console.log(parsed.comment);
        console.log(JSON.stringify(parsed.parsed, null, 4));
        
        if (i !== parsedComments.length - 1) {
            console.log("================================================================================");
        }
    })
}

function main() {
    jsonParse(process.stdin).then(function(comments) {
        parseComments(comments);
    },
    function(err) {
        console.error(err);
        process.exit(1);
    });
}

main();
