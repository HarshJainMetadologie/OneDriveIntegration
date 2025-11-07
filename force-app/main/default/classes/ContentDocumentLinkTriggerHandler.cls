public with sharing class ContentDocumentLinkTriggerHandler {

    public static void afterInsert(List<ContentDocumentLink> newList) {
        Set<Id> employeeIds = new Set<Id>();

        for (ContentDocumentLink cdl : newList) {
            if (cdl.LinkedEntityId != null &&
                cdl.LinkedEntityId.getSObjectType() == Employee__c.SObjectType) {
                employeeIds.add(cdl.LinkedEntityId);
            }
        }

        if (!employeeIds.isEmpty()) {
            enqueueEmployeeJobs(employeeIds);
        }
    }

    private static void enqueueEmployeeJobs(Set<Id> empIds) {
        try {
            System.enqueueJob(new EmployeeControllerQueueable(new List<Id>(empIds)));
        } catch (Exception ex) {
            System.debug('Error enqueuing EmployeeControllerQueueable: ' + ex.getMessage());
        }
    }
}
