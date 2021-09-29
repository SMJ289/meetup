import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import MEETUP_NAME from '@salesforce/schema/Meetup__c.Name';
import REGISTRATION_LIMIT from '@salesforce/schema/Meetup__c.RegistrationLimit__c';

export default class NewMeetupForm extends LightningElement {

    selectedFields = [MEETUP_NAME, REGISTRATION_LIMIT];
    
    handleSuccess(event) {
      const evt = new ShowToastEvent({
          title: "Meetup created!",
          message: "Record ID: " + event.detail.id,
          variant: "success"
      });
      this.dispatchEvent(evt);
      const editForm = this.template.querySelector('lightning-record-form');
      editForm.recordId = null;
  }
}