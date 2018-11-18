({
	onBtnClick : function(component, event, helper) {
	  var contactName = component.find("txtname").get("v.value");
       
      console.log('---CONTACT NAME---' + contactName );
        
       var action = component.get("c.getContactByName");   
        action.setParams({ 
                  txtName : contactName                         
               });
        
          action.setCallback(this, function(response) {
            var state = response.getState();  
              component.set("v.error"," ");
                    
              
              console.log('---state---' + state);
              console.log('---responseReturn----' + response.getReturnValue());
                if (state === "SUCCESS" && response.getReturnValue() != null) 
                {  
                    component.set("v.contactID",response.getReturnValue());
                    component.set("v.error","Contact Found"+response.getReturnValue());
                }
              	else
                {
                    component.set("v.error","Error in searching contact");
                }
              
        });
        
         $A.enqueueAction(action);  
	}
})