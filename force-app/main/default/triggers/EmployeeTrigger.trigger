trigger EmployeeTrigger on Employee__c (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        //EmployeeTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
    }
}
