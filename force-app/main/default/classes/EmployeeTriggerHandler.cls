public with sharing class EmployeeTriggerHandler {

    public static void afterUpdate(List<Employee__c> newList, Map<Id, Employee__c> oldMap) {
        Set<Id> updatedEmployeeIds = new Set<Id>();

        for (Employee__c emp : newList) {
            Employee__c oldEmp = oldMap.get(emp.Id);
                updatedEmployeeIds.add(emp.Id);
        }

        if (!updatedEmployeeIds.isEmpty()) {
            System.enqueueJob(new EmployeePDFGenerator(new List<Id>(updatedEmployeeIds)));
        }
    }
}
