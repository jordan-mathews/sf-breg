import { LightningElement, track } from 'lwc';

export default class OrganizationSearch extends LightningElement {
  @track searchKey = '';

  handleSearchKeyChange(event) {
    this.searchKey = event.target.value;
  }

  handleEnter(event) {
    if (event.keyCode === 13) {
      this.handleSearch();
    }
  }

  handleSearch() {
    const search = this.template.querySelector('c-organization-search-results');
    search.searchBuinesses(this.searchKey);
  }
}
