public with sharing class StringArrayTest {
	public static list<string> generateStringArray(integer length){
		
		list<string> myArray = new list<string>();
		
		for(integer i=0; i<length ;i++){
			myArray.add('Test'+ i);
			System.debug(myArray[i]);
		}
		return myArray;
	}
}