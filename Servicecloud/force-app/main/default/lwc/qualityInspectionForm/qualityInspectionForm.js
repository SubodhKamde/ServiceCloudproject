import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class QualityInspectionForm extends LightningElement {
    handleSuccess() {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: 'Inspection created successfully!',
            variant: 'success'
        }));
    }
}