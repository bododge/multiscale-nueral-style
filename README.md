# multiscale-nueral-style
# Overview
A companion script for creating a series of neural style images starting with a smaller size and cycling the way up through larger sizes, and defining logic for memory saving tricks along the way. The aim of the script is to provide an easy way to control style scale and detail level through multi resolution controls, while also finding (close to) the top size your machine can create for a given image set and image ratio. The script is well documented and makes the most important variables easy to find and edit near the top.

# Requirement
You should have [Neural-Style](https://github.com/jcjohnson/neural-style/) first!


Create a copy of this script in your neural-style directory. Usage is drag and drop.

`multiscale.sh input_file style_file`


The script is a loop of commands iterating through each using the output image from the previous, and using a series of if then statements to determine next steps in the process. There are a ton of notes in the script itself so it should be easy to modify for other systems and purposes.

Here is an example series of what can be created with the script:

<blockquote class="imgur-embed-pub" lang="en" data-id="dIlrNW7"><a href="//imgur.com/dIlrNW7">View post on imgur.com</a></blockquote><script async src="//s.imgur.com/min/embed.js" charset="utf-8"></script>



<blockquote class="imgur-embed-pub" lang="en" data-id="0TCApCR"><a href="//imgur.com/0TCApCR">View post on imgur.com</a></blockquote><script async src="//s.imgur.com/min/embed.js" charset="utf-8"></script>
