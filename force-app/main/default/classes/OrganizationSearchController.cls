public with sharing class OrganizationSearchController {
  @AuraEnabled
  public static BregCalloutService.OrganizationSearchResponse searchOrganizations(String name) {
    BregCalloutService.OrganizationSearchResponse response;

    try {
      BregCalloutService service = new BregCalloutService();
      response = service.searchOrganizations(name);
    } catch (Exception e) {
      throw new AuraHandledException('Organizattion Search Error: ' + e);
    }
    return response;
  }

  @AuraEnabled
  public static BregCalloutService.OrganizationResponse getOrganization(String organizationNumber) {
    BregCalloutService.OrganizationResponse response;

    try {
      BregCalloutService service = new BregCalloutService();
      response = service.getOrganization(organizationNumber);
    } catch (Exception e) {
      throw new AuraHandledException('Get Organizattion Error: ' + e);
    }
    return response;
  }
}
