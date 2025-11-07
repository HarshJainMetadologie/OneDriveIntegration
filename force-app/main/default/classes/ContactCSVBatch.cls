global with sharing class ContactCSVBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    global List<String> csvRowValues = new List<String>();
    global String csvHeader = 'First Name,Last Name,Email,Phone,Account Name\n';
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, FirstName, LastName, Email, Phone, Account.Name from Contact where AccountId != null]);
    }

    global void execute(Database.BatchableContext bc, List<Contact> scope){
        for (Contact con : scope) {
            String firstName = escapeCsvValue(con.FirstName);
            String lastName = escapeCsvValue(con.LastName);
            String email = escapeCsvValue(con.Email);
            String phone = escapeCsvValue(con.Phone);
            String accountName = escapeCsvValue(con.Account.Name);
            String csvRow = firstName + ',' + lastName + ',' + email + ',' + phone + ',' + accountName;
            csvRowValues.add(csvRow);
        }
    }
    private String escapeCsvValue(String value) {
        if (value == null) return '';
        value = value.replaceAll('"', '""');
        return '"' + value + '"';
    }

    global void finish(Database.BatchableContext bc){
        String csvFileContent = csvHeader + String.join(csvRowValues, '\n');
        String fileName = 'ContactExport_' + Datetime.now().format('yyyy_MM_dd_HH_mm_ss');
        uploadFileToOneDrive(fileName, csvFileContent);
        System.debug('Loaded File uploaded to OneDrive successfully.');
    }

    private void uploadFileToOneDrive(String fileName, String fileContent) {
        HttpRequest req = new HttpRequest();
        String endpoint = 'callout:OneDriveIntegrationNC' + '/me/drive/root:/SalesforceContactRecord/' + fileName + '.csv:/content';
        
        //req.setEndpoint(endpoint);
        req.setMethod('PUT'); 
        req.setHeader('Content-Type', 'text/csv');
        //req.setBodyAsBlob(EncodingUtil.base64Decode(fileContent));
        req.setBody(fileContent);
        Http http = new Http();
        try {
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
                System.debug('Successfully uploaded file to OneDrive: ' + res.getBody());
            } else {
                System.debug('Failed to upload file to OneDrive. Status Code: ' + res.getStatusCode() + ' Body: ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug('An error occurred during OneDrive file upload: ' + e.getMessage());
        }
    }


        // String csvFileContent = csvHeader + String.join(csvRowValues, '\n');
        // ContentVersion cv = new ContentVersion();
        // cv.Title = 'ContactExport_' + Datetime.now().format('yyyy_MM_dd_HH_mm_ss') + '.csv';
        // cv.PathOnClient = cv.Title;
        // cv.VersionData = Blob.valueOf(csvFileContent);
        // cv.Origin = 'H';
        // insert cv;
    //}   
}