import { LightningElement, wire, track } from 'lwc';
import getSuppliers from '@salesforce/apex/SupplierController.getSuppliers';



const COLUMNS = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Category', fieldName: 'Category__c' },
    { label: 'Quality Rating', fieldName: 'Quality_Rating__c', type: 'number' },
    { label: 'Delivery Rating', fieldName: 'Delivery_Rating__c', type: 'number' },
    { label: 'Performance Score', fieldName: 'Performance_Score__c', type: 'number' },
    { label: 'Risk Level', fieldName: 'Risk_Level__c' }
];

export default class SupplierList extends LightningElement {
    @track suppliers = [];
    @track filteredSuppliers = [];
    columns = COLUMNS;

    @wire(getSuppliers)
    wiredSuppliers({ data, error }) {
        if (data) {
            this.suppliers = data;
            this.filteredSuppliers = data;
        } else if (error) {
            console.error(error);
        }
    }

    handleSearch(event) {
        const searchKey = event.target.value.toLowerCase();
        this.filteredSuppliers = this.suppliers.filter(
            supplier => supplier.Name.toLowerCase().includes(searchKey)
        );
    }
}