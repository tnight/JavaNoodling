import java.util.*; 
/* 
    Implements classic Dining Philosphers Problem 
    There are five philosophers sitting around a table 
    There are five bowls or rice and five chopsticks. 
    To eat a philosopher nust get the chopstick on his left and then 
    get the chopstick on his right. He then takes one bite and puts 
    both down and tries again. 
        The essence of the problem is that the Philosopher requires multiple 
    resources - namely two chopsticks. Having gotten and locked down the left 
    chopstick he then tries to get the right chopstick and keeps trying. Since 
    another philosopher may have locked the right chopstick, the deadlock will 
    never be resolved. 
        The code in getRightChopstick has a potentially infinite loop waiting 
    for the right chopstick to become available. It is easy for developers to 
    look and say 'I would never write such poor code.' . Real cases are much more 
    subtle and do not contain the perhapsYield statements. These statements remind 
    the developer that at any time the system may switch threads and raise this 
    probability to a much higher value. One problem with many deadlock situations 
    is that deadlock occurs only when the thread context is switched in a small, 
    critical interval. These events are subtle and hard to detect. 
        Compared with the previous example, DiningPhilosphers.java this is much more 
    subtle. The synchronized(left) { and synchronized(right) { blocks in 
    the Philosopher's eat method cause the system to loop waiting for the left 
    and right chopsticks to become available. The developer no longer seems the 
    infinite loop but it is still very real. 

*/ 
public class DiningPhilosophers2 
{ 
    static Philosopher[] subjects; 
    static Chopstick[] sticks; 

    // return true if all Philosophers are done 
    // 
    public static boolean allDone() { 
        for(int i = 0; i < Philosopher.MAX_PHILOSOPHER; i++) { 
            if(!subjects[i].isFull()) 
                return(false); 
        } 
         return(true); 
    } 

    // get the chopstick - there is no concept of 
    // unuse - this will be handled by synchronization 
    static public Chopstick  getChopstick(int i) { 
        return(sticks[i]); 
    } 

 public static void main(String args[]) 
 { 
     // initialize philosophers 
        subjects = new Philosopher[Philosopher.MAX_PHILOSOPHER]; 
        for(int i = 0; i < Philosopher.MAX_PHILOSOPHER; i++) 
            subjects[i] = new Philosopher(i); 

     // initialize chopsticks 
        sticks = new Chopstick[Philosopher.MAX_PHILOSOPHER]; 
        for(int i = 0; i < Philosopher.MAX_PHILOSOPHER; i++) 
            sticks[i] = new Chopstick(); 

        Monitor.setTime(); // start monitor 

        // start philosophers 
        for(int i = 0; i < Philosopher.MAX_PHILOSOPHER; i++) 
            subjects[i].start(); 

        // wait until done 
        while(!allDone()); 

        System.out.println("All Done"); 
 } 
} 
  

class Philosopher extends Thread 
{ 
    static final int MAX_PHILOSOPHER = 5; 
    static final int STOMACH_FULL = 20;   // bites needed 
    static Philosopher ActivePhilosopher; // flag to mark active object 
                                          // to control printout 

    int position;      // seat at table 0 .. 4 
    Chopstick left;    // the left chopstick  - if held - else null 
    Chopstick right;   // the right chopstick  - if held- else null 
    boolean   full;    // true if full 
    int       stomach; // number bites consumed 

    // constructor - takes position at table 
    public Philosopher(int pos) { 
        position = pos; 
    } 

    // true if full 
    public boolean isFull() { 
        return(full); 
    } 

    // return positin to the left 
    protected int leftPosition() { 
        if(position > 0) 
            return(position - 1); 
        else 
            return(Philosopher.MAX_PHILOSOPHER - 1); 
    } 

    // return positin to the right 
    int rightPosition() { 
        if(position < Philosopher.MAX_PHILOSOPHER - 1) 
            return(position + 1); 
        else 
            return(0); 
    } 
  

    //  get bite - required right and left chopsticks 
    protected void getBite() { 
        stomach++; 
        if(stomach >= STOMACH_FULL) 
            full = true; 
        if(ActivePhilosopher != this) { 
            ActivePhilosopher = this; 
            System.out.println("Chomp " + position + " bites = " + stomach); 
        } 
    } 
  
  

    // 
    // repeatedly called until full 
    // NOTE - to get deatlock the calls to yield are needed 
    // otherwise the thread switching mechanism is too slow to 
    // switch between getLeftChopstick and getRightChopstick which 
    // is what really causes the deadlock 
    public void eat() 
    { 
        left  = DiningPhilosophers2.getChopstick(leftPosition()); 
        right = DiningPhilosophers2.getChopstick(rightPosition()); 
        // here we lock on the left chopstick - prevent int other use 
        synchronized (left) { 
            perhapsYield(); // context switch can occur at any time 
                            // this increases the probability to make the problem 
                            // more apparent 
            // here we lock on the righ chopstick - prevent int other use 
            synchronized (right) { 
                Monitor.perhapsYield(); // context switch can occur at any time 
                                // this increases the probability to make the problem 
                                // more apparent 
                getBite();      // use resources 
                Monitor.setTime(); // register action 
            } 
        } 
    } 

    // 
    // keep eating until full 
    public void run() 
    { 
        while(!full) { 
            eat(); 
            Thread.yield(); 
        } 
        System.out.println("Done " + position); 
    } 

} 

// 
// model of a limited reasource - once held by one 
// philosopher - the chopstick canot be held by 
// another 
class Chopstick 
{ 
} 

// 
// Singleton Monitor class 
// This thread has a single public method static setTime 
// The first call creates and starts a monitor thread 
// subsequent calls reset the time of last action. 
// if no action has occured after DEADLOCK_TIME seconds, 
// a deadlock is detected 
// 
class Monitor extends Thread 
{ 
    private Calendar    m_LastAction; 
    private Calendar    m_DeadlockTime; 
    private boolean     m_hasDeadlock; 
    public static final int DEADLOCK_TIME = 2; // seconds with no action is deadlock 
    static final double YIELD_PROBABILITY = 0.15; // chances 
    private static Monitor gGlobalMonitor; 

    // constructor 
    // sets singleton instance 
    private Monitor() { 
       setMyTime(); 
       gGlobalMonitor = this; 
    } 

    public static  void perhapsYield() { 
        if(Math.random() < YIELD_PROBABILITY) { 
            Thread.yield(); 
            System.out.println("Yield " + position ); 
        } 
    } 

    // 
    // call to log an action - 
    // first call starts the monitor running 
    public static void setTime() { 
        //if first call create one instance of the class 
        if(gGlobalMonitor == null) { 
            gGlobalMonitor = new Monitor(); 
            gGlobalMonitor.start(); 
        } 
        // set instance time 
        gGlobalMonitor.setMyTime(); 
    } 
    // 
    // log an action - if this function is not called every 
    // DEADLOCK_TIME seconds a deadlock is assumed to exist 
    private synchronized void setMyTime() { 
        // set action time 
        m_LastAction = new GregorianCalendar(); 
        // set deadlock time 
        m_DeadlockTime = new GregorianCalendar(); 
        m_DeadlockTime.add(Calendar.SECOND,DEADLOCK_TIME); 
    } 

    // 
    // test to see is the current time is after the 
    // deadlock timeout time 
    private synchronized boolean testDeadlock() { 
       Calendar now = new GregorianCalendar(); // current time 
       boolean ret = now.after(m_DeadlockTime); 
       if(DiningPhilosophers2.allDone()) 
            return(false); 
       return(ret); 
    } 

    // 
    // called when a deadlock is detected 
    // useful implementations might try to break the deadlock 
    protected void doDeadLock() 
    { 
        if(m_hasDeadlock) 
            return; // already known 

        m_hasDeadlock = true; // only do this once 
        System.out.println("Deadlock!"); 
    } 

    // 
    // keep testing for deadlock 
    public void run() 
    { 
       while(true) { 
            if(testDeadlock()) { 
                doDeadLock(); 
            } 
            Thread.yield(); 
        } 
    } 
// end class Monitor 
} 

