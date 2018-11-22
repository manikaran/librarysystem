({
	handleSubmit : function(component, event, helper) {
        var contactId = component.get("v.contId");
        var barcode = component.get("v.barcode");
        var selectedAction = component.get("v.selectedAction");
        
        var action = component.get("c.submit"); 
        
        action.setParams({ 
            contactId:contactId,
            barcode:barcode,
            selectedAction:selectedAction,
        });
        
	    action.setCallback(this, function(response) {
		    var state = response.getState();  
			if (state == "SUCCESS" && response.getReturnValue() != null) {  
			   var resp = response.getReturnValue();
				component.set("v.SubmitMessage",resp);
			} else {
				component.set("v.SubmitMessage","ERROR IN PROCESSING SUBMIT ACTION");
			}
        });
         $A.enqueueAction(action);  
	}
})