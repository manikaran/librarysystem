trigger TrgEmployeeItemJunction on Employee_Item_Junction__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	if(Trigger.isAfter)
	{
		system.debug('---IN AFTER TRIGGER-----');
		if(Trigger.isInsert || Trigger.isUpdate)
    		EmployeeItemJunctionTriggerHandler.updateLibraryItemStatus(Trigger.new);
	}
	If(Trigger.isBefore)
	{
		system.debug('---IN BEFORE TRIGGER-----');
		if(Trigger.isDelete)
			EmployeeItemJunctionTriggerHandler.updateLibraryItemStatus(Trigger.new);
			
	}
}