public class EmployeeControllerQueueable implements Queueable, Database.AllowsCallouts {
    private List<Id> empIds;
    public EmployeeControllerQueueable(List<Id> ids) {
        this.empIds = ids;
    }

    public void execute(QueueableContext qc) {
        List<Employee__c> employees = [SELECT Id, Name, Email__c, Title__c, Phone_Number__c, Address__c,Blood_Group__c, Date_Of_Birth__c FROM Employee__c WHERE Id IN :empIds];

        for (Employee__c emp : employees) {
            try {
                PageReference pageRef = Page.employeeCard;
                pageRef.getParameters().put('id', emp.Id);
                Blob pdfBlob = pageRef.getContentAsPDF();

                Attachment att = new Attachment(ParentId = emp.Id, Name = emp.Name + emp.Id + '.pdf', Body = pdfBlob, ContentType = 'application/pdf');
                insert att;

                System.enqueueJob(new OneDriveUploadQueueable(emp.Name + emp.Id, pdfBlob,'EmployeeDetails'));

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { emp.Email__c }); 
                mail.setSubject('Your Employee ID Card');
                mail.setPlainTextBody('Dear ' + emp.Name + ',\n\nPlease find attached your ID card.');
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(emp.Name + emp.ID +'.pdf');
                efa.setBody(pdfBlob);
                efa.setContentType('application/pdf');
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa });
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            } catch (Exception e) {
                System.debug('Error generating ID card for ' + emp.Id + ': ' + e.getMessage());
            }
        }
    }
}
