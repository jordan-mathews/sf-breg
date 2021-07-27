public inherited sharing class BregCalloutService {

  public Organization getOrganization(String organizationNumber){
    CalloutController controller = new CalloutController();
    controller.initRequest('BREG', 'BREG_GET_ORGANIZATION');
    controller.setUrlParams(organizationNumber);
    controller.sendRequest();

    Organization org = Organization.parseOrganization(
      controller.getResponse().getBody()
    );

    return org;
  }

  public List<Organization> searchOrganizations(String name){
    CalloutController controller = new CalloutController();
    controller.initRequest('BREG', 'BREG_SEARCH_ORGANIZATIONS');
    controller.setUrlParams('?navn=' + name);
    controller.sendRequest();

    
    EmbededOrganizations organizations = EmbededOrganizations.parseOrganizations(
      controller.getResponse().getBody().replaceAll('_embedded', 'embedded')
    );

    return organizations.embedded.enheter;
  }

  public class EmbededOrganizations{
    @AuraEnabled
    public OrganizationListWrapper embedded;
  }

  public class OrganizationListWrapper{
    @AuraEnabled
    public List<Organization> enheter;
  }

  public class Organization{
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

  public class OrganizationForm{
    @AuraEnabled
    public String kode;
    @AuraEnabled
    public String beskrivelse;
  }

  public class Address{
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

  public class Industry{
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