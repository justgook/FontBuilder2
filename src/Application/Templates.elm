module Application.Templates exposing (css, list)

import Ui.Chooser


list : List Ui.Chooser.Item
list =
    [ { label = "CSS", value = css, id = "1" } ]


css : String
css =
    """[data-letter] {
    display: inline-block;
    height: {{fontSize}}px;
    color:red;
    position:relative;
}
[data-letter]::after {
    background-image: url({{base64}});
}
[data-letter=' ']{
   display:inline;
}

[data-letter=' ']::after{
    content: ' ';
    font-size:{{fontSize}}px;
    background-image: none;
}

{{#each glyphs}}


{{#if (compare char "==" "'")}}[data-letter="'"]{{else}}[data-letter='{{char}}']{{/if}}
    {
        width: {{math advanceWidth "-" leftSideBearing}}px;
    }

{{#if (compare char "==" "'")}}[data-letter="'"]::after{{else}}[data-letter='{{char}}']::after{{/if}}
{
    position:absolute;
    content:'';
    display: inline-block;
    width: {{width}}px;
    height: {{height}}px;
    background-position: -{{x}}px -{{y}}px;
    bottom: {{yOffset}}px;
    left: 0;
}
{{/each}}
"""
