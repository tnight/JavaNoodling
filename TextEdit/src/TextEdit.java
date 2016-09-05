///////////////////////////////////////////////////////////////
// Program: TextEdit.java
//  Author: Anil Hemrajani
//          anil@patriot.net
//          http://www.patriot.net/users/anil/
// Purpose: Sample Text Editor Java application/applet written
//          to demo the capabilities of java.awt and some of
//          java.net, java.applet and java.io.
///////////////////////////////////////////////////////////////

import java.io.*;
import java.awt.*;
import java.net.*;
import java.applet.Applet;


//**********************************
//* This class provides the Applet
//**********************************
public class TextEdit extends Applet
{
   // Data members
   static    TextFrame appFrame=null;
   Toolkit   toolKit=Toolkit.getDefaultToolkit();
   TextArea  taText;
   TextField tURL;
   Choice    cFontNames, cFontSizes;
   Checkbox  cbItalic, cbBold;
   Label     statusBar;
   static    String MI_NEW="New",
                    MI_OPEN="Open...",
                    MI_SAVE="Save",
                    MI_SAVEAS="Save As...",
                    MI_URLREAD="Read URL",
                    MI_URLWRITE="Write URL",
                    MI_URLSHOW="Show URL",
                    MI_EXIT="Exit",
                    DEF_FNAME="Courier",
                    DEF_FSIZE="12",
                    NEW_FILE="untitled.txt";
   StringBuffer currFile=null, currURL=null;
   boolean inAnApplet=true, Edited=false, showStatusMsgInBrowser=true;
   Panel topPanel, fontPanel, buttonPanel;
   Image iconImage = null;

   // "main" invoked when run as an application
   public static void main(String args[])
   {
      if (args.length > 0)
        appFrame=new TextFrame(new TextEdit(), args[0]);
      else
        appFrame=new TextFrame(new TextEdit(), null);
   }

   // "init" invoked automatically when run as an
   // applet or if directly called by another class
   public void init()
   {
       // Initialize variables
       currFile  = new StringBuffer(NEW_FILE);
       currURL   = new StringBuffer();

       // Play welcome message if file exists
       // and we are in an Applet.  Also, get
       // pretty app image.
       /*
       if (inAnApplet)
       {
           iconImage=getImage(getCodeBase(), "textedit.gif");
           play(getCodeBase(), "textedit.au");
       }
       else
           iconImage=toolKit.getImage("textedit.gif");
       */

       // List of Font Names
       cFontNames = new Choice();
       for (int i=0; i < toolKit.getFontList().length; i++)
           cFontNames.addItem(toolKit.getFontList()[i]);
       cFontNames.select(DEF_FNAME);

       // List of Font Sizes
       cFontSizes = new Choice();
       cFontSizes.addItem("8");
       cFontSizes.addItem("10");
       cFontSizes.addItem("12");
       cFontSizes.addItem("14");
       cFontSizes.addItem("18");
       cFontSizes.addItem("24");
       cFontSizes.addItem("48");
       cFontSizes.select(DEF_FSIZE);

       // Checkboxes for Bold/Italic Control
       cbBold = new Checkbox("Bold");
       cbItalic = new Checkbox("Italic");
       cbBold.setState(false);
       cbItalic.setState(false);

       // Font Tool Bar
       fontPanel = new Panel();
       fontPanel.setLayout(new FlowLayout(FlowLayout.LEFT,1,0));
       fontPanel.add(cFontNames);
       fontPanel.add(cFontSizes);
       fontPanel.add(cbBold);
       fontPanel.add(cbItalic);

       // URL Panel
       Panel urlPanel = new Panel();
       GridBagLayout gb = new GridBagLayout();
       GridBagConstraints gbc = new GridBagConstraints();
       urlPanel.setLayout(gb);
       gbc.fill  = GridBagConstraints.HORIZONTAL;
       gbc.ipadx = 5;

       Label   l = new Label("URL:", Label.LEFT);
       gb.setConstraints(l, gbc);
       urlPanel.add(l);

       tURL = new TextField(65);
       gbc.gridwidth = GridBagConstraints.RELATIVE;
       gbc.weightx = 1.0;
       gb.setConstraints(tURL, gbc);
       urlPanel.add(tURL);

       /* Show pretty image
       LoadImag img = new LoadImag(iconImage, 48, 48);
       gbc.gridwidth = GridBagConstraints.REMAINDER;
       gbc.weightx = 0.0;
       gb.setConstraints(img, gbc);
       urlPanel.add(img); */

       // Push Button Tool Bar
       buttonPanel = new Panel();
       buttonPanel.setLayout(new GridLayout(1,7));
       buttonPanel.add(new Button(MI_NEW));
       buttonPanel.add(new Button(MI_OPEN));
       buttonPanel.add(new Button(MI_SAVE));
       buttonPanel.add(new Button(MI_SAVEAS));
       buttonPanel.add(new Button(MI_URLREAD));
       buttonPanel.add(new Button(MI_URLWRITE));
       if (!inAnApplet)
           buttonPanel.add(new Button(MI_EXIT));
       else
           buttonPanel.add(new Button(MI_URLSHOW));

       // Top of screen panel
       topPanel=new Panel();
       topPanel.setLayout(new BorderLayout(1, 0));
       topPanel.add("North",  urlPanel);
       topPanel.add("Center", buttonPanel);
       topPanel.add("South",  fontPanel);

       // Text Editing Area (20 rows x 80 cols)
       taText = new TextArea(18, 80);

       // Status Bar
       statusBar = new Label(NEW_FILE, Label.LEFT);

       // Add Panels to Applet (a Panel itself)
       setLayout(new BorderLayout(1, 0));
       add("North",  topPanel);
       add("Center", taText);
       add("South",  statusBar);

       setTextFont();
   }

   // Set padding for fill3DRect() in paint()
   public Insets insets()
   {
       return new Insets(4, 4, 4, 4);
   }

   public void paint(Graphics g)
   {
       // Draw a 3D line below menu bar
       if (!inAnApplet)
       {
           g.setColor(getBackground());
           g.fill3DRect(0, 0, size().width, 2, false);
       }
       else
           g.draw3DRect(0, 0, size().width-1, size().height-1, false);
   
       /* Set Checkbox font to match it's function
       cbBold.setFont(new Font(cbBold.getFont().getName(),
                            Font.BOLD,
                            cbBold.getFont().getSize()));
       cbItalic.setFont(new Font(cbItalic.getFont().getName(),
                            Font.ITALIC,
                            cbItalic.getFont().getSize()));
       */
       // Always set cursor in text area
       taText.requestFocus();
   }

   public boolean handleEvent(Event evt)
   {
       if (evt.id == Event.WINDOW_DESTROY)
           terminate(0);
       else
       if (evt.id == Event.ACTION_EVENT)
       {
          statusMsg("");

          // Font name, style or size change
          if (evt.target instanceof Choice ||
              evt.target instanceof Checkbox)
              setTextFont();

          else
          // Button or Menu item selected
          if (evt.target instanceof Button ||
              evt.target instanceof MenuItem)
          {
            String menuLabel = (String)evt.arg;

            if (menuLabel.equals(MI_URLREAD))
            {
                try { readFile(new URL(tURL.getText())); }
                catch (MalformedURLException e)
                { showCatchError(e); }
            }

            else
            if (menuLabel.equals(MI_URLWRITE))
            {
                try { writeFile(new URL(tURL.getText())); }
                catch (MalformedURLException e)
                { showCatchError(e); }
            }

            else
            if (menuLabel.equals(MI_URLSHOW) && inAnApplet)
            {
                statusMsg("Please wait...");
                try { getAppletContext().showDocument(
                    new URL(tURL.getText())); }
                catch (MalformedURLException e)
                { showCatchError(e); }
                finally { statusMsg(""); }
            }

            else
            if (menuLabel.equals(MI_OPEN))
            {
               saveWarning();
               DoFileDialog fd;

               try 
               {
                   if (inAnApplet)
                   {
                       disable(); // Simulate modality
                       fd = new DoFileDialog(null,
                                    "Open a File");
                   }
                   else
                       fd = new DoFileDialog(appFrame,
                                  "Open a File");

                   if (fd.getPath() != null)
                       readFile(fd.getPath());
               }
               catch (AWTError e)
               { showCatchError(e);
                 if (inAnApplet)
                     statusMsg(e.toString() +
                      "  (probably due to security restrictions)");
               }
               finally
               {
                 if (inAnApplet)
                     enable();
               }
            }

            else
            if (menuLabel.equals(MI_SAVEAS))
            {
               saveWarning();
               DoFileDialog fd;

               try 
               {
                   if (inAnApplet)
                   {
                       disable(); // Simulate modality
                       fd = new DoFileDialog(null,
                                  "Save File As",
                                   FileDialog.SAVE);
                   }
                   else
                       fd = new DoFileDialog(appFrame,
                                  "Save File As",
                                  FileDialog.SAVE);
                   if (fd.getPath() != null)
                       writeFile(fd.getPath());
               }
               catch (AWTError e)
               { showCatchError(e);
                 if (inAnApplet)
                     statusMsg(e.toString() +
                      "  (probably due to security restrictions)");
               }
               finally
               {
                 if (inAnApplet)
                     enable();
               }
            }

            else
            if (menuLabel.equals(MI_SAVE))
                writeFile(currFile.toString());
            else
            if (menuLabel.equals(MI_NEW))
                newFile();
            else
            if (menuLabel.equals(MI_EXIT))
               terminate(0);
          }

          taText.requestFocus();
          return true;
       }

       else
       if (evt.target instanceof TextArea)
       {
          if (evt.id == Event.KEY_PRESS)
              Edited=true;
       }

       return false;
   }

   protected void setTextFont()
   {
       // Set TextArea to requested font
       Integer i=new Integer(cFontSizes.getSelectedItem());
       int style = Font.PLAIN;

       if (cbBold.getState() == true)
           style |= Font.BOLD;
       if (cbItalic.getState() == true)
           style |= Font.ITALIC;

       taText.setFont(new Font(cFontNames.getSelectedItem(),
                           style, i.intValue()));
   }

   protected void newFile()
   {
       saveWarning();
       // Clear screen for new file
       taText.setText("");
       currFile.setLength(0);
       currFile.append(NEW_FILE);
       statusMsg(NEW_FILE);
   }

   // Read a local file
   protected void readFile(String filename)
   {
      saveWarning();

      statusMsg("Please wait...");
      try
      {
          new ReadFile(filename, taText);
          currFile.setLength(0);
          currFile.append(filename);
          statusMsg(currFile.toString());
      }
      catch (FileNotFoundException e)
      { showCatchError(e); }
      catch (IOException e)
      { showCatchError(e); }
      finally
      {
        statusMsg("");
      }
   }

   // Write to local file
   protected void writeFile(String filename)
   {
      statusMsg("Please wait...");
      try 
      {  
          new WriteFile(filename, taText);
          currFile.setLength(0);
          currFile.append(filename);
          statusMsg(currFile.toString());
          Edited=false;
      }
      catch (IOException e)
      { showCatchError(e); }
      finally
      { statusMsg("");}
   }

   // Read from an Internet resource
   protected void readFile(URL location)
   {
      saveWarning();

      statusMsg("Please wait...");
      try
      {
          new ReadFile(location, taText);
          statusMsg(location.toString());
      }
      catch (MalformedURLException e)
      { showCatchError(e); }
      catch (IOException e)
      { showCatchError(e); }
      finally
      { statusMsg("");}
   }

   // Write to an Internet resource
   protected void writeFile(URL location)
   {
      statusMsg("Please wait...");
      try 
      {  
          // Save requested file
          new WriteFile(location, taText);
          statusMsg(location.toString());
          Edited=false;
      }
      catch (MalformedURLException e)
      { showCatchError(e); }
      catch (IOException e)
      { showCatchError(e); }
      finally
      { statusMsg("");}
   }

   protected void statusMsg(String msgText)
   {
       statusBar.setText(msgText);
       if (inAnApplet && showStatusMsgInBrowser)
           showStatus(msgText);
   }
   
   protected void showCatchError(Throwable e)
   {
       statusMsg(e.toString());
       if (inAnApplet)
           showStatus(e.getMessage());
       else
           System.err.println(e.getMessage());
   }


   protected void saveWarning()
   {
       if (Edited == true)
           ;  // Add warning message here later
       Edited=false;
   }

   protected void terminate(int rc)
   {
       saveWarning();
       topWindow().dispose();
   }
   protected Window topWindow() {
     Container parent = getParent();
     while (! (parent instanceof Window))
       parent = parent.getParent();
     return (Window)parent;
   }
}


//**************************************
//* This provides a frame for the Applet
//**************************************
class TextFrame extends Frame
{
   TextEdit teApplet;

   public TextFrame(TextEdit t,
                    String openWithFile)
   {
       setTitle("Text Editor");
       teApplet=t;

       // Build File Menu
       Menu fm  = new Menu("File");
       fm.add(new MenuItem(TextEdit.MI_NEW));
       fm.add(new MenuItem(TextEdit.MI_OPEN));
       fm.add(new MenuItem(TextEdit.MI_SAVE));
       fm.add(new MenuItem(TextEdit.MI_SAVEAS));
       fm.add(new MenuItem(TextEdit.MI_URLREAD));
       fm.add(new MenuItem(TextEdit.MI_URLWRITE));
       fm.addSeparator();
       fm.add(new MenuItem(TextEdit.MI_EXIT));

       // Add Menu Bar and Menu to Frame
       MenuBar mb = new MenuBar();
       mb.add(fm);
       setMenuBar(mb);

       teApplet.inAnApplet=false;
       // Call init() method as a browser would
       teApplet.init();
       add("Center", teApplet);

       // Open a file if requested
       if (openWithFile != null)
           teApplet.readFile(openWithFile); 

       pack();
       show();
   }

   public boolean handleEvent(Event evt)
   {
       // Forward all events to Applet class
       if (teApplet != null)
           return teApplet.handleEvent(evt);

       return super.handleEvent(evt);
   }
}


//************************************************
//* This loads a local file or URL into a TextArea
//************************************************
class ReadFile
{
   StringBuffer sb = new StringBuffer();

   ReadFile(String FileName, TextArea taText)
      throws IOException,
             FileNotFoundException
   {
      FileInputStream fis;
      sb = new StringBuffer();

      fis = new FileInputStream(FileName);
      int oneChar;

      while ((oneChar=fis.read()) != -1)
            sb.append((char)oneChar);
      fis.close();
      taText.setText(sb.toString());
   }


   ReadFile(URL location, TextArea taText)
      throws MalformedURLException,
             IOException
   {
      InputStream is = location.openStream();
      int oneChar;
      sb = new StringBuffer();

      while ((oneChar=is.read()) != -1)
         sb.append((char)oneChar);
      is.close();
      taText.setText(sb.toString());
   }
}


//****************************************************
//* This writes to a local file or URL from a TextArea
//****************************************************
class WriteFile
{
   StringBuffer sb;

   WriteFile(String FileName, TextArea taText)
      throws IOException
   {
      FileOutputStream fos;
      sb = new StringBuffer();
      sb.append(taText.getText());
      int i;

      fos = new FileOutputStream(FileName);
      for (i=0; i < sb.length(); i++)
           fos.write(sb.charAt(i));
      fos.close();
   }


   WriteFile(URL location, TextArea taText)
      throws MalformedURLException,
             IOException
   {
      URLConnection urlConnect = location.openConnection();
      urlConnect.setDoOutput(true);

      OutputStream os = urlConnect.getOutputStream();

      sb = new StringBuffer();
      sb.append(taText.getText());

      int i;
      for (i=0; i < sb.length(); i++)
           os.write(sb.charAt(i));
      os.close();

      // Print any returned data to standard out
      InputStream is = urlConnect.getInputStream();
      int oneChar;

      while ((oneChar=is.read()) != -1)
         System.out.print((char)oneChar);
      is.close();

      System.out.flush();
   }
}


//************************************************
//* This provides the FileDialog services.  If the
//* parent frame is null, then it creates its own
//************************************************
class DoFileDialog
{
   FileDialog fd;
   Frame f;

   public DoFileDialog(Frame parent,
                       String Title, int Mode)
          throws AWTError
   {
       f=null;
       if (parent == null)
       {
           f = new Frame(Title);
           f.pack();
           fd = new FileDialog(f, Title, Mode);
       }
       else
           fd = new FileDialog(parent, Title, Mode);

       fd.show();
       if (f != null)
           f.dispose();
   }

   public DoFileDialog(Frame parent, String Title)
   {
       this(parent, Title, FileDialog.LOAD);
   }

   String getPath() {
       if (fd                != null &&
           fd.getDirectory() != null &&
           fd.getFile()      != null)
           return (fd.getDirectory() +
                   fd.getFile());
       return null;
   }
}

