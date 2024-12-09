pageextension 53012 "PTE Purch. Return Orders Ext." extends "Purchase Return Orders"
{

    layout
    {
        addfirst(factboxes)
        {
            part(MailLog; "Sent Emails List Part")
            {
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.MailLog.Page.UpdateData(Rec);
    end;

}