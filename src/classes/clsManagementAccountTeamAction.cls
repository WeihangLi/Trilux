public with sharing class clsManagementAccountTeamAction {
    @InvocableMethod(label='Insert Account Team Member' description='Insert Account Team Member')
	public static void insertAccountTeamMember(List<ID> ids) {
		ClsTerritoryManagementUtil.deleteAccountTeamMember(ids);
	    ClsTerritoryManagementUtil.insertAccountTeamMember(ids);
	}
}