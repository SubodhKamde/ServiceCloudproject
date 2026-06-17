// File 3: AccountHandlerTest.cls (SEPARATE FILE - NOT IN HANDLER)
@isTest
public class AccountHandlerTest {
    
    // Setup method - runs ONCE, creates data for ALL test methods
    @TestSetup
    static void setupTestData() {
        // Create test Accounts
        List<Account> testAccounts = new List<Account>();
        for(Integer i = 0; i < 200; i++) {
            Account acc = new Account();
            acc.Name = 'Test Account ' + i;
            acc.Industry = 'Technology';
            acc.Rating = 'Hot';
            testAccounts.add(acc);
        }
        insert testAccounts;
    }
    
    // Test 1: Positive scenario - Bulk insert
    @isTest
    static void testBeforeInsert_SetDefaultRating() {
        // Arrange - create test data
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 200; i++) {
            Account acc = new Account();
            acc.Name = 'New Account ' + i;
            acc.Industry = 'Finance';
            // Note: NOT setting Rating - should default to 'Cold'
            accounts.add(acc);
        }
        
        // Act - perform operation
        Test.startTest();
        insert accounts;
        Test.stopTest();
        
        // Assert - verify results
        List<Account> insertedAccounts = [
            SELECT Id, Rating 
            FROM Account 
            WHERE Industry = 'Finance'
        ];
        
        System.assertEquals(200, insertedAccounts.size(), 'Should insert 200 accounts');
        
        for(Account acc : insertedAccounts) {
            System.assertEquals('Cold', acc.Rating, 'Rating should default to Cold');
        }
    }
    
    // Test 2: Negative scenario - Validation error
    @isTest
    static void testBeforeInsert_ValidationError() {
        // Arrange - create invalid Account
        Account acc = new Account();
        // Note: Name is blank - should fail validation
        
        // Act & Assert
        Test.startTest();
        try {
            insert acc;
            System.assert(false, 'Should have thrown DmlException');
        } catch(DmlException e) {
            System.assert(e.getMessage().contains('Name'), 'Error should mention Name field');
        }
        Test.stopTest();
    }
    
    // Test 3: After insert - Create related records
    @isTest
    static void testAfterInsert_CreateContacts() {
        // Arrange
        Account acc = new Account();
        acc.Name = 'Test Company';
        acc.Industry = 'Healthcare';
        
        // Act
        Test.startTest();
        insert acc;
        Test.stopTest();
        
        // Assert
        List<Contact> contacts = [
            SELECT Id, FirstName, LastName, AccountId
            FROM Contact
            WHERE AccountId = :acc.Id
        ];
        
        System.assertEquals(1, contacts.size(), 'Should create one contact');
        System.assertEquals('Default', contacts[0].FirstName);
        System.assertEquals('Contact', contacts[0].LastName);
    }
    
    // Test 4: After update - Update related records
    @isTest
    static void testAfterUpdate_UpdateContactDepartment() {
        // Arrange - get test data from @TestSetup
        List<Account> accounts = [
            SELECT Id, Industry 
            FROM Account 
            WHERE Industry = 'Technology'
            LIMIT 100
        ];
        
        // Create Contacts for these Accounts
        List<Contact> contacts = new List<Contact>();
        for(Account acc : accounts) {
            Contact con = new Contact();
            con.FirstName = 'Test';
            con.LastName = 'Contact';
            con.AccountId = acc.Id;
            con.Department = 'Technology';
            contacts.add(con);
        }
        insert contacts;
        
        // Act - change Industry
        for(Account acc : accounts) {
            acc.Industry = 'Retail';
        }
        
        Test.startTest();
        update accounts;
        Test.stopTest();
        
        // Assert - verify Contact Department updated
        List<Contact> updatedContacts = [
            SELECT Department 
            FROM Contact 
            WHERE AccountId IN :accounts
        ];
        
        System.assertEquals(100, updatedContacts.size());
        System.debug(updatedContacts.size());
        
        for(Contact con : updatedContacts) {
            System.assertEquals('Retail', con.Department, 'Department should match new Industry');
        }
    }
    
    // Test 5: Bulk scenario - 200+ records
    @isTest
    static void testBulkProcessing() {
        // Use data from @TestSetup
        List<Account> accounts = [SELECT Id, Industry FROM Account LIMIT 200];
        
        // Update all at once
        for(Account acc : accounts) {
            acc.Industry = 'Manufacturing';
        }
        
        Test.startTest();
        update accounts;
        Test.stopTest();
        
        // Verify no errors and all updated
        List<Account> updated = [
            SELECT Industry 
            FROM Account 
            WHERE Industry = 'Manufacturing'
        ];
        System.assertEquals(200, updated.size(), 'All 200 accounts should update');
    }
}