({
     addAccountRecord: function(component, event) {
               //get the account List from component  
        var accountList = component.get("v.accountList");
        //Add New Account Record
        accountList.push({
            'sobjectType': 'Account',
            'Name': '',
            'Phone': '',
            'Fax': '',
            'Website ': '', 
            
        });
        component.set("v.accountList", accountList);
    },
    validateAccountRecords: function(component, event) {
        //Validate all account records
        var isValid = true;
        var accountList = component.get("v.accountList");
        for (var i = 0; i < accountList.length; i++) {
            if (accountList[i].Name == '') {
                isValid = false;
                alert('Account Name cannot be blank on '+(i + 1)+' row number');
            }
        }
        return isValid;
    },
})