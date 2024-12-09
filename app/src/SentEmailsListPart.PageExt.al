pageextension 53061 "PTE Sent Emails List Part" extends "Sent Emails List Part"
{
    procedure UpdateData(Document: Variant)
    begin
        if Rec.IsTemporary() then
            Rec.DeleteAll();
        SetRelatedRecord(Document);
        Load();
        CurrPage.Update(false);
    end;
}