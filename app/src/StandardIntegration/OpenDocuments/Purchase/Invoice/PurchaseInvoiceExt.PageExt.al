pageextension 53004 "PTE Purchase Invoice Ext." extends "Purchase Invoice"
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