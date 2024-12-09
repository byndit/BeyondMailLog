page 53000 "PTE Mail"
{
    ApplicationArea = All;
    Caption = 'Mail';
    PageType = CardPart;
    SourceTable = "PTE Mail Log";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;
                usercontrol(WebPageViewer; WebPageViewer)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.WebPageViewer.SetContent(PreviewHandler.ReadContent(Rec));
    end;

    var
        PreviewHandler: Codeunit "PTE Mail Preview Handler";
}
