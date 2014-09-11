arXiv comments parser
=====================

This repository contains an example of how we might parse structured data placed in arXiv comments fields without making them appear horribly regular/marked up.

The primary concern is to not make the comments look unnatural. They should read naturally for humans. The secondary concern is that the format is regular enough to be easily parsed.

TODO
----

1. Expose a proper API
2. Compile the pegjs grammar in a npm prepublish script instead of at runtime
3. Name something sensible
4. Change/tweak grammar if the data I'm parsing is not what we need
5. ???
6. Profit

Example
-------

Test parsing a single comment:
```
$> node parser.js "Accepted for publication in bla"
{ status: 'accepted', journal: 'bla' }
{
    "status": "accepted",
    "journal": "bla"
}
```

Test a bunch of comments from a JSON array:
```
$> node test.js < comments.json
Accepted for publication by Astronomy & Astrophysics on the 8th January 1993. 12 pages, Plain
  TeX, no figures
{
    "status": "accepted",
    "journal": "Astronomy & Astrophysics",
    "date": "1993-01-08T00:00:00.000Z"
}
================================================================================
Accepted for publication by Astronomy & Astrophysics on the 8th January 1993. Funded by ABC and DEF. 12 pages, Plain
  TeX, no figures
{
    "status": "accepted",
    "journal": "Astronomy & Astrophysics",
    "date": "1993-01-08T00:00:00.000Z",
    "funders": [
        "ABC",
        "DEF"
    ]
}
================================================================================
submitted to Astronomy & Astrophysics. 12 pages, Plain
  TeX, no figures
{
    "status": "submitted",
    "journal": "Astronomy & Astrophysics"
}
================================================================================
Submitted for publication in Astronomy & Astrophysics. 12 pages, Plain
  TeX, no figures
{
    "status": "submitted",
    "journal": "Astronomy & Astrophysics"
}
================================================================================
Blah blah, this is my comment. Submitted for publication in Astronomy & Astrophysics on 6 June 1666. 12 pages, Plain
  TeX, no figures. Funded by some bloke I met in a pub and my mum
{
    "status": "submitted",
    "journal": "Astronomy & Astrophysics",
    "date": "1666-06-05T23:00:00.000Z",
    "funders": [
        "some bloke I met in a pub",
        "my mum"
    ]
}
================================================================================
Nothing of interest will be found in this comment. Shame.
{}
================================================================================
The last list of funders specified will be used. Funded by abc. Funded by def.
{
    "funders": [
        "def"
    ]
}
================================================================================
Similarly, the last publication info will be used. Submitted to The Journal of Foo. Accepted for publication in The Journal of Bar on the 21nd July 1893.
{
    "status": "accepted",
    "journal": "The Journal of Bar",
    "date": "1893-07-20T23:00:00.000Z"
}
```