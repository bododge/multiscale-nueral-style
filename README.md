# multiscale-nueral-style
# Overview
A companion shell script for automating and creating a series of neural style images starting with a smaller size and cycling the way up through larger sizes, and defining logic for upsizing operation with a few memory saving tricks along the way. This script was inspired by <a href="https://github.com/jcjohnson/neural-style/blob/master/examples/multigpu_scripts/starry_stanford.sh">jcjohnson's example multires script.</a>  The aim of the script is to provide an easy way to control style scale and detail level through multi resolution image generation, by setting a few simple parameters. The script is well documented and makes the most important variables easy to find and edit near the top. There are a ton of notes so it should be easy to modify as needed.


# Requirement
You should have [Neural-Style](https://github.com/jcjohnson/neural-style/) first!


Create a copy of this script in your neural-style directory. 

# Usage
<strong>Usage is drag and drop.</strong> Drag three files into the terminal window, the .sh file followed by two image files:

`multiscale.sh content_file style_file`

Inside the .sh file you will define your starting size, ending size and the total number of images you'd like to generate. The script will evenly size each output over your multiscale session. The script is a loop of commands iterating through each using the output image from the previous, and using a series of if then statements to determine next steps throughout the process. The script creates multiscale and project directories, keeping things neatly organized in their own folder. If you stop to change settings and run again the script will attempt to pick up where you left off. 

There are additional options for adding or subtracting on each step values for style scale, number of iterations, content weight and style weight. Style weight and content weight per step math are set to zero by default. I recommend shrinking style scale by some small amount over the course of the multiscale session. (This adds a sharpening effect, and enables slightly higher sizes - set to zero to disable)
 
 
# What is multiscale-multiscale.sh for?
 An additional version of the script is included that will make multiple image sets with different starting sizes. Just set the length of the loop and your startingPixelMarch var to define how many pixels you'd like the starting pixel size to grow for each phase. I made this mostly for comparison and testing purposes and figured I might as well share it with the main script. I recommend playing with multiscale.sh first.

Here is a quick example series of what can be created with the script. These are the first and last image in a 15 part series. 

<img src="http://i.imgur.com/dIlrNW7.jpg" alt=""/>
<img src="http://i.imgur.com/0TCApCR.jpg" alt=""/>
<img src="http://i.imgur.com/vVURJIM.jpg" alt=""/>
<img src="http://i.imgur.com/fxPJHpY.jpg" alt=""/>

Here is a complete series:
<img src="http://i.imgur.com/dnlTaet.jpg" alt=""/>

Here is an example of what can be created using the multiscale-multiscale.sh

<img src="http://i.imgur.com/btslu3i.jpg" alt=""/>




