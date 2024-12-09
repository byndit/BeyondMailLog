codeunit 53001 "PTE Mail Preview Handler"
{
    Access = Internal;
    procedure ReadContent(Rec: Record "PTE Mail Log"): Text
    var
        Attachment: Record "PTE Mail Attachment";
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        HtmlContent: Text;
    begin
        if not CheckIsMail(Rec) then
            exit('');
        if not Rec.GetMainAttachment(Attachment) then
            exit('');
        Attachment.GetContent(TempBlob);
        TempBlob.CreateInStream(InStream);
        InStream.Read(HtmlContent);
        exit(HtmlContent);
    end;

    local procedure CheckIsMail(Rec: Record "PTE Mail Log"): Boolean
    begin
        Exit(Rec.GetMainAttachmentFileName().Contains('.html') and (Rec."Email Id" <> ''));
    end;

}