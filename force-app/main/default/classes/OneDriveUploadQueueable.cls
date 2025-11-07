public class OneDriveUploadQueueable implements Queueable, Database.AllowsCallouts {
    private String fileName;
    private Blob fileBody;
    private String folderName;

    public OneDriveUploadQueueable(String fileName, Blob fileBody, String folderName) {
        this.fileName = fileName;
        this.fileBody = fileBody;
        this.folderName = folderName;
    }

    public void execute(QueueableContext qc) {
        uploadOneDrive.uploadFile(fileName, fileBody, folderName);
    }
}
