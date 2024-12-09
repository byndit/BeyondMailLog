pageextension 53046 "PTE Pstd. Return Shipment Ext." extends "Posted Return Shipment"
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