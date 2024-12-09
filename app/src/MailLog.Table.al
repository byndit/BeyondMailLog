table 53001 "PTE Mail Log"
{
    DataClassification = CustomerContent;
    Caption = 'Mail Log';
    DrillDownPageId = "PTE Mail Logs";
    LookupPageId = "PTE Mail Log";
    Access = Internal;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(9; "Record Id"; RecordId)
        {
            DataClassification = SystemMetadata;
            Caption = 'Record Id';
        }
        field(10; "Email Id"; Text[152])
        {
            DataClassification = SystemMetadata;
            Caption = 'Email Id';
        }
        field(12; Subject; Text[2048])
        {
            Caption = 'Description';
        }
        field(13; "To"; Text[2048])
        {
            Caption = 'To';
        }
        field(14; Cc; Text[2048])
        {
            Caption = 'Cc';
        }
        field(15; Bcc; Text[2048])
        {
            Caption = 'Bcc';
        }
        field(20; "No. of Attachments"; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'No. of Attachments';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(SK; "Email Id")
        {
        }
        key(SK2; "Record Id")
        {
        }
    }

    trigger OnDelete()
    var
        MailAttachment: Record "PTE Mail Attachment";
    begin
        MailAttachment.SetRange("Entry No.", "Entry No.");
        if not MailAttachment.IsEmpty() then
            MailAttachment.DeleteAll();
    end;

    internal procedure Log(NewDescription: Text): Integer
    begin
        Reset();
        Clear(Rec);
        Init();
        Subject := CopyStr(NewDescription, 1, MaxStrLen(Subject));
        Insert(true);
        exit("Entry No.");
    end;


    internal procedure AddFromStream(var Attachment: Record "PTE Mail Attachment"; OrgFileName: Text; Main: Boolean; var InStr: InStream)
    var
        OutStr: OutStream;
    begin
        TestField("Entry No.");
        Attachment.SetRange("Entry No.", "Entry No.");
        if Attachment.FindLast() then
            Attachment."Line No." += 10000
        else
            Attachment."Line No." := 10000;
        Attachment."Entry No." := "Entry No.";
        Attachment.Main := Main;
        Attachment."File Name" := CopyStr(OrgFileName, 1, MaxStrLen(Attachment."File Name"));
        Attachment.Content.CreateOutStream(OutStr, TextEncoding::Windows);
        CopyStream(OutStr, InStr);
        Attachment.Insert(true);
    end;

    internal procedure GetMainAttachmentFileName(): Text
    var
        MailAttachment: Record "PTE Mail Attachment";
    begin
        if GetMainAttachment(MailAttachment) then
            exit(MailAttachment."File Name");
        exit('');
    end;

    internal procedure GetMainAttachment(var MailAttachment: Record "PTE Mail Attachment"): Boolean
    begin
        MailAttachment.SetRange("Entry No.", "Entry No.");
        MailAttachment.SetRange("Main", true);
        exit(MailAttachment.FindFirst())
    end;
}