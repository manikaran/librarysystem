({
	handleSubmit : function(component, event, helper) {
        var contactId = component.get("v.contId");
        var barcode = component.get("v.barcode");
        var selectedAction = component.get("v.selectedAction");
        
        
        console.log('--contactID ---' + contactId);
        console.log('--barcode ---' + barcode);
        console.log('--selectedAction ---' + selectedAction);

        var action = component.get("c.submit"); 
        
        action.setParams({ 
                  contactId:contactId,
            barcode:barcode,
            selectedAction:selectedAction,
               });
        
          action.setCallback(this, function(response) {
            var state = response.getState();  
              
              console.log('---state---' + state);
              console.log('---responseReturn----' + response.getReturnValue());
             
                if (state == "SUCCESS" && response.getReturnValue() != null) 
                {  
                   var resp = response.getReturnValue();
                    component.set("v.SubmitMessage",resp);
                } 
              	else
                {
                    component.set("v.SubmitMessage","ERROR IN PROCESSING SUBMIT ACTION");
                }
              
        });
        
         $A.enqueueAction(action);  
        
        
        

		
	}
})