import {LightningElement,track} from 'lwc';
import getAccountList from '@salesforce/apex/AccountSearchController.getAccountList';
import getAccountRespDetails from '@salesforce/apex/AccountSearchController.getAccountResponseDetails';
export default class AccSearch extends LightningElement {
queryTerm;
records;
selectedRecordId;
showLkp = false;
responsesList;
@track inputValue = '';
@track mapOfValues = [];
handleKeyUp(evt) {
	console.log('Test inside here');
		if(this.queryTerm.length > 4) {
			getAccountList({
            accName : evt.target.value
        })
        .then(result => {
            this.records = result;
            this.error = undefined;
			this.showLkp = true;
			console.log(JSON.stringify(this.records));
        })
        .catch(error => {
            this.error = error;
            this.records = undefined;
        });
		}
        const isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            //this.queryTerm = evt.target.value;
        }
    }
	handleSelect(event) {
	this.selectedRecordId = event.detail.id;
	this.inputValue = event.detail.name;
	this.showLkp = false;
	//call to get corresponsing responses
	getAccountRespDetails({
            accountId : this.selectedRecordId
        })
        .then(result => {
            this.responsesList = result;
            this.error = undefined;
			//console.log(JSON.stringify(this.responsesList));
			for(let key in result) {
                // Preventing unexcepted data
                if (result.hasOwnProperty(key)) { // Filtering the data in the loop
                    this.mapOfValues.push({value:result[key], key:key});
                }
            }
			console.log('map preparation');
			console.log(this.mapOfValues);
            //console.log(' records ', this.records);
        })
        .catch(error => {
            this.error = error;
            this.records = undefined;
        });
	}
	handleSectionToggle(event) {
	}
}