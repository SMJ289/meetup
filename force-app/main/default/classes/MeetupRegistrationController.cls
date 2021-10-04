public with sharing class MeetupRegistrationController {
  @AuraEnabled
  public static MeetupRegistration__c saveRegistration(String firstName, String lastName, string email, string code) {
      MeetupRegistration__c newRegistration = new MeetupRegistration__c();
      //Need to check if meetup full and have error message
      Meetup__c meetup = findMeetup(code);

      Integer registrationLimit = meetup.RegistrationLimit__c.intValue();
      ID meetupId = meetup.ID;
      
      // Check for duplicate emails. Could be trigger.
      List<MeetupRegistration__c> registrationsWithEmail = [
        SELECT Id
        FROM MeetupRegistration__c
        WHERE Meetup__c = :meetupId
        AND Email__c = :email
      ];

      if (meetup.Status__c == 'Closed') {
        String message = 'This Meetup is closed!';
        AuraHandledException error = new AuraHandledException(message);
        error.setMessage(message);
        throw error;
      } else if (registrationsWithEmail.size() > 0) {
        String message = 'This email is already registered to this event!';
        AuraHandledException error = new AuraHandledException(message);
        error.setMessage(message);
        throw error;
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

  private static Meetup__C findMeetup(String code) {
    Meetup__c meetup = [
      SELECT Id, Status__c, RegistrationLimit__c, Name 
      FROM Meetup__c 
      WHERE RegistrationCode__c = :code
    ];
    return meetup;
  }
}