# multiscale-nueral-style
# Overview
A companion script for creating a series of neural style images starting with a smaller size and cycling the way up through larger sizes, and defining logic for upsizing operation with a few memory saving tricks along the way. The aim of the script is to provide an easy way to control style scale and detail level through multi resolution controls, while also finding (close to) the top size your machine can create for a given image set and image ratio. The script is well documented and makes the most important variables easy to find and edit near the top.

# Requirement
You should have [Neural-Style](https://github.com/jcjohnson/neural-style/) first!


Create a copy of this script in your neural-style directory. 

<strong>Usage is drag and drop.</strong> Drag three files into the terminal window, the .sh file followed by two image files:

`multiscale.sh content_file style_file`


The script is a loop of commands iterating through each using the output image from the previous, and using a series of if then statements to determine next steps throughout the process. The script creates multiscale and project directories, keeping things neatly organized in their own folder. There are a ton of notes in the .sh script so it should be easy to modify as needed.

Here is a quick example series of what can be created with the script. These are the first and last image 15 part series. 

<img src="http://i.imgur.com/dIlrNW7.jpg" alt=""/>
<img src="http://i.imgur.com/0TCApCR.jpg" alt=""/>
<img src="http://i.imgur.com/vVURJIM.jpg" alt=""/>
<img src="http://i.imgur.com/fxPJHpY.jpg" alt=""/>
