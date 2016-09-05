// File: IntegerObject.java

// Extremely simple class to store and retrieve an integer

// Written in order to facilitate call by reference on type int



public class IntegerObject {



  private int value;



  // No argument Constructor

  public IntegerObject()

  {value=0;}



  // One argument constructor; Initialize using parameter InitValue

  public IntegerObject(int InitValue)

  {value=InitValue;}



  // Sets (or resets) the value of the object 

  public void SetValue(int N)

  {value = N;}



  // Return the value held by the object

  public int GetValue()

  {return(value);}



  // Compare two IntegerObjects for equality

  public boolean Equals(Object Opnd1,Object Opnd2)

  {if (Opnd1 != null && Opnd2 != null &&

          Opnd1 instanceof IntegerObject && Opnd2 instanceof IntegerObject)

    return (((IntegerObject)Opnd1).GetValue()==

                                       ((IntegerObject)Opnd2).GetValue());

   return(false);

  }



  // Compare two IntegerObjects, true if the first object is bigger

  public boolean GreaterThan(Object Opnd1,Object Opnd2)

  {if (Opnd1 != null && Opnd2 != null &&

          Opnd1 instanceof IntegerObject && Opnd2 instanceof IntegerObject)

    return (((IntegerObject)Opnd1).GetValue()>

                                       ((IntegerObject)Opnd2).GetValue());

   return(false);

  }



  // Compare two IntegerObjects, true if the second object is bigger

  public boolean LessThan(Object Opnd1,Object Opnd2)

  {if (Opnd1 != null && Opnd2 != null &&

          Opnd1 instanceof IntegerObject && Opnd2 instanceof IntegerObject)

    return (((IntegerObject)Opnd1).GetValue()<

                                       ((IntegerObject)Opnd2).GetValue());

   return(false);

  }



  // Increment value by the value of argument IncVal

  public void Increment(int IncVal)

  {value += IncVal;}



}


