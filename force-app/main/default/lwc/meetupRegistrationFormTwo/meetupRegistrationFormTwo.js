import { api, LightningElement, track, wire } from 'lwc';
import saveRegistration from '@salesforce/apex/MeetupRegistrationController.saveRegistration';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';


export default class insertRecordCustomObjectLwc extends NavigationMixin (LightningElement) {
    currentPageReference = null;
    urlStateParameters = null;
    urlCode = null;
    
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlStateParameters = currentPageReference.state;
          this.setParametersBasedOnUrl();
       }
    }
 
    setParametersBasedOnUrl() {
       this.urlCode = this.urlStateParameters.c__code || null;
       this.registrationObjCode = this.urlCode;
    }

    @track registrationObjFirstName;
    @track registrationObjLastName;
    @track registrationObjEmail;
    @track registrationObjCode;
    @track registrationRecordId;
    @track errorMsg;

   registrationHandleChange(event){
      if(event.target.name == 'registrationFirstName'){
        this.registrationObjFirstName = event.target.value;  
        }

      if(event.target.name == 'registrationLastName'){
        this.registrationObjLastName = event.target.value;  
      }

      if(event.target.name == 'registrationEmail'){
        this.registrationObjEmail = event.target.value;  
      }
      /*if(event.target.name == 'registrationCode'){
        this.registrationObjCode = event.target.value;  
      }*/
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

          this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.registrationRecordId,
                objectApiName: 'MeetupRegistration__c',
                actionName: 'view'
            },
         });
    })

    .catch(error =>{
      const toastEvent = new ShowToastEvent({
        title:'Oops!',
        message: error.body.message,
        variant:'error'
      });
      this.dispatchEvent(toastEvent); 
      window.console.log(error.body.message);
    });
 }
}