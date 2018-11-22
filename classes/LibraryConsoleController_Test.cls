/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class LibraryConsoleController_Test {

//TODO: Create another method, for different scenario and declare the variables out of the scope
    static testMethod void testLibraryController() {
    	
    	//CREATE TEST DATA
    	Contact createdCon = createEmployee();
    	Contact c = [Select Id, Name from Contact Where Id =: createdCon.Id];
    	
    	Library_Items__c libItem = createLibraryItem();
    	Library_Items__c l = [Select Id, Item_Code__c From Library_Items__c Where Id =: libItem.Id];
    	
    	
    	//Check Out First Time Scenario
    	String contactId = SearchContactController.getContactByName(c.Name);
    	system.assertEquals(contactId,c.Id);
    	
    	String submitMessage = LibraryConsoleController.submit(c.Id,l.Item_Code__c,'Check OUT');
    	system.assertEquals(submitMessage,'CHECKED OUT SUCCESS');
    	
    	//Check Out Same Employee Scenario
    	String subMessage = LibraryConsoleController.submit(c.Id,l.Item_Code__c,'Check OUT');
    	system.assertEquals(subMessage,'ITEM ALREADY CHECKED OUT');
    }
    
    private static Contact createEmployee(){
    	Contact con = new Contact();
    	con.FirstName = 'Mani';
    	con.LastName = 'Mahal';
    	insert con;
    	return con;
    }
    private static Library_Items__c createLibraryItem(){
        Library_Items__c lib = new Library_Items__c();
        
    	lib.Name = 'The Alchemist';
    	lib.Status__c = 'Checked IN';
    	lib.Item_Type__c = 'Book';
    	lib.BorrowLimit__c = 2;
    	
    	insert lib;
    	return lib;
    }
}