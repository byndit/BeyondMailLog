table 53000 "PTE Mail Attachment"
{
    Access = Internal;
    Caption = 'Mail Attachment';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = ' Entry No.';
            TableRelation = "PTE Mail Log";
            DataClassification = SystemMetadata;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = SystemMetadata;
        }
        field(7; "File Name"; Text[2048])
        {
            Caption = 'File Name';
        }
        field(8; Content; BLOB)
        {
            Caption = 'Content';
            SubType = Bitmap;
        }
        field(15; Main; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Main';
        }
    }

    keys
    {
        key(PK; "Entry No.", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure GetContent(var TempBlob: Codeunit "Temp Blob"): Boolean
    begin
        if "Entry No." = 0 then
            exit(false);
        if "Line No." = 0 then
            exit(false);
        if not TempBlob.HasValue() then
            TempBlob.FromRecord(Rec, FieldNo(Content));
        exit(TempBlob.HasValue());
    end;

    procedure Download(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
    begin
        if not GetContent(TempBlob) then
            exit;

        exit(FileMgt.BLOBExportWithEncoding(TempBlob, Rec."File Name", true, TextEncoding::MSDos));
    end;
}