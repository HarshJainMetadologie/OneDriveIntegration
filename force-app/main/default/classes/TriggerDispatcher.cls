public with sharing class TriggerDispatcher {
    public static void run(String objectName, String eventName, List<SObject> newList) {
        if (objectName == 'ContentDocumentLink' && eventName == 'afterInsert') {
            ContentDocumentLinkTriggerHandler.afterInsert((List<ContentDocumentLink>) newList);
        }
    }
}
