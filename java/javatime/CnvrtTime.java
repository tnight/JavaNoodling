// File: CnvrtTime
// Convert a Number of Seconds to Weeks, Days, Hours, Minutes and Seconds
import java.io.* ;

public class CnvrtTime
{
 static int ReadInt() throws java.io.IOException
 {int Total=0,Sign=1;
  int Digit;
  // Eat Blanks
  while ((Digit=System.in.read())<=32);
  // Check for - sign
  if (Digit=='-')
   Sign=-1;
  else if (Digit>='0' && Digit<='9')
   Total=Digit-48;
  else return(-1);
  Digit=System.in.read();
  while (Digit>='0' && Digit<='9') {
   Total=(Total*10)+Digit-48;
   Digit=System.in.read();
  }
  return(Total*Sign);
 }
 
 static void Convert(IntegerObject OldUnits,IntegerObject NewUnits,
                                                int ConversionFactor)
 {NewUnits.SetValue(OldUnits.GetValue()/ConversionFactor);
  OldUnits.SetValue(OldUnits.GetValue()%ConversionFactor);
 }
 
 public static void main(String[] args) throws java.io.IOException
 {int SecondsToMinutes=60,
      MinutesToHours=60,
      HoursToDays=24,
      DaysToWeeks=7;
  IntegerObject Seconds=new IntegerObject(),
                Minutes=new IntegerObject(),
                Hours=new IntegerObject(),
                Days=new IntegerObject(),
                Weeks=new IntegerObject();
  System.out.print("Enter a Number of Seconds >");
  System.out.flush();
  Seconds.SetValue(ReadInt());
  System.out.print(Seconds.GetValue()+" Seconds is ");
  Convert(Seconds,Minutes,SecondsToMinutes);
  Convert(Minutes,Hours,MinutesToHours);
  Convert(Hours,Days,HoursToDays);
  Convert(Days,Weeks,DaysToWeeks);
  System.out.println(Weeks.GetValue()+" Weeks "+Days.GetValue()+" Days "+
                Hours.GetValue()+" Hours "+Minutes.GetValue()+" Minutes "+
                                               Seconds.GetValue()+" Seconds");
 } // End of Main Method
 
}// End of class


