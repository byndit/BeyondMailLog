codeunit 53000 "PTE Mail Log Mgt."
{
    Access = Internal;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Mail Management", 'OnSendViaEmailModuleOnAfterEmailSend', '', false, false)]
    local procedure MailManagementOnSendViaEmailModuleOnAfterEmailSend(var Cancelled: Boolean; var HideEmailSendingError: Boolean; var MailSent: Boolean; var Message: Codeunit "Email Message"; var TempEmailItem: Record "Email Item")
    var
        IncomingDocumentAttachment: Record "PTE Mail Attachment";
        MailLog: Record "PTE Mail Log";
        Attachment: Codeunit "Temp Blob";
        Attachments: Codeunit "Temp Blob List";
        RecId: RecordId;
        RecRef: RecordRef;
        SourceID: Guid;
        AttachmentStream: InStream;
        BodyInStream: InStream;
        TableId: Integer;
        SourceIDs: List of [Guid];
        SourceRelationTypes, SourceTableIDs : List of [Integer];
        AttachmentNames: List of [Text];
        BCCRecipients: List of [Text];
        CCRecipients: List of [Text];
        ToRecipients: List of [Text];
        OutStr: OutStream;
        EmptyGuid: Guid;
    begin
        if not MailSent then
            exit;

        TempEmailItem.GetSourceDocuments(SourceTableIDs, SourceIDs, SourceRelationTypes);
        if SourceIDs.Count() = 0 then
            exit;
        if SourceTableIDs.Count() = 0 then
            exit;

        TableId := SourceTableIDs.Get(1);
        SourceID := SourceIDs.Get(1);

        if TableId = 0 then
            exit;
        if SourceID = EmptyGuid then
            exit;

        RecRef.Open(TableId);
        if not RecRef.GetBySystemId(SourceID) then
            exit;
        RecId := RecRef.RecordId();
        RecRef.Close();

        MailLog.SetCurrentKey("Email Id");
        MailLog.SetRange("Email Id", Message.GetId());
        if not MailLog.IsEmpty() then
            exit;
        Clear(MailLog);

        MailLog.Log(Message.GetSubject());
        MailLog."Email Id" := Message.GetId();
        MailLog."Record Id" := RecId;
        MailLog.Modify();

        if Message.GetBody() <> '' then begin
            Attachment.CreateOutStream(OutStr, TextEncoding::MSDos);
            OutStr.Write(Message.GetBody());
            Attachment.CreateInStream(BodyInStream, TextEncoding::MSDos);
            MailLog.AddFromStream(IncomingDocumentAttachment, 'Body.html', true, BodyInStream);
        end;

        Message.GetRecipients(Enum::"Email Recipient Type"::"To", ToRecipients);
        MailLog."To" := CopyStr(FormatListToString(ToRecipients, ';'), 1, MaxStrLen(MailLog."To"));

        Message.GetRecipients(Enum::"Email Recipient Type"::"Cc", CCRecipients);
        MailLog."Cc" := CopyStr(FormatListToString(CCRecipients, ';'), 1, MaxStrLen(MailLog."Cc"));

        Message.GetRecipients(Enum::"Email Recipient Type"::"Bcc", BCCRecipients);
        MailLog."Bcc" := CopyStr(FormatListToString(BCCRecipients, ';'), 1, MaxStrLen(MailLog."Bcc"));

        TempEmailItem.GetAttachments(Attachments, AttachmentNames);
        MailLog."No. of Attachments" := Attachments.Count();
        MailLog.Modify();

        if MailLog."No. of Attachments" = 0 then
            exit;

        if Message.Attachments_First() then
            repeat
                Message.Attachments_GetContent(AttachmentStream);
                MailLog.AddFromStream(IncomingDocumentAttachment, Message.Attachments_GetName(), false, AttachmentStream);
            until Message.Attachments_Next() = 0;
    end;

    local procedure FormatListToString(List: List of [Text]; Delimiter: Text) String: Text
    var
        Address: Text;
        Counter: Integer;
    begin
        if List.Count() > 0 then begin
            String += List.Get(1);
            for Counter := 2 to List.Count() do begin
                Address := List.Get(Counter);
                String += StrSubstNo('%1 %2', Delimiter, Address);
            end;
        end;
    end;
}

