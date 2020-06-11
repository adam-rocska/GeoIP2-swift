# Future Plans

This document describes what backwards incompatible break are planned for a next
major release. _I must clarify, that I do realize how outrageously stupid it may
sound like to plan for a breaking change befor the first initial version's 
release, but hey, there's a time pressure on my shoulder right now + MaxMind's 
"binary format" "desgined" by its script kiddos slowed things down baadly._

## Error handling

There used to be an original concept of how to do proper error handling & 
exception case coverage, however due to the 3 rewrites forced by the poor "design"
of the maxmind binary format didn't leave me enough time to do it properly.
Therefore, at the time of writing whenever something goes off, you get a nil. That 
makes my enterprise originated soul cry for a whiskey. Or a pálinka.

What I want is to design either an enum based exception case communication & 
coverage, either a thrown error based one.

## Eliminate retarded type casting jungle

I know I made a retarded type casting jungle, especially for numeric types. I 
know it's horrible, and I honestly feel ashamed for it. To my excuse, most of it
was explicitly or implicitly forced by MaxMindDB's binary spec. I'm sure it can
be done way better, and/or smarter. But purely out of the spec' this is what I 
managed to pull out. Even their library implementations don't respect the spec.
For example if you get **128bit unsigned int index pointers**, you'll face quite a 
bit of fun.

I'll do my best to massage things out. Once the public API is stable, and neat,
the underlying crap can be cleaned up.

## Redesign the retarded modeling

At the library's initial stage the decision was to reproduce in a somewhat 
similar state what MaxMind's php scritpers made with their PHP, Java, and C# 
libraries. 

That modeling is awful.

The way the API will return models will definitely change, so there will be a 
2.0.0 API break at some point.