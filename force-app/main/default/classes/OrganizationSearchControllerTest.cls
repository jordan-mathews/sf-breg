@isTest
public class OrganizationSearchControllerTest {
  @isTest
  static void searchOrganizations() {
    CalloutMock mock = new CalloutMock();
    mock.setMock(200, 'OK', 'BREG_SEARCH_ORGANIZATIONS');
    BregCalloutService.OrganizationSearchResponse resp = new BregCalloutService.OrganizationSearchResponse();

    Test.startTest();
    resp = OrganizationSearchController.searchOrganizations('Test');
    Test.stopTest();

    System.assertEquals(true, resp.success, 'Successfull callout with response.');
    System.assertEquals(1, resp.organizations.size(), 'Successfully parsed response body.');
  }

  @isTest
  static void testGetOrganizationSuccess() {
    CalloutMock mock = new CalloutMock();
    mock.setMock(200, 'OK', 'BREG_GET_ORGANIZATION');
    BregCalloutService.OrganizationResponse resp = new BregCalloutService.OrganizationResponse();

    Test.startTest();
    resp = OrganizationSearchController.getOrganization('123456789');
    Test.stopTest();

    System.assertEquals(true, resp.success, 'Successfull callout with response.');
    System.assertNotEquals(null, resp.organization, 'Successfully parsed response body.');
  }
}
