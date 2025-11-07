public with sharing class uploadOneDrive {
    public static void uploadFile(String fileName, Blob fileBody) {
        try {
            String endpoint = 'callout:OneDriveIntegrationNC'+'/me/drive/root:/EmployeeDetails/' + fileName + '.pdf:/content';

            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('PUT');
            req.setHeader('Content-Type', 'application/pdf');
            req.setBodyAsBlob(fileBody);

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
                System.debug('File uploaded successfully: ' + fileName);
            } else {
                System.debug('Upload failed. Status: ' + res.getStatus() + ' Body: ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug('OneDrive upload error: ' + e.getMessage());
        }
    }
}