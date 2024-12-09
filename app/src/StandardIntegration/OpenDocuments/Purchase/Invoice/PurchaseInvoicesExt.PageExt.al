pageextension 53005 "PTE Purchase Invoices Ext." extends "Purchase Invoices"
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