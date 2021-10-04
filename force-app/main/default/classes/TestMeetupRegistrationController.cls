@isTest 
public class TestMeetupRegistrationController {
    @isTest static void successfulSaveRegistration() {
      Meetup__c meetup = new Meetup__c(
                             Name = 'Test Meetup',
                             RegistrationLimit__c = 3);
      insert meetup;
      
      Meetup__c newMeetup = [
        SELECT Id, RegistrationCode__c
        FROM Meetup__c
        WHERE Name = 'Test Meetup'
        LIMIT 1
      ];

      String registrationCode = newMeetup.RegistrationCode__c;
      ID meetupId = newMeetup.Id;
      
      MeetupRegistration__c newRegistration = MeetupRegistrationController.saveRegistration('Steve', 'Meyers', 'sm@gmail.com', registrationCode);

      List<MeetupRegistration__c> registrationsCreated = [
        SELECT Id, FirstName__c
        FROM MeetupRegistration__c
        WHERE Meetup__c = :meetupId
      ];

      System.assertEquals(1, registrationsCreated.size());
      System.assertEquals('Steve', registrationsCreated[0].FirstName__c);
    }

    @isTest static void duplicateEmailRegistrationTest() {
      Meetup__c meetup = new Meetup__c(
        Name = 'Test Meetup',
        RegistrationLimit__c = 3);
        insert meetup;

        Meetup__c newMeetup = [
          SELECT Id, RegistrationCode__c
          FROM Meetup__c
          WHERE Name = 'Test Meetup'
          LIMIT 1
        ];
  
        String registrationCode = newMeetup.RegistrationCode__c;
        ID meetupId = newMeetup.Id;

        MeetupRegistrationController.saveRegistration('Steve', 'Meyers', 'sm@gmail.com', registrationCode);
        try {
          MeetupRegistrationController.saveRegistration('Doppel', 'Ganger', 'sm@gmail.com', registrationCode);
        } catch (AuraHandledException e) {
          System.assertEquals('This email is already registered to this event!', e.getMessage());
        }
    }

    @isTest static void closedMeetupRegistrationTest() {
      Meetup__c meetup = new Meetup__c(
        Name = 'Test Meetup',
        RegistrationLimit__c = 1);
        insert meetup;

        Meetup__c newMeetup = [
          SELECT Id, RegistrationCode__c
          FROM Meetup__c
          WHERE Name = 'Test Meetup'
          LIMIT 1
        ];
  
        String registrationCode = newMeetup.RegistrationCode__c;
        ID meetupId = newMeetup.Id;

        MeetupRegistrationController.saveRegistration('Steve', 'Meyers', 'sm@gmail.com', registrationCode);
        try {
          MeetupRegistrationController.saveRegistration('Taylor', 'Myers', 'tm@gmail.com', registrationCode);
        } catch (AuraHandledException e) {
          System.assertEquals('This Meetup is full or closed!', e.getMessage());
        }
    }
}
