public with sharing class AccountHandler {
	public static Account insertNewAccount(String AccName){
			Account acc = new Account(Name=AccName); 
		try{
			insert acc;
		}catch(DmlException e){
			System.debug('An Error has occurred');//some message
			return null;
		}
		return acc;
	}
}