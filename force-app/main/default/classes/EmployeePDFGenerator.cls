public class EmployeePDFGenerator implements Queueable, Database.AllowsCallouts {
    private List<Id> empIds;
    public EmployeePDFGenerator(List<Id> ids){
         this.empIds = ids; 
        }

    public void execute(QueueableContext ctx){
        for (Id empId : empIds) {
            try {
                Employee__c emp = [SELECT Id, Name, Title__c, Email__c, Phone_Number__c, Address__c, Blood_Group__c, Date_Of_Birth__c FROM Employee__c WHERE Id = :empId];

                PageReference pr = Page.employeeCard;
                pr.getParameters().put('id', emp.Id);
                Blob pdfBlob = pr.getContentAsPDF(); 

                Attachment att = new Attachment(ParentId = emp.Id, Name = emp.Name + emp.Id, Body = pdfBlob, ContentType = 'application/pdf');
                insert att;

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { emp.Email__c });
                mail.setSubject('Your Employee ID Card');   
                mail.setPlainTextBody('Dear ' + emp.Name + ',\n\nAttached is your ID Card.');
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(emp.Name + emp.Id);
                efa.setBody(pdfBlob);
                efa.setContentType('application/pdf');
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa });
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

            } catch(Exception ex) {
                System.debug('PDF generation failed for ' + empId + ': ' + ex);
            }
        }
    }
}
