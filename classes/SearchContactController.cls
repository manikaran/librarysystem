public class SearchContactController 
{
    @AuraEnabled
	public static String getContactByName(String txtName)
    {
        List<Contact> contacts = new List<Contact>();
        contacts = [Select Id , Name From Contact Where Name =: txtName];
        if(contacts != null && contacts.size() == 1)
        {
            return contacts[0].Id;
        }
		return null;        
    }
}