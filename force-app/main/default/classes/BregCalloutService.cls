public inherited sharing class BregCalloutService {
  public OrganizationResponse getOrganization(String organizationNumber) {
    CalloutController controller = new CalloutController();
    controller.initRequest('BREG', 'BREG_GET_ORGANIZATION');
    controller.setUrlParams(organizationNumber);
    controller.sendRequest();

    OrganizationResponse resp = new OrganizationResponse();

    if (controller.getResponse().getStatusCode() == 200) {
      resp.success = true;
      resp.organization = Organization.parseOrganization(controller.getResponse().getBody());
    } else {
      resp.error = controller.getResponse().getBody();
    }

    return resp;
  }

  public OrganizationSearchResponse searchOrganizations(String name) {
    CalloutController controller = new CalloutController();
    controller.initRequest('BREG', 'BREG_SEARCH_ORGANIZATIONS');
    controller.setUrlParams('?navn=' + name.trim().replaceAll(' ', '%20'));
    controller.sendRequest();

    OrganizationSearchResponse resp = new OrganizationSearchResponse();

    if (controller.getResponse().getStatusCode() == 200) {
      EmbededOrganizations embeddedOrgs = EmbededOrganizations.parseOrganizations(
        controller.getResponse().getBody().replaceAll('_embedded', 'embedded')
      );

      resp.success = true;
      resp.organizations = embeddedOrgs.embedded.enheter;
    } else {
      resp.error = controller.getResponse().getBody();
    }
    System.debug(resp);
    return resp;
  }

  public class OrganizationResponse {
    @AuraEnabled
    public Boolean success;
    @AuraEnabled
    public Organization organization;
    @AuraEnabled
    public String error;

    public OrganizationResponse() {
      this.success = false;
      this.organization = null;
      this.error = null;
    }
  }

  public class OrganizationSearchResponse {
    @AuraEnabled
    public Boolean success;
    @AuraEnabled
    public List<Organization> organizations;
    @AuraEnabled
    public String error;

    public OrganizationSearchResponse() {
      this.success = false;
      this.organizations = null;
      this.error = null;
    }
  }

  public class EmbededOrganizations {
    @AuraEnabled
    public OrganizationListWrapper embedded;
  }

  public class OrganizationListWrapper {
    @AuraEnabled
    public List<Organization> enheter;
  }

  public class Organization {
    @AuraEnabled
    public String organisasjonsnummer;
    @AuraEnabled
    public String navn;
    @AuraEnabled
    public String antallAnsatte;
    @AuraEnabled
    public OrganizationForm organisasjonsform;
    @AuraEnabled
    public Address postadresse;
    @AuraEnabled
    public Address forretningsadresse;
    @AuraEnabled
    public Industry naeringskode1;
  }

  public class OrganizationForm {
    @AuraEnabled
    public String kode;
    @AuraEnabled
    public String beskrivelse;
  }

  public class Address {
    @AuraEnabled
    public String land;
    @AuraEnabled
    public String landkode;
    @AuraEnabled
    public String postnummer;
    @AuraEnabled
    public String poststed;
    @AuraEnabled
    public List<String> adresse;
    @AuraEnabled
    public String kommune;
    @AuraEnabled
    public String kommunenummer;
  }

  public class Industry {
    @AuraEnabled
    public String beskrivelse;
    @AuraEnabled
    public String kode;
  }

  private static Organization parseOrganization(String json) {
    return (Organization) System.JSON.deserialize(json, Organization.class);
  }

  private static EmbededOrganizations parseOrganizations(String json) {
    return (EmbededOrganizations) System.JSON.deserialize(json, EmbededOrganizations.class);
  }
}
