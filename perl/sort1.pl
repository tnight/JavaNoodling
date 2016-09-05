#!/usr/bin/perl -w

$arrayCnt = 0;
$passCnt = 0;
$elementCnt = 0;

@array1 = qw(e c g h z r t a i h j l p b d r q x v a);
@array2 = sort(@array1);

foreach (@array1) {$arrayCnt++;}
print "This is the array Count [$arrayCnt]\n";

while (defined @array1) {

$startPnt = $array1[$passCnt];
$lowValue = $startPnt;

if ($arrayCnt <= $passCnt) {
    print "My sort list [@array1]\n";
    print "A Check Sort [@array2]";
    exit;
}

print "The array as found in loop $passCnt
\t[@array1]\n";
print "The Start point value \t** $startPnt **\t \n";

    foreach (@array1) { 
        if ($elementCnt < $passCnt){
            print "Element Value [ $_ ]\t";
            print "Element Count [$elementCnt]\t Pass
Count [$passCnt]\n";
            shift;
            
        } elsif (($_ lt $lowValue) || ($_ eq
$lowValue)){
              print "Comparing $_ to $lowValue
[Element #$elementCnt]\t";
              $lowValue = $_;
     	      print "Low value [$lowValue]\n";
     	      $lowElement = $elementCnt;
      	} 
     	
    $elementCnt++;
    } #end of foreach
    
    if ($startPnt ne $lowValue) {
        print "This was the low value [$lowValue] and
low element [$lowElement]\n";
        push(@array1,$startPnt); 
        print ("splice()
",splice(@array1,$lowElement,1), "\n");
        $array1[$passCnt] = $lowValue;
        $passCnt++;    
    } else {$passCnt++;}
    
    
} #end of while 
