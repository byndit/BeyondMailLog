page 53002 "PTE Mail Logs"
{
    ApplicationArea = All;
    Caption = 'Mail Logs';
    PageType = List;
    SourceTable = "PTE Mail Log";
    SourceTableView = order(descending);
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = true;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
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
                }
                field(Cc; Rec.Cc)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Cc';
                    Visible = false;
                }
                field(Bcc; Rec.Bcc)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Bcc';
                    Visible = false;
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = All;
                    ToolTip = 'Subject';
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

    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey(SystemCreatedAt);
        Rec.Ascending := false;
    end;

    trigger OnAfterGetRecord()
    var
        User: Record User;
    begin
        Clear(CreatedByName);
        User.SetLoadFields("User Name");
        if User.Get(Rec.SystemCreatedBy) then
            CreatedByName := User."User Name";
    end;

    var
        CreatedByName: Text[50];
}
