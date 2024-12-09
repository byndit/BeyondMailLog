pageextension 53000 "PTE Sales Blanket P. Order" extends "Blanket Purchase Order"
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