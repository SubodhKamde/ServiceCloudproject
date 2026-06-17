// File 2: AccountHandler.cls (SEPARATE FILE - NOT IN TRIGGER)
public class AccountHandler {
    
    // Before insert - set defaults and validate
    public static void beforeInsert(List<Account> newRecords) {
        validateRecords(newRecords);
        setDefaultValues(newRecords);
    }
    
    // Before update - check what changed
    public static void beforeUpdate(List<Account> newRecords, Map<Id, Account> oldMap) {
        for(Account acc : newRecords) {
            Account oldAccount = oldMap.get(acc.Id);
            
            // Check if specific field changed
            if(acc.Industry != oldAccount.Industry) {
                // Do something when Industry changes
            }
        }
    }
    
    // After insert - create related records
    public static void afterInsert(List<Account> newRecords) {
        createDefaultContacts(newRecords);
    }
    
    // After update - update related records
    public static void afterUpdate(List<Account> newRecords, Map<Id, Account> oldMap) {
        updateRelatedContacts(newRecords, oldMap);
    }
    
    // Helper method: Validation
    private static void validateRecords(List<Account> records) {
        for(Account acc : records) {
            if(String.isBlank(acc.Name)) {
                acc.addError('Name is required');
            }
        }
    }
    
    // Helper method: Set defaults
    private static void setDefaultValues(List<Account> records) {
        for(Account acc : records) {
            if(acc.Rating == null) {
                acc.Rating = 'Cold';
            }
        }
    }
    
    // Helper method: Create related records
    private static void createDefaultContacts(List<Account> accounts) {
        List<Contact> contactsToInsert = new List<Contact>();
        
        for(Account acc : accounts) {
            Contact con = new Contact();
            con.FirstName = 'Default';
            con.LastName = 'Contact';
            con.AccountId = acc.Id;
            contactsToInsert.add(con);
        }
        
        if(!contactsToInsert.isEmpty()) {
            insert contactsToInsert;
        }
    }
    
    // Helper method: Update related records (BULKIFIED PATTERN)
    private static void updateRelatedContacts(List<Account> newAccounts, Map<Id, Account> oldMap) {
        
        // Step 1: Collect Account IDs where Industry changed
        Set<Id> accountIdsToUpdate = new Set<Id>();
        Map<Id, String> accountIdToNewIndustry = new Map<Id, String>();
        
        for(Account acc : newAccounts) {
            Account oldAcc = oldMap.get(acc.Id);
            if(acc.Industry != oldAcc.Industry) {
                accountIdsToUpdate.add(acc.Id);
                accountIdToNewIndustry.put(acc.Id, acc.Industry);
            }
        }
        
        if(accountIdsToUpdate.isEmpty()) {
            return;  // Nothing to update
        }
        
        // Step 2: Query related Contacts (SINGLE SOQL)
        List<Contact> contactsToUpdate = [
            SELECT Id, AccountId, Department
            FROM Contact
            WHERE AccountId IN :accountIdsToUpdate
        ];
        
        // Step 3: Update Contact fields
        for(Contact con : contactsToUpdate) {
            con.Department = accountIdToNewIndustry.get(con.AccountId);
        }
        
        // Step 4: Single DML
        if(!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}