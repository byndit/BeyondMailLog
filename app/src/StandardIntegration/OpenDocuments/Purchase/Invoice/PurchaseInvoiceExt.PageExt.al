pageextension 53004 "PTE Purchase Invoice Ext." extends "Purchase Invoice"
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