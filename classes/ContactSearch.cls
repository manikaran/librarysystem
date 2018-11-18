public with sharing class ContactSearch {
    public static List<Contact> searchForContacts(String str1, String str2){
    	//try
    	List<Contact> contacts = [ Select ID, Name 
    	                           From contact
    	                           where (LastName =: str1 
    	                           AND MailingPostalCode = : str2)
    	                         ];
        //catch
        return contacts;
    }       
}