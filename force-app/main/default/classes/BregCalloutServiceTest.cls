@isTest
public class BregCalloutServiceTest {
  @isTest
  static void testGetOrganizationSuccess() {
    CalloutMock mock = new CalloutMock();
    mock.setMock(200, 'OK', 'BREG_GET_ORGANIZATION');
    BregCalloutService service = new BregCalloutService();
    BregCalloutService.OrganizationResponse resp = new BregCalloutService.OrganizationResponse();

    Test.startTest();
    resp = service.getOrganization('123456789');
    Test.stopTest();

    System.assertEquals(true, resp.success, 'Successfull callout with response.');
    System.assertNotEquals(null, resp.organization, 'Successfully parsed response body.');
  }

  @isTest
  static void testGetOrganizationError() {
    CalloutMock mock = new CalloutMock();
    mock.setMock(500, 'Internal Server Error', 'BREG_GET_ORGANIZATION');
    BregCalloutService service = new BregCalloutService();
    BregCalloutService.OrganizationResponse resp = new BregCalloutService.OrganizationResponse();

    Test.startTest();
    resp = service.getOrganization('123456789');
    Test.stopTest();

    System.assertEquals(false, resp.success, 'Unsuccessfull callout.');
    System.assertEquals(null, resp.organization, 'Null organization due to callout error');
    System.assertEquals('"Internal Server Error"', resp.error, 'Correct error message logged.');
  }

  @isTest
  static void testSearchOrganizationSuccess() {
    CalloutMock mock = new CalloutMock();
    mock.setMock(200, 'OK', 'BREG_SEARCH_ORGANIZATIONS');
    BregCalloutService service = new BregCalloutService();
    BregCalloutService.OrganizationSearchResponse resp = new BregCalloutService.OrganizationSearchResponse();

    Test.startTest();
    resp = service.searchOrganizations('Test');
    Test.stopTest();

    System.assertEquals(true, resp.success, 'Successfull callout with response.');
    System.assertEquals(1, resp.organizations.size(), 'Successfully parsed response body.');
  }

  @isTest
  static void testSearchOrganizationError() {
    CalloutMock mock = new CalloutMock();
    mock.setMock(500, 'Internal Server Error', 'BREG_SEARCH_ORGANIZATIONS');
    BregCalloutService service = new BregCalloutService();
    BregCalloutService.OrganizationSearchResponse resp = new BregCalloutService.OrganizationSearchResponse();

    Test.startTest();
    resp = service.searchOrganizations('Test');
    Test.stopTest();

    System.assertEquals(false, resp.success, 'Unsuccessfull callout.');
    System.assertEquals('"Internal Server Error"', resp.error, 'Correct error message logged.');
    System.assertEquals(null, resp.organizations, 'Successfully parsed response body.');
  }
}
