pageextension 53031 "PTE Service Quote Ext." extends "Service Quote"
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