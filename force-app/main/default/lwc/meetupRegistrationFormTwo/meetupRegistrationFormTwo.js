import { api, LightningElement, track } from 'lwc';
import saveRegistration from '@salesforce/apex/MeetupRegistrationController.saveRegistration';
//import submitScoreAction from '@salesforce/apex/lwcAppExampleApex.submitScoreAction';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';


export default class insertRecordCustomObjectLwc extends NavigationMixin (LightningElement) {

    @track registrationObjFirstName;
    @track registrationObjLastName;
    @track registrationObjEmail;
    @track registrationObjCode;
    @track registrationRecordId;
    @track errorMsg;

   registrationHandleChange(event){
        if(event.target.name == 'registrationFirstName'){
        this.registrationObjFirstName = event.target.value;  
        //window.console.log('scoreObName ##' + this.scoreObName);
        }
      if(event.target.name == 'registrationLastName'){
        this.registrationObjLastName = event.target.value;  
      }

      if(event.target.name == 'registrationEmail'){
        this.registrationObjEmail = event.target.value;  
      }
      if(event.target.name == 'registrationCode'){
        this.registrationObjCode = event.target.value;  
      }
 }

 submitAction(){
    saveRegistration({firstName:this.registrationObjFirstName,lastName:this.registrationObjLastName,email:this.registrationObjEmail,code:this.registrationObjCode})
    .then(result=>{
        this.registrationRecordId = result.Id;
        window.console.log(this.registrationRecordId + 'created');       
        const toastEvent = new ShowToastEvent({
            title:'Success!',
            message:'Registration Successful!',
            variant:'success'
          });
          this.dispatchEvent(toastEvent);

          /*Start Navigation*/
          this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.scoreRecoreId,
                objectApiName: 'MeetupRegistration__c',
                actionName: 'view'
            },
         });
         /*End Navigation*/

    })
    .catch(error =>{
       this.errorMsg=error.message;
       window.console.log(this.error);
    });
 }
}