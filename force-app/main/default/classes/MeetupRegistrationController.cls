public with sharing class MeetupRegistrationController {
  @AuraEnabled
  public static MeetupRegistration__c saveRegistration(String firstName, String lastName, string email, string code) {
      MeetupRegistration__c newRegistration = new MeetupRegistration__c();
      //Need to check if meetup full and have error message
      Meetup__c meetup = [
        SELECT Id, RegistrationLimit__c 
        FROM Meetup__c 
        WHERE RegistrationCode__c = :code
      ];

      ID meetupId = meetup.ID;
      Integer registrationLimit = meetup.RegistrationLimit__c.intValue();
      
      // Check for duplicate emails. Could be trigger.
      List<MeetupRegistration__c> registrationsWithEmail = [
        SELECT Id
        FROM MeetupRegistration__c
        WHERE Meetup__c = :meetupId
        AND Email__c = :email
      ];

      if (registrationsWithEmail.size() > 0) {
        System.debug('Email present');
        throw new AuraHandledException('This email is already registered to event');
      } else {
        newRegistration.FirstName__c = firstName;
        newRegistration.LastName__c = lastName;
        newRegistration.Email__c = email;
        newRegistration.Meetup__c = meetupId;

        insert newRegistration;
      }

      List<MeetupRegistration__c> allRegistrations = [
        SELECT Id
        FROM MeetupRegistration__c
        WHERE Meetup__c = :meetupId
      ];
      
      Integer currentRegistrations = allRegistrations.size();
      
      // Automatically close event if full. Could be trigger.
      if (currentRegistrations >= registrationLimit) {
        meetup.Status__c = 'Closed';
        update meetup;
      }

      return newRegistration;
  }
}
