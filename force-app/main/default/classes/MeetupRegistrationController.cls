public with sharing class MeetupRegistrationController {
  @AuraEnabled
  public static MeetupRegistration__c saveRegistration(String firstName, String lastName, string email, string code) {
      Meetup__c meetup = [SELECT Id FROM Meetup__c WHERE RegistrationCode__c = :code];
      ID meetupId = meetup.ID;
      MeetupRegistration__c newRegistration = new MeetupRegistration__c(
        FirstName__c = firstName,
        LastName__c = lastName,
        Email__c = email,
        Meetup__c = meetupId
      );
      insert newRegistration;
      return newRegistration;
    }
}
