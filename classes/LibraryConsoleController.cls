public with sharing class LibraryConsoleController {
    
    private final static String REQUIRED_MISSING = 'Required fields are missing';
    private final static String CHECK_IN = 'Checked IN';
    private final static String CHECK_OUT = 'Checked OUT';    
    
    @auraEnabled
    public static String submit(String contactId, String barcode, String selectedAction){
        
        if(isEmpty(contactId) || isEmpty(barcode) || isEmpty(selectedAction)){
            return REQUIRED_MISSING;
        }
        
      	system.debug('+++selectedAction +++' + selectedAction);
        
		Library_Items__c libItem = getLibraryItemIdFromBarCode(barcode);
		String libItemId = libItem.Id;
        
        system.debug('+++libItem.Id++++' + libItem.Id);
        
        if(selectedAction == 'Check IN')
        {
            system.debug('Check IN');
         	
            if(libItem.Status__c == 'Checked IN')
                return 'ITEM ALREADY CHECKED IN';
            
            Employee_Item_Junction__c junctRec = getLastestCheckedoutInfo(contactId,barcode, libItemId);
            
            
            if(junctRec != null && junctRec.Item_Status__c == CHECK_OUT)
            {
            	system.debug('+++ Action konsa hai +++' + selectedAction);
            	
                junctRec.Item_Status__c = CHECK_IN;
                junctRec.Check_IN_Datetime__c = Datetime.now();
                update junctRec;
                
                //libItem.Status__c = 'Checked IN';
                //update libItem;
                
                return 'CHECKED IN SUCCESS';
            }
            else
               	return 'ITEM NOT CHECKED OUT BY THIS CONTACT';
           
        }
        else
        {
            
            system.debug('CHECK OUT');
            system.debug('----libItem.Status__c----' + libItem.Status__c );
            if(libItem.Status__c == 'Checked OUT')
                return 'ITEM ALREADY CHECKED OUT';
            
            //check borrow limit
            List<Employee_Item_Junction__c> junctionRecs = getJunctionRecords(contactId,barcode, libItemId);
                //system.debug('BORROW LIST SIZE'+BorrowItemLimits.size());
            
            double borrowLimit;
            
            if(junctionRecs != null && !junctionRecs.isEmpty()){
            	borrowLimit = junctionRecs[0].Library_Item_FK__r.BorrowLimit__c;
            	
                system.debug('BORROWLIMIT '+borrowLimit);
                //system.debug('BORROWLIMIT STATUS '+junctionRecs[0].Item_Status__c);
                
            	if(junctionRecs[0].Item_Status__c == CHECK_OUT){
				    return 'ALREADY CHECKED OUT';
            	}else{
            		if(borrowLimit <= junctionRecs.size()){
				        return 'EXCEEDED BORROW LIMIT';
            		}else{
						createNewJunction(contactId,barCode);
						//libItem.Status__c = 'Checked OUT';
						//update libItem;
						return 'CHECKED OUT SUCCESS';
            		}
            	}
            }else{
                
                system.debug('Create New Junction Record');
				createNewJunction(contactId,barCode);
				
				//libItem.Status__c = 'Checked OUT';
				//update libItem;
					
				return 'CHECKED OUT SUCCESS';
            }
            
        }
    	return null;    
    }
    
    private static boolean isEmpty(String val)
    {
        if(val == null || val == '')
            return true;
       	return false;
    }
    
    private static void createNewJunction(String contactId, String barCode)
    {
        Employee_Item_Junction__c junctRec = new Employee_Item_Junction__c();
        junctRec.item_Status__c = CHECK_OUT;
        junctRec.Check_Out_Datetime__c = Datetime.now();
        junctRec.Employee_FK__c = contactId;
        
        Library_Items__c libItem = getLibraryItemIdFromBarCode(barcode);
        junctRec.Library_Item_FK__c = libItem.Id;
        insert junctRec;
    }
    
    private static Employee_Item_Junction__c getLastestCheckedoutInfo(String contactId, String barcode, String libItemId){
        List<Employee_Item_Junction__c> junctionRecs = new List<Employee_Item_Junction__c>();
        //List<Library_Items__c> libItems = new List<Library_Items__c>();
        
        junctionRecs = [SELECT Check_IN_Datetime__c, Item_Status__c
                       FROM Employee_Item_Junction__c
                       WHERE Employee_FK__c =: contactId 
                       	AND Library_Item_FK__c =: libItemId
                       	ORDER BY CreatedDate DESC
                        LIMIT 1
                       ];
        
        if(!junctionRecs.isEmpty() && junctionRecs != null )
        {
            system.debug('++++++JUNCTION_RECS_RETURNED++++' + junctionRecs[0]);
        	return junctionRecs[0];
        }
      
        return null;
        
    }
    
    private static Library_Items__c getLibraryItemIdFromBarCode(String barCode)
    {
        List<Library_Items__c> libItems = [Select Id , Item_Code__c, Status__c From Library_Items__c Where Item_Code__c =: barcode LIMIT 1];
        if(!libItems.isEmpty() || libItems != null)
     		return libItems[0];
       	return null;
    }
    
    private static List<Employee_Item_Junction__c> getJunctionRecords(String contactId, String barcode, String libItemId){
    	
        List<Employee_Item_Junction__c> junctionRecs = new List<Employee_Item_Junction__c>();
        
        junctionRecs = [SELECT Check_IN_Datetime__c, Item_Status__c, Library_Item_FK__r.BorrowLimit__c, Library_Item_FK__r.Status__c
                       FROM Employee_Item_Junction__c
                       WHERE Employee_FK__c =: contactId 
                       	AND Library_Item_FK__c =: libItemId
                       	ORDER BY CreatedDate DESC
                       ];
        
            system.debug('++++++the one I just created++++' + junctionRecs);
            
        if(junctionRecs != null && !junctionRecs.isEmpty())
        {
            system.debug('++++++BORROW_LIMIT_RECS_RETURNED++++' + junctionRecs[0]);
        	return junctionRecs;
        }
      
        return null;
        
    }
}