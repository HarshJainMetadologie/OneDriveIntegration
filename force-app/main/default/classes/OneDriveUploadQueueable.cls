public class OneDriveUploadQueueable implements Queueable, Database.AllowsCallouts {
    private String fileName;
    private Blob fileBody;

    public OneDriveUploadQueueable(String fileName, Blob fileBody) {
        this.fileName = fileName;
        this.fileBody = fileBody;
    }

    public void execute(QueueableContext qc) {
        uploadOneDrive.uploadFile(fileName, fileBody);
    }
}
