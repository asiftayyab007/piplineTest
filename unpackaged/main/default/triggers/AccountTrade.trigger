trigger AccountTrade on Account (before insert) {
    List<Account> accountsToSendEmail = new List<Account>();
    List<OrgWideEmailAddress> owea = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address = :System.Label.No_reply];
    Date today = Date.today();

    for (Account acc : Trigger.new) {
        if (acc.ETSALES_Trade_License_Expiry_Date__c != null && acc.ETSALES_Trade_License_Expiry_Date__c == today) {
            if (acc.OwnerId != null) {
                User owner = [SELECT IsActive FROM User WHERE Id = :acc.OwnerId LIMIT 1];
                if (owner != null && owner.IsActive) {
                    accountsToSendEmail.add(acc);
                }
            }
        }
    }

    if (!accountsToSendEmail.isEmpty()) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        // Construct email message
        for (Account acc : accountsToSendEmail) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Trade License Expiry Reminder');
            email.setToAddresses(new String[] { System.Label.No_reply });
            email.setOrgWideEmailAddressId(owea[0].Id); 
            String accountOwnerEmailBody = '<html><body>';
            accountOwnerEmailBody += '<p>Dear Account Onwer,</p>';
            accountOwnerEmailBody += '<p> Trade License Date is Expired now.</p>';
            accountOwnerEmailBody += '<p>Trade License Expiray Date: ' + '<strong>' + acc.ETSALES_Trade_License_Expiry_Date__c + '</strong>' + '</p>'; // Make Insurance Ref Number bold
            accountOwnerEmailBody += '<p>Account Name: ' + '<strong>' + acc.Name + '</strong>' + '</p>'; 
            accountOwnerEmailBody += '<p>Account Number: ' + '<strong>' + acc.AccountNumber + '</strong>' + '</p>'; // Make Employee Name bold
            accountOwnerEmailBody += '<p>Thank you.</p>';
            accountOwnerEmailBody += '</body></html>';

            email.setHtmlBody(accountOwnerEmailBody);
            emails.add(email);
        }

        // Send emails
        Messaging.sendEmail(emails);
    }
}