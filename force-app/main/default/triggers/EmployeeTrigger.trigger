trigger EmployeeTrigger on Employee__c (after insert) {
    List<Id> ids = new List<Id>();
    for (Employee__c e : Trigger.new) {
        if (e.Email__c != null) ids.add(e.Id);
    }
    if (!ids.isEmpty()) {
        //System.enqueueJob(new EmployeePDFGenerator(ids));
    }
}