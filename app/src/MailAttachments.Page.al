page 53001 "PTE Mail Attachments"
{
    ApplicationArea = All;
    Caption = 'Attachments';
    PageType = ListPart;
    SourceTable = "PTE Mail Attachment";
    SourceTableView = where(Main = filter(false));
    ShowFilter = false;
    Editable = false;
    UsageCategory = None;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'File Name';
                    trigger OnDrillDown()
                    begin
                        Rec.Download();
                    end;
                }
            }
        }
    }
}
