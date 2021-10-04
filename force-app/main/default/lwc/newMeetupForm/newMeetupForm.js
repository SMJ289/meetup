import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import MEETUP_NAME from '@salesforce/schema/Meetup__c.Name';
import REGISTRATION_LIMIT from '@salesforce/schema/Meetup__c.RegistrationLimit__c';

export default class NewMeetupForm extends LightningElement {

    selectedFields = [MEETUP_NAME, REGISTRATION_LIMIT];
    
    handleSuccess(event) {
      this.recordId = event.detail.id;
      const toastEvent = new ShowToastEvent({
          title: 'Success!',
          message: 'Meetup Created!',
          variant: 'success'
      });
      this.dispatchEvent(toastEvent);
      const editForm = this.template.querySelector('lightning-record-form');
      editForm.recordId = null;
  }
}