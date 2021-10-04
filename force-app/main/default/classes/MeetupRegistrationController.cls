public with sharing class MeetupRegistrationController {
  @AuraEnabled
  public static MeetupRegistration__c saveRegistration(String firstName, String lastName, string email, string code) {
      MeetupRegistration__c newRegistration = new MeetupRegistration__c();
      //Need to check if meetup full and have error message
      Meetup__c meetup = findMeetup(code);

      ID meetupId = meetup.ID;
      
      if (meetup.Status__c == 'Closed') {
        String message = 'This Meetup is closed!';
        AuraHandledException error = new AuraHandledException(message);
        error.setMessage(message);
        throw error;
      } else if (isEmailAlreadyRegistered(meetupId, email)) {
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
      
      closeMeetupIfFull(meetup);

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
  
  // Check for duplicate emails
  private static Boolean isEmailAlreadyRegistered(ID meetupId, String email) {
    List<MeetupRegistration__c> registrationsWithEmail = [
      SELECT Id
      FROM MeetupRegistration__c
      WHERE Meetup__c = :meetupId
      AND Email__c = :email
    ];

    return registrationsWithEmail.size() > 0;
  }
  
  // Automatically close event if full
  private static void closeMeetupIfFull(Meetup__c meetup) {
    ID meetupId = meetup.Id;
    Integer registrationLimit = meetup.RegistrationLimit__c.intValue();

    List<MeetupRegistration__c> allRegistrations = [
      SELECT Id
      FROM MeetupRegistration__c
      WHERE Meetup__c = :meetupId
    ];
    
    Integer currentRegistrations = allRegistrations.size();
    
    if (currentRegistrations >= registrationLimit) {
      meetup.Status__c = 'Closed';
      update meetup;
    }
  }
}