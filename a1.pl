#!C"\strawberry\perl\bin\perl.exe

#Assignment Number: Assignment 1
#Subject Code and Section: BIF724A
#Student Name: Thilukshan Udayakumar
#Student Number: 108796160
#Instructor Name: Danny Abesdris
#Due Date: February/14/2017
#Date Submitted: February/13/2017

#Student Oath:
#All assignments must include the following statement:

#"I declare that the attached assignment is wholly my own work in accordance
#with Seneca Academic Policy. No part of this assignment has been copied
#manually or electronically from any other source (including web sites) or
#distributed to other students."

#Name   Thilukshan Udayakumar   Student ID  TUDAYAKUMAR

#This program creates a 2- dimensional substitution matrix for any 2 strings using the Needleman-Wunsch algorithm.
#The last line returns the alignment score which is the value located in the lower right coordinate of the matrix.


use strict;
use warnings;

my ($s1, $s2, $lengthX, $lengthY, @NWTable, $x, $y, $gapPenalty, $match, $misMatch);
$s1 = "ACTGATTCA";
$s2 = "ACGCATCA";

$match = 1;
$misMatch = -1;
$gapPenalty = -2;
$x = 1; 
$y = 1;

$lengthX = length($s1);
$lengthY = length($s2);

$NWTable[0][0] = 0;


# T(x, y) = maximum of:
#          1. T(x-1, y-1) + S(s1[x], s2[y]) OR...
#          2. T(x-1, y)   + gap penalty     OR...
#          3. T(x, y-1)   + gap penalty

sub createTable($$$$);
sub populateTable($$$$$$$$$$);
sub largestValue($$$);

createTable(\@NWTable, $lengthX, $lengthY, $gapPenalty);
populateTable (\@NWTable, $lengthX, $lengthY, $x, $y, $s1, $s2, $match, $misMatch, $gapPenalty);

for($y= 0; $y<$lengthY+1; $y++ ){
   for($x = 0; $x < $lengthX+1; $x++) {
      print "$NWTable[$y][$x] ";
   }
   print "\n";
}

print ("The alignment score is: $NWTable[$lengthY][$lengthX]");

sub createTable($$$$){
   
   #Initializes table
   
   my($x1, $y1);
   my($tableRef, $lenX, $lenY,$gapPen) = @_;
   for($x1 = 1; $x1 < $lenX + 1; $x1++) {         # fill first row and first column (excluding 0,0) with gapPenalty
      $tableRef->[0][$x1] = $gapPen * $x1;   # because boundaries would cause formula to generate default result
   }
   for($y1 = 1; $y1 < $lenY + 1; $y1++) {
      $tableRef->[$y1][0] = $gapPen * $y1;
   }
}

sub populateTable($$$$$$$$$$){
   my ($tableRef2, $xLength, $yLength, $x2, $y2, $seq1, $seq2, $m1, $mis1, $gp1) = @_;
   my ($diagBox, $leftBox, $topBox);
   if ($y2 > $yLength) {
      print("Table has been populated!\n");
   }
   else{
   
      #Calculates the values diagonal, to the left, and to the right of the current box
      $leftBox = ($tableRef2->[$y2][$x2-1]) + $gp1;
	  $topBox = ($tableRef2->[$y2-1][$x2]) + $gp1;
      
	  if (substr($seq1, $x2-1, 1) eq substr($seq2, $y2-1, 1)){
		 $diagBox = $tableRef2->[$y2-1][$x2-1] + $m1;
      }
      else {
	     $diagBox = $tableRef2->[$y2-1][$x2-1] + $mis1;
      }
	  
	  #Passes the three values into the subroutine to determine the largest value.
	  $tableRef2->[$y2][$x2] = largestValue($diagBox, $leftBox, $topBox);
	  
	  #Checks to see if the end of the row was reached, and if so resets to the start of the next row
	  #If the end of the row was not reached then it moves to the next box
	  if($x2 == $xLength){
	     return populateTable($tableRef2, $xLength, $yLength, $x2=1, $y2+1, $seq1, $seq2, $m1, $mis1, $gp1);
	  }
	  else{
	     return populateTable($tableRef2, $xLength, $yLength, $x2+1, $y2, $seq1, $seq2, $m1, $mis1, $gp1);
	  }
   }
}

sub largestValue($$$){
   my($diaBox, $lefBox, $tpBox) = @_;
   
   #Checks to see which value is greatest and adds that value to the current box
   if (($diaBox >= $lefBox) && ($diaBox >= $tpBox)){
      return ($diaBox);
   }
   elsif (($lefBox >= $tpBox) && ($lefBox >= $diaBox)){
	  return ($lefBox);
   }
   else{
	  return($tpBox);
   }

}

