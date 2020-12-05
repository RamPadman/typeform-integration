import {LightningElement,api} from 'lwc';

export default class LkpSrchResult extends LightningElement {
@api records
handleSelect(evt) {

console.log('selected'+evt.currentTarget.getAttribute('data-id'));
const selectedRecord = new CustomEvent(
            "select",{
          detail:  {
                id : evt.currentTarget.id,
				name : evt.currentTarget.getAttribute('data-id')
            }
       } );
		this.dispatchEvent(selectedRecord);
}
}