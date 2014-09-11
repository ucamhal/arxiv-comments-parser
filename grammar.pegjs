{
    var _ = require("lodash");

    function firstAndRest(first, rest) {
        return [first].concat(rest)
    }

    function mergeObjects(objects) {
        return _.partial(_.merge, {}).apply(null, objects);
    }
}

start =
    optws first:sentence rest:(optws s:sentence { return s; })* optws end_of_file
    {
        var sentences = _.compact(firstAndRest(first, rest));
        return mergeObjects(sentences);
    }

sentence =
    journal_sentence / funders_sentence / boring_sentence { return null; }

//==========================
// Journal name & date rules
//==========================
journal_sentence = 
    status:status ws
    ("for"i ws "publication"i ws)?
    ("to"i / "by"i / "in"i) ws
    journal:journal_name tail:journal_sentence_tail
    {
        return _.merge({
            status: status,
            journal: journal
        }, tail);
    }

status =
    term:("accepted"i / "submitted"i)
    { return term.toLowerCase(); }

journal_name =
    first:word rest:(ws !journal_sentence_tail word)* optws
    { return first + _.flatten(rest).join(""); }

journal_sentence_tail =
    date:journal_sentence_date?
    sentence_terminator
    { return date ? { date: date } : {}; }

journal_sentence_date =
    "on"i ws ("the"i ws)?
    day:integer day_suffix? ws month:month ws year:integer
    { return new Date(year, month, day); }

month =
    "jan"i "uary"i? { return 0; } /
    "feb"i "uary"i? { return 1; } /
    "mar"i "ch"i? { return 2; } /
    "apr"i "il"i? { return 3; } /
    "may"i { return 4; } /
    "jun"i "e"i? { return 5; } /
    "jul"i "y"i?  { return 6; } /
    "aug"i "ust"i?  { return 7; } /
    "sep"i "tember"i?  { return 8; } /
    "oct"i "ober"i?  { return 9; } /
    "nov"i "ember"i?  { return 10; } /
    "dec"i "ember"i?  { return 11; }

day_suffix = "st"i / "nd"i / "rd"i / "th"i

integer =
    digits:[0-9]+ { return parseInt(digits.join(""), 10); }

funders_sentence =
    "funded"i ws "by"i ws funders:funder_list optws sentence_terminator
    { return { funders: funders }; }

funder_list =
    first:funder rest:(funder_list_separator optws f:funder { return f; })*
    { return firstAndRest(first, rest); }

funder_list_separator =
    "and"i / ","

funder =
    chars:(!(sentence_terminator / funder_list_separator) c:. { return c; })+
    { return chars.join("").trim(); }

// Boring sentences are just sequences of words from which we infer no meaning.
boring_sentence =
    first:word rest:(ws w:word { return w; })* optws sentence_terminator
    { return firstAndRest(first, rest); }

sentence_terminator =
    optws ("." / end_of_file)

word =
    chars:(!(ws / sentence_terminator) c:. { return c; })+ 
    { return chars.join(""); }

ws =
    [ \t\n\r]+

optws =
    ws?

end_of_file =
    !.