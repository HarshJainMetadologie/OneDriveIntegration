public with sharing class EmployeeController {
    public Employee__c employee { get; set; }
    public String imageUrl { get; set; }

    public EmployeeController(ApexPages.StandardController stdCtrl) {
        employee = (Employee__c) stdCtrl.getRecord();
        List<ContentDocumentLink> links = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :employee.Id ORDER BY SystemModstamp DESC LIMIT 1];
        if (!links.isEmpty()) {
            String docId = links[0].ContentDocumentId;
            ContentVersion ver = [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :docId ORDER BY VersionNumber DESC LIMIT 1];

            imageUrl = '/sfc/servlet.shepherd/version/download/' + ver.Id;
        } 
    }
}