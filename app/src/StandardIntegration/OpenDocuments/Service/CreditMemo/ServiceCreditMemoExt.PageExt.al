pageextension 53025 "PTE Service Credit Memo Ext." extends "Service Credit Memo"
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