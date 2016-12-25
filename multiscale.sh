#!/usr/bin/env bash
#THIS SCRIPT IS LOADED WITH COMMENTS AND ECHO STATEMENTS AND VERBOSE VAR NAMES
#HOPEFULLY THIS MAKES IT EASY TO READ AND DEBUG,FEEL FREE TO MAKE YOUR OWN EDITS
########################################################
#PATHS YOU ABSOLTUELY NEED TO CHANGE TO WORK ON YOUR OWN SYSTEM
########################################################
cd /Users/username/Documents/Deepstyler/neural-style
#user paths to scripts
userpath="/Users/username/Documents/Deepstyler/neural-style/"
neuralStyleFile="neural_style.lua"

########################################################
#VARS YOU SHOULD CHANGE TO SUIT YOUR OWN NEEDS AND TASTES ARE BELOW
########################################################
backend="nn"
gpu="0"

#LEAVE THIS VAR BLANK TO SKIP MULTIGPU FUNCITONALITTY
multiGpu=" "

#UNCOMMENT THIS LINE TO ENABLE MULTIGPU FUNCTIONALITY
#multiGpu="-gpu 0,1 -multigpu_strategy 9"

########################################################
#PIXEL SIZE VALUES
########################################################
#STARTING SIZE HAS A HUGE EFFECT ON FINAL OUTPUT'S OVERALL STYLE SCALE, SET YOUR PREFERENCE BELOW
startingSize="550"

#SET SMALLSIZE TO AN IMAGE SIZE LOWER THAN YOU ARE SURE YOU CAN REACH
smallSize="1330"

#SET MEDIUMSIZE TO AN IMAGE SIZE YOU WILL PROBABLY REACH
mediumSize="1550"

#SET LARGESIZE THINK OF THIS AS A NEAR RANGE FINISHING VALUE YOU'D LIKE TO REACH BUT MIGHT NOT
largeSize="1800"

#SET XLARGESIZE TO A TARGET THAT WILL END OR BREAK THE LOOP TO END YOUR MULTISCALE SESSION
xlargeSize="2000"

#ADDED TO EACH STEP TO INCREASE SIZE
addPixelsPerStep="200"

#SUBTRACTED FROM MEDIUM-LARGE SIZES TO SLOW PER STEP GROWTH
subtractPixelsPerStep="100"

#SUBTRACTED FROM LARGE SIZES TO SLOW PER STEP GROWTH, SMALLER STEPS MEANS BETTER COHERENCY, LESS NOISE
subtractMorePixelsPerStep="50"
subtractEvenMorePixelsPerStep="15"

########################################################
#ITERATION VALUES & OPTIMIZER VALUES
########################################################
startingIters="200"

#SET VAR BELOW TO ZERO TO NULLIFY ITER SUBTRACTION
subtractItersPerStep="50"

#ABSOLUTE MINIMUM OF ITERATIONS PER FRAME, MORE ITERATIONS MAY ADD NOISE ON LARGER SIZES
minimumIters="30"

#OPTIMIZER VALUES
lbfgsNumCor="20"
lbfgsNumCorSubtract="5"
minLbfgsNumCor="1"

########################################################
#BASIC SETTINGS
########################################################
# noise fractal seed
seedIt="0"
defaultOptimizer="lbfgs"

#SWITCH TO ADAM AT LARGE SIZES TO SAVE MEMORY
memorySaveOptimizer="adam"
printIter="10"
saveIter="0"
styleWeight="7500"
contentWeight="800"
learningRate=".5"

#STYLE SCALE SETTINGS
initialstyleScale=".8"

#SHRINKING STYLE SCALE SLOWLY BY SUBTRACTING VALUE BELOW EVERYTIME, INSTEAD OF ALL AT ONCE OR NOT AT ALL
#JUST ZERO OUT subtractstyleScale TO DISABLE AND KEEP A CONSTANT VALUE OF initialstyleScale
#SETTING TO A LARGER NUMBER BELOW MAY SAVE MEMORY, ADD A FURTHER SHARPENING EFFECT, OR ADD UNWANTED NOISE
subtractstyleScale=".014"

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

#SERIES OF IF STATEMENTS BELOW WILL ADD CONDITIONALS TO THE LOOP STEP YOU ARE ON
#######################################################
#THESE ARE FRAME/ITERATION NUMBER CHECKS
########################################################
#TEST FOR FRAME 1
  if  [ $i = 1 ]; then
	imageSize="$startingSize"
	out_file_prev2="$1"
	out_file_prev="$1"
	numIter="$startingIters"
	imageSize=$((startingSize-$addPixelsPerStep))
	numIter=$((numIter+$subtractItersPerStep))
	optimizer="$defaultOptimizer"
	echo "your frame is #1 and content frame are both equal to $out_file_prev"	
	echo "Your current image size is $imageSize"	
	echo "Your outfile target is $out_file"	
	echo "This is frame #1!!!!"

########################################################
#TEST FOR FRAME 2
elif [ $i = 2 ]; then
#use original content source as init frame
	echo "Your current image size is $imageSize pixels"
	echo "Your outfile target is $out_file"	

########################################################
#TEST FOR GREATER THAN FRAME 2
#IMAGE WILL BE INITIALIZED ON PREVIOUS ITERATION
#BUT THIS SETTING IS CONTENT IMAGE TO TWO PREVIOUS ITERATIONS AGO TO AVOID SOME NOISE
elif [ $i -gt 2 ]; then
	out_file_prev2="$proj_dir/${clean_name}.${style_name}.$DWN2.jpg"
	echo "Your current frame is greater than 2"	
########################################################
else
	echo "current iteration count is $i"
fi
	echo "Your current image size is $imageSize pixels"
	echo "Your outfile target is $out_file"	

########################################################
#THESE ARE IMAGE SIZE CHECKS
########################################################
#CHECK SMALL TO MEDIUM SIZES
if [ $imageSize -le $smallSize ]; then
echo "size is less than $smallSize"

	lbfgsNumCor=$((lbfgsNumCor-$lbfgsNumCorSubtract))
	imageSize=$((imageSize+$addPixelsPerStep))
	styleScale="$initialstyleScale"
	styleScale=$(echo "scale=3;$styleScale -$subtractstyleScale" | bc)
	echo "adding $addPixelsPerStep to the image size here"
	echo "adding ^^^ to the image size here"
	echo "adding ^^^ to the image size here"
	echo "adding ^^^ to the image size here"
	echo "except during frame 1"
	echo "Your current image size is $imageSize pixels"
	echo "Your current style scale is $styleScale"	
	echo "Your outfile target is $out_file"	
	numIter=$((numIter-$subtractItersPerStep))

########################################################
#CHECK MEDIUM TO LARGE SIZES
elif [ $imageSize -le $mediumSize ]; then
	echo "size is less than $mediumSize"
	imageSize=$((imageSize+$addPixelsPerStep))
	imageSize=$((imageSize-$subtractPixelsPerStep))
	lbfgsNumCor="$minLbfgsNumCor"
	numIter="$minimumIters"
	styleScale=$(echo "scale=3;$styleScale -$subtractstyleScale" | bc)
	echo "substracting $subtractPixelsPerStep from the image size here"
	echo "substracting ^^ from the image size here"
	echo "substracting ^^ from the image size here"
	echo "substracting ^^ from the image size here"
	echo "Your current image size is $imageSize pixels"
	echo "Your current style scale is $styleScale"	
	echo "Your outfile target is $out_file"
	echo "Switching your optimizer method to adam to save memory"
	optimizer="$memorySaveOptimizer"

########################################################
#CHECK LARGE SIZES AND BEYOND
elif [ $imageSize -le $largeSize ]; then
	echo "size is larger than $largeSize"
	imageSize=$((imageSize+$addPixelsPerStep))
	imageSize=$((imageSize-$subtractPixelsPerStep))
	imageSize=$((imageSize-$subtractMorePixelsPerStep))
	numIter="$minimumIters"
	styleScale=$(echo "scale=3;$styleScale -$subtractstyleScale" | bc)
	echo "substracting 35 from the image size here"
	echo "substracting ^^ from the image size here"
	echo "substracting ^^ from the image size here"
	echo "substracting ^^ from the image size here"
	echo "Your current image size is $imageSize pixels"
	echo "Your current style scale is $styleScale"	
elif [ $imageSize -le $xlargeSize ]; then
	echo "size is larger than $largeSize"
	imageSize=$((imageSize+$addPixelsPerStep))
	imageSize=$((imageSize-$subtractPixelsPerStep))
	imageSize=$((imageSize-$subtractMorePixelsPerStep))
	imageSize=$((imageSize-$subtractEvenMorePixelsPerStep))
	numIter="$minimumIters"
	#SWITCHING TO FEWER STYLE LAYERS TO SAVE MEMORY
	ghostVar="-style_layers relu1_1,relu2_1,relu3_1,relu4_1"
	styleScale=$(echo "scale=3;$styleScale -$subtractstyleScale" | bc)
	echo "substracting 35 from the image size here"
	echo "substracting ^^ from the image size here"
	echo "substracting ^^ from the image size here"
	echo "substracting ^^ from the image size here"
	echo "Your current image size is $imageSize pixels"
	echo "Your current style scale is $styleScale"	
 
########################################################
#CHECK XLARGE SIZES AND BEYOND
elif [ $imageSize -le $xlargeSize ]; then
	echo "size is larger than $largeSize"
	imageSize=$((imageSize+$addPixelsPerStep))
	imageSize=$((imageSize-$subtractPixelsPerStep))
	imageSize=$((imageSize-$subtractMorePixelsPerStep))
	imageSize=$((imageSize-$subtractEvenMorePixelsPerStep))
	numIter="$minimumIters"
	styleScale=$(echo "scale=3;$styleScale -$subtractstyleScale" | bc)
	echo "substracting 35 from the image size here"
	echo "substracting ^^ from the image size here"
	echo "substracting ^^ from the image size here"
	echo "substracting ^^ from the image size here"
	echo "Your current image size is $imageSize pixels"
	echo "Your current style scale is $styleScale"	
	#SWITCHING TO EVEN FEWER STYLE LAYERS TO SAVE MORE MEMORY
	ghostVar="-style_layers relu2_1,relu3_1,relu4_1"
else
	break
	echo "Your current image size is $imageSize pixels"
fi

########################################################
#MINIMUM numIter TEST
########################################################
if [ $numIter -lt $minimumIters ]; then
numIter="$minimumIters"
	echo "Your minimum number of iterations is now $minimumIters"
	echo "Your number of neural style iterations is $numIter"	
else
	echo "Your numIters has not fallen below $minimumIters and will instead use previous logic"
	echo "Your number of neural style iterations is $numIter"	
fi

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
				$ghostVar
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
}

########################################################
#CALL THE MAIN PROGRAM!
main $1 $2
#LOOK FOR OUTPUT IN THE FOLDER MULTISCALE
