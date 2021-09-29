trigger GenerateRegistrationCode on Meetup__C (before insert) {
    for(Meetup__C newMeetup : Trigger.New)
        newMeetup.RegistrationCode__c = RandomCodeGenerator.Generate(8);
}