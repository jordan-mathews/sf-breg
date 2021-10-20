import { LightningElement, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import searchOrganizations from '@salesforce/apex/OrganizationSearchController.searchOrganizations';
import getOrganization from '@salesforce/apex/OrganizationSearchController.getOrganization';

const ERROR_MESSAGE = 'Det har oppstått en feil. Vennligst ta kontakt med Systemadministrator.';

export default class OrganizationSearchResults extends NavigationMixin(LightningElement) {
  @track searchResults;
  @track selectedBusiness;
  @track customerData;
  @track accountName;
  @track isLoading = false;
  @track error;

  @api
  searchBuinesses(searchKey) {
    this.isLoading = true;

    searchOrganizations({ name: searchKey })
      .then((response) => {
        this.isLoading = false;
        if (response.success) {
          this.searchResults = response.organizations;
        } else {
          throw new Error('Organization search error.');
        }
      })
      .catch((error) => {
        this.error = error;
        this.searchResults = undefined;
        this.isLoading = false;
      });
  }

  getAccountInfo() {
    getOrganization({ organizationNumber: this.selectedBusiness })
      .then((response) => {
        if (response.success) {
          this.customerData = response.organization;
          this.accountName = this.customerData.navn;
        } else {
          throw new Error('Get organization error.');
        }
      })
      .then(() => {
        this.isLoading = false;
        this.newAccount();
      })
      .catch((error) => {
        console.error(error);
        this.error = error;
        this.isLoading = false;
        this.dispatchEvent(
          new ShowToastEvent({
            message: ERROR_MESSAGE,
            variant: 'error'
          })
        );
      });
  }

  createAccount(event) {
    this.selectedBusiness = event.target.value;
    this.isLoading = true;
    this.getAccountInfo();
  }

  newAccount() {
    const account = {
      Name: this.customerData.navn ? this.customerData.navn : null,
      NumberOfEmployees: this.customerData.antallAnsatte ? this.customerData.antallAnsatte : null,
      OrganizationNumber__c: this.customerData.organisasjonsnummer ? this.customerData.organisasjonsnummer : null,
      DateOfIncorporation__c: this.customerData.stiftelsesdato ? this.customerData.stiftelsesdato : null,
      ParentOrganizationNumber__c: this.customerData.overordnetEnhet ? this.customerData.overordnetEnhet : null,
      Bankrupt__c: this.customerData.konkurs ? this.customerData.konkurs : false,
      OrganizationFormCode__c: this.customerData.organisasjonsform.kode
        ? this.customerData.organisasjonsform.kode
        : null,
      OrganizationFormDescription__c: this.customerData.organisasjonsform.beskrivelse
        ? this.customerData.organisasjonsform.beskrivelse
        : null,
      IndustryCode__c: this.customerData.naeringskode1.kode ? this.customerData.naeringskode1.kode : null,
      IndustryCodeDescription__c: this.customerData.naeringskode1.beskrivelse
        ? this.customerData.naeringskode1.beskrivelse
        : null
    };

    if (this.customerData.institusjonellSektorkode) {
      account.InstitutionalSectorCode__c = this.customerData.institusjonellSektorkode.kode
        ? this.customerData.institusjonellSektorkode.kode
        : null;
      account.InstitutionalSectorCodeDescription__c = this.customerData.institusjonellSektorkode.beskrivelse
        ? this.customerData.institusjonellSektorkode.beskrivelse
        : null;
    }

    if (this.customerData.naeringskode2) {
      account.IndustryCode2__c = this.customerData.naeringskode2.kode ? this.customerData.naeringskode2.kode : null;
      account.IndustryCodeDescription2__c = this.customerData.naeringskode2.beskrivelse
        ? this.customerData.naeringskode2.beskrivelse
        : null;
    }

    if (this.customerData.forretningsadresse) {
      account.ShippingStreet = this.customerData.forretningsadresse.adresse[0]
        ? this.customerData.forretningsadresse.adresse[0]
        : null;
      account.ShippingPostalCode = this.customerData.forretningsadresse.postnummer
        ? this.customerData.forretningsadresse.postnummer
        : null;
      account.ShippingCity = this.customerData.forretningsadresse.poststed
        ? this.customerData.forretningsadresse.poststed
        : null;
      account.ShippingMunicipality__c = this.customerData.forretningsadresse.kommune
        ? this.customerData.forretningsadresse.kommune
        : null;
      account.ShippingMunicipalityNumber__c = this.customerData.forretningsadresse.kommunenummer
        ? this.customerData.forretningsadresse.kommunenummer
        : null;
      account.ShippingCountryCode = 'NO';
    }

    if (this.customerData.postadresse) {
      account.BillingStreet = this.customerData.postadresse.adresse[0]
        ? this.customerData.postadresse.adresse[0]
        : null;
      account.BillingPostalCode = this.customerData.postadresse.postnummer
        ? this.customerData.postadresse.postnummer
        : null;
      account.BillingMunicipality__c = this.customerData.postadresse.kommune
        ? this.customerData.postadresse.kommune
        : null;
      account.BillingMunicipalityNumber__c = this.customerData.postadresse.kommunenummer
        ? this.customerData.postadresse.kommunenummer
        : null;
      account.BillingCity = this.customerData.postadresse.poststed ? this.customerData.postadresse.poststed : null;

      account.BillingCountryCode = 'NO';
    }

    const defaultValues = encodeDefaultFieldValues(account);

    this[NavigationMixin.Navigate]({
      type: 'standard__objectPage',
      attributes: {
        objectApiName: 'Account',
        actionName: 'new'
      },
      state: {
        defaultFieldValues: defaultValues
      }
    });
  }
}
