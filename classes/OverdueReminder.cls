global class OverdueReminder implements Schedulable {
	//TODO: create a batch job for better implemenation as it will run into problems with gov limits
	global void execute(SchedulableContext ctx){
		DateTime currentTime = Datetime.now();
		List<Employee_Item_Junction__c> OverdueRecs = new List<Employee_Item_Junction__c>();
		
		OverdueRecs = [ SELECT Employee_FK__c 
						FROM Employee_Item_Junction__c
						WHERE Item_Status__c =: 'Checked OUT'
			   	        AND Overdue_Datetime__c <=: currentTime 
					  ];
					  
        List<Contact> conDetails = new List<Contact>();
        
        for (Integer i = 0; i < OverdueRecs.size(); i++) {
        	contact con = new Contact();
			con = [ SELECT FirstName, LastName, Email 
					FROM Contact 
					WHERE id =: OverdueRecs[i].Employee_FK__c
			      ];
	    	//conDetails.add(con);	
	    	if(con.Email != ''){
		        sendReminderEmail(con);
	    	}	    
        }
	}
	//Sends Email
	public void sendReminderEmail(Contact con){
		Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		message.toAddresses = new String[] { con.Email, con.Email };
		message.optOutPolicy = 'FILTER';
		message.subject = 'The Library System';
		message.plainTextBody = 'Hello '+con.FirstName+' '+con.LastName+', It would be very nice of you to return your item back to the Library like a responsible adult?';
		
		Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
		Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

		if (results[0].success) {
			System.debug('The email was sent successfully.');
		} else {
			System.debug('The email failed to send: ' + results[0].errors[0].message);
		}	
	}
}