page 53004 "PTE Mail Log"
{
    ApplicationArea = All;
    Caption = 'Mail Log';
    PageType = Card;
    SourceTable = "PTE Mail Log";
    UsageCategory = None;
    DataCaptionExpression = GetCaption();
    InsertAllowed = false;
    DeleteAllowed = true;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = All;
                    ToolTip = 'Subject';
                    MultiLine = true;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the date and time when the certificate was entered for this employee.';
                }
                field(SystemCreatedBy; CreatedByName)
                {
                    ApplicationArea = All;
                    CaptionClass = Rec.FieldCaption(SystemCreatedBy);
                    Editable = false;
                    ToolTip = 'Specifies the name of the user who entered the certificate for this employee.';
                }
                field("To"; Rec."To")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'To';
                    MultiLine = true;
                }
                field(Cc; Rec.Cc)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Cc';
                    Visible = false;
                    MultiLine = true;
                }
                field(Bcc; Rec.Bcc)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Bcc';
                    Visible = false;
                    MultiLine = true;
                }
                field("No. of Attachments"; Rec."No. of Attachments")
                {
                    ApplicationArea = All;
                    ToolTip = 'No. of Attachments';
                    BlankZero = true;
                }
            }
        }
        area(FactBoxes)
        {
            part(Mail; "PTE Mail")
            {
                ApplicationArea = All;
                Editable = false;
                SubPageLink = "Entry No." = field("Entry No.");
                UpdatePropagation = Both;
            }
            part("Attachments"; "PTE Mail Attachments")
            {
                ApplicationArea = All;
                Editable = false;
                SubPageLink = "Entry No." = field("Entry No.");
                UpdatePropagation = Both;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        User: Record User;
    begin
        Clear(CreatedByName);
        User.SetLoadFields("User Name");
        if User.Get(Rec.SystemCreatedBy) then
            CreatedByName := User."User Name";
    end;

    internal procedure GetCaption(): Text
    begin
        exit(StrSubstNo('%1 - %2', CreatedByName, Rec.Subject));
    end;

    var
        CreatedByName: Text[50];
}