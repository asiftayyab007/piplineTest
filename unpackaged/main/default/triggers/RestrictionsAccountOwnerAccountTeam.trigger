trigger RestrictionsAccountOwnerAccountTeam on AccountTeamMember (before insert, before update) {
    for (AccountTeamMember atm : Trigger.new) {
        // Check if the action is adding a team member
        if (atm.TeamMemberRole != null && atm.TeamMemberRole != '') {
            // Retrieve the Account owner
            Account account = [SELECT OwnerId FROM Account WHERE Id = :atm.AccountId LIMIT 1];
            
            // Check if the current user is the Account owner
            if (account.OwnerId == UserInfo.getUserId()) {
                atm.addError('Account Owner is restricted to add Account Team members.');
            }
        }
    }
}