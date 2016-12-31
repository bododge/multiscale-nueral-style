#!/usr/bin/env bash
#THIS SCRIPT IS LOADED WITH COMMENTS, ECHO STATEMENTS AND VERBOSE VAR NAMES
#HOPEFULLY THIS MAKES IT EASY TO READ AND DEBUG, FEEL FREE TO MAKE YOUR OWN EDITS
########################################################
#PATHS YOU ABSOLTUELY NEED TO CHANGE TO WORK ON YOUR OWN SYSTEM
########################################################
cd /Users/username/Documents/neural-style
#user paths to scripts
userpath="/Users/username/Documents/neural-style/"
neuralStyleFile="neural_style.lua"

########################################################
#SET THE SIZES BELOW TO SUIT YOUR COMPUTER AND PREFERENCE
########################################################
#HOW SMALL SHOULD THE STARTING IMAGE BE? 
startingSize="300"

#HOW LARGE SHOULD THE ENDING IMAGE BE?
endingSize="2800"

#HOW MANY IMAGES WOULD YOU LIKE TO GENERATE AFTER THE INITIAL IMAGE, HOW MANY STEPS SHOULD IT TAKE?
numberOfSteps="5"

#THIS IS THE SIMPLE FORUMULA TO DETERMINE PIXELS PER STEP
stepExpanse=$((endingSize-$startingSize))
addPixelsPerStep=$((stepExpanse / $numberOfSteps))


#SWITCH TO ADAM AT LARGE SIZES TO SAVE MEMORY
switchAdamSize="2600"
echo "When your image size goes to $switchAdamSize or more, you will switch to Adam optimizer to save memory"


########################################################
#BASIC SETTINGS, CONSTANTS
########################################################

# noise fractal seed
seedIt="0"
printIter="10"
saveIter="0"
learningRate="1"

#STYLE SCALE SETTINGS
styleScale=".8"
styleWeight="9500"
contentWeight="800"
numIter="220"

#ABSOLUTE MINIMUM OF ITERATIONS PER FRAME (CATCHES IF/WHEN MATH SLIPS BELOW THIS VALUE)
minimumIters="30"

########################################################
#MATH IS OPTIONAL YOU CAN ADD OR SUBTRACT THESE VALUES ON EVERY STEP, 
#USE VALUES OF ZERO TO KEEP INITIAL CONSTANTS FROM ABOVE UNCHANGED
########################################################
#USE A + or - OPERATOR, SCRIPT IS EXPECTING EITHER - OR + IF YOU LEAVE IT OUT IT WILL BREAK LOGIC
#YOU COULD CHOOSE TO ADD OR SUBTRACT INSTEAD LIKE mathStyleScale="+.015" OR mathStyleWeight="-50"

mathStyleScale="-.011" 
mathStyleWeight="+0"
mathContentWeight="-0"
mathIters="-60"

########################################################
#BACKEND SETTINGS
########################################################
backend="cudnn"
gpu="0"

#LEAVE THIS VAR BLANK TO SKIP MULTIGPU FUNCITONALITTY
multiGpu=" "

#UNCOMMENT THIS LINE TO ENABLE MULTIGPU FUNCTIONALITY
#multiGpu="-gpu 1,0 -multigpu_strategy 8"

#OPTIMIZER VALUES
lbfgsNumCor="20"
mathLbfgsNumCor="-5"
minLbfgsNumCor="1"
defaultOptimizer="lbfgs"

########################################################
#MAIN FUNCTION BEGINS HERE, FIRST FEW STEPS SETUP YOUR DRAG AND DROP VARIABLES I LEARNED THIS METHOD FROM GITHUB USER 0000sir, AND HIS VERY USEFUL 'LARGER-NEURAL-STYLE' -BIGBRUSH TILING SCRIPT.
########################################################

main(){
   # 1. input image
    input=$1
    input_file=`basename $input`
    clean_name="${input_file%.*}"
   
    # 2. Style image
    style=$2
    style_dir=`dirname $style`
    style_file=`basename $style`
    style_name="${style_file%.*}"
    
    #Defines the output directory
    output="multiscale"
	mkdir -p $output

    proj_dir=$output/$clean_name"."$style_name
	mkdir -p $proj_dir

########################################################
#THIS IS WHERE THE LOOP STARTS
########################################################
for i in `seq 1 100`;
do

#GRAB PREVIOUS ITERATION VALUES TO DEFINIE CONTENT AND IMAGE_INIT
DWN2=$((i-2))
DWN=$((i-1))

out_file="$proj_dir/${clean_name}.${style_name}.$i.jpg"
out_file_prev="$proj_dir/${clean_name}.${style_name}.$DWN.jpg"
out_file_prev2="$proj_dir/${clean_name}.${style_name}.$DWN.jpg"

#SERIES OF IF STATEMENTS BELOW WILL ADD CONDITIONALS TO THE LOOP STEP YOU ARE ON
#######################################################
#THESE ARE FRAME/ITERATION NUMBER CHECKS
########################################################
#TEST FOR FRAME 1
  if  [ $i = 1 ]; then
	imageSize="$startingSize"
	out_file_prev2="$1"
	out_file_prev="$1"
	numIter="$numIter"
	optimizer="$defaultOptimizer"
	echo "your frame is #1 and content frame are both equal to $out_file_prev"	
	echo "Your current image size is $imageSize"	
	echo "Your outfile target is $out_file"	
	echo "This is frame #1!!!!"

########################################################
#TEST FOR FRAME 2
elif [ $i = 2 ]; then
#use original content source as init frame
	numIter=$((numIter$mathIters))
	styleWeight=$((styleWeight$mathStyleWeight))
	contentWeight=$((contentWeight$mathContentWeight))
	styleScale=$(echo "scale=3;$styleScale $mathStyleScale" | bc)
	imageSize=$((imageSize+$addPixelsPerStep))
	lbfgsNumCor=$((lbfgsNumCor$mathLbfgsNumCor))

########################################################
#TEST FOR GREATER THAN FRAME 2
#IMAGE WILL BE INITIALIZED ON PREVIOUS ITERATION
#CONTENT IMAGE WILL BE SET ON PREVIOUS ITERATION
elif [ $i -gt 2 ]; then
	out_file_prev="$proj_dir/${clean_name}.${style_name}.$DWN.jpg"
	out_file_prev2="$proj_dir/${clean_name}.${style_name}.$DWN.jpg"
	#uncomment var below to set content image to two iterations ago.
	#out_file_prev2="$proj_dir/${clean_name}.${style_name}.$DWN2.jpg"
	numIter=$((numIter$mathIters))
	styleWeight=$((styleWeight$mathStyleWeight))
	contentWeight=$((contentWeight$mathContentWeight))
	styleScale=$(echo "scale=3;$styleScale $mathStyleScale" | bc)
	imageSize=$((imageSize+$addPixelsPerStep))
	lbfgsNumCor=$((lbfgsNumCor$mathLbfgsNumCor))


########################################################
else
	echo "current iteration count is $i"
fi

########################################################
#MINIMUM numIter TEST
########################################################
if [ $numIter -lt $minimumIters ]; then
	numIter="$minimumIters"
else
	echo "numIter switch not activated"
fi

########################################################
#TEST SIZE BEFORE SWITCHING TO ADAM OPTIMIZER
########################################################
if [ $imageSize -ge $switchAdamSize ]; then
	optimizer="adam"
else
	echo "adam switch not activated"
fi

########################################################
#TEST FOR MAX ENDING SIZE TO DETERMINE IF YOU SHOULD STOP RUNNING THE LOOP
########################################################
if [ $imageSize -gt $endingSize ]; then
	echo "you have already reached your max ending size of $endingSize px"

break

else
	echo "you have not yet reached your max size of $endingSize"
fi


########################################################
#TEST FOR LBFGS NUMCOR RESET TO 1 WHEN APPLICABLE
########################################################
if [ $lbfgsNumCor -lt $minLbfgsNumCor ]; then
	lbfgsNumCor="$minLbfgsNumCor"
else
	echo "you have not activated lbfgsNumCor Value $lbfgsNumCor"
fi


echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "Your starting size is $startingSize, Your ending size is $endingSize"
echo "Your step expanse is $stepExpanse"
echo "Your per pixel step is $addPixelsPerStep over the course of $numberOfSteps resolution changes"
echo "This is STEP #$i"
echo " "
echo " "
echo " "
echo "Your outfile target is $out_file"	
echo "your current style scale is $styleScale"
echo "your current image size is $imageSize px"
echo "your current content weight is $contentWeight"
echo "your current style weight is $styleWeight"
echo "Your current image size is $imageSize pixels"
echo "Your number of neural style iterations is $numIter"
echo "Your lbfgs numCor value is $lbfgsNumCor"
echo "Your current optimizer is $optimizer"
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "

########################################################
#THE ACUTAL NEURAL STYLE COMMAND GETS PRINTED BELOW
########################################################
CMDneural="th $userpath$neuralStyleFile
				-style_image $2 
				-content_image $out_file_prev2
				-init_image $out_file_prev		
				-output_image $out_file
				-gpu $gpu 
				-backend $backend
				-seed $seedIt
				-content_weight $contentWeight 
				-print_iter $printIter 
				-style_weight $styleWeight 
				-learning_rate $learningRate
				-optimizer $optimizer 
				-image_size $imageSize 
				-num_iterations $numIter
				-style_scale $styleScale 
				-save_iter $saveIter
				-normalize_gradients
				-tv_weight 0
				$styleLayers
				-init image
				-lbfgs_num_correction $lbfgsNumCor
				$multiGpu"
    # print command - display to see what your final neural style command was
		echo $CMDneural	
#CHECK TO SEE IF FILE ALREADY EXISTS	
if [ -f $out_file ];
then
########################################################
#SWAPS THE NEURAL STYLE COMMAND FOR A BLANK TO AVOID PROCESSING
########################################################
	CMDneural=" "
	echo "File $out_file already exists skipping ahead to the next iteration, attempting to pick up where you left off"
else
	echo "File $out_file does not exist yet, proceed with style transfer for current iteration."
fi

########################################################
#RUNS THE NEURAL STYLE COMMAND:
########################################################
$CMDneural

########################################################
#FINISHES THE LOOP
########################################################
done
########################################################
#FINISHES MAIN FUNCTION WRAP
}
########################################################
#CALL THE MAIN PROGRAM!
main $1 $2
#LOOK FOR OUTPUT IN THE FOLDER MULTISCALE
