trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
    TriggerDispatcher.run('ContentDocumentLink', 'afterInsert', Trigger.new);
}
