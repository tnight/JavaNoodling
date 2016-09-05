import java.sql.*; 
 
class MySQLAppl {
 
   static {
      try {
         Class.forName("org.gjt.mm.mysql.Driver").newInstance();
      } catch (Exception e) {
         System.out.println(e);
      }
   }
 
   public static void main(String argv[]) {
      Connection con = null;
 
      // URL is jdbc:db2:dbname
      String url = "jdbc:mysql://aixqtldev.tricorp/bugs";
 
      try {
         if (argv.length == 0) {
            // connect with default id/password
            con = DriverManager.getConnection(url);
            }
         else if (argv.length == 2) {
            String userid = argv[0];
            String passwd = argv[1];
 
            // connect with user-provided username and password
            con = DriverManager.getConnection(url, userid, passwd);
            }
         else {
            System.out.println("Usage: java MySQLAppl [username password]");
            System.exit(0);
         }
 
         // retrieve data from the database
         System.out.println("Retrieve some data from the database...");
         Statement stmt = con.createStatement();
         ResultSet rs = stmt.executeQuery("SELECT bug_id, short_desc from bugs");
 
         System.out.println("Received results:");
 
         // display the result set
         // rs.next() returns false when there are no more rows
         while (rs.next()) {
            String a = rs.getString(1);
            String str = rs.getString(2);
 
            System.out.print(" bug ID = [" + a + "]");
            System.out.print(", bug desc = [" + str + "]");
            System.out.println();
         }
 
         rs.close();
         stmt.close();
 
 /*
         // update the database
         System.out.println("Update the database... ");
         stmt = con.createStatement();
         int rowsUpdated = stmt.executeUpdate("UPDATE employee 
	        SET firstnme = 'SHILI' where empno = '000010'");(9)
 
         System.out.print("Changed "+rowsUpdated);
 
         if (1 == rowsUpdated)
            System.out.println(" row.");
         else
            System.out.println(" rows.");
         stmt.close();
 */
         con.close();
      } catch( Exception e ) {
         System.out.println(e);
      }
   }
}


