page 53003 "PTE Mail Logs Fb"
{
    ApplicationArea = All;
    Caption = 'Logs';
    PageType = ListPart;
    SourceTable = "PTE Mail Log";
    UsageCategory = None;
    Editable = false;
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
    }
    actions
    {
        area(Processing)
        {
            action("Preview")
            {
                ApplicationArea = All;
                Caption = 'Preview';
                Image = "View";
                ToolTip = 'Download the file.';

                trigger OnAction()
                var
                    MailLog: Record "PTE Mail Log";
                    PageManagement: Codeunit "Page Management";
                begin
                    if MailLog.Get(Rec."Entry No.") then begin
                        MailLog.SetRecFilter();
                        PageManagement.PageRun(MailLog);
                    end;
                end;
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
        v: Page 8883;
    begin
        Clear(CreatedByName);
        User.SetLoadFields("User Name");
        if User.Get(Rec.SystemCreatedBy) then
            CreatedByName := User."User Name";
    end;

    internal procedure SetRecID(Recid: RecordId)
    var
        EmptyRecId: RecordId;
    begin
        Rec.FilterGroup := 4;
        Rec.SetRange("Record ID", RecID);
        if Rec.IsEmpty() then
            Rec.SetRange("Record Id", EmptyRecId);
        Rec.FilterGroup := 0;
        CurrPage.Update(false);
    end;

    var
        CreatedByName: Text[50];
}
