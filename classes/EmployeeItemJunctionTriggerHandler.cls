public with sharing class EmployeeItemJunctionTriggerHandler {
    public static void updateLibraryItemStatus(List<Employee_Item_Junction__c> newRecs)
    {
    	system.debug('---IN handler method-----');
    	Set<ID> libraryItemIds = new Set<ID>();
    	List<Library_Items__c> libItemsToUpdate = new List<Library_Items__c>();
    	
    	for(Employee_Item_Junction__c juncRec : newRecs)
    		libraryItemIds.add(juncRec.Library_Item_FK__c);
    	
    	system.debug('---libraryItemIds-----' + libraryItemIds);
    		
    	List<Library_Items__c> libItems = [Select Status__c, Id, (Select Id, CreatedDate, item_Status__c From Employee_Item_Junction__r ORDER BY CreatedDate DESC LIMIT 1) 
    										From Library_Items__c 
    										Where Id IN: libraryItemIds];
    	
    	system.debug('---libItems-----' + libItems);
    										
    	for(Library_Items__c item : libItems)
    	{
    		system.debug('---item.Employee_Item_Junction__r-----' + item.Employee_Item_Junction__r); 
    		if(item.Employee_Item_Junction__r != null && !item.Employee_Item_Junction__r.isEmpty())
    			item.Status__c = item.Employee_Item_Junction__r[0].item_Status__c;
    		else
    			item.Status__c = 'Checked IN';
    	}
    	
    	 update libItems;
    	
    	
    }
}