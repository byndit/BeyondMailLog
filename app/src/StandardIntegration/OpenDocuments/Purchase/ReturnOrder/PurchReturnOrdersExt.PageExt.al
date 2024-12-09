pageextension 53012 "PTE Purch. Return Orders Ext." extends "Purchase Return Orders"
{

    layout
    {
        addfirst(factboxes)
        {
            part(MailLog; "PTE Mail Logs Fb")
            {
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.MailLog.Page.SetRecID(Rec.RecordId());
    end;

}