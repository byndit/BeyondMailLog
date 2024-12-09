pageextension 53005 "PTE Purchase Invoices Ext." extends "Purchase Invoices"
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