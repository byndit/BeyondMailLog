pageextension 53061 "PTE Sent Emails List Part" extends "Sent Emails List Part"
{
    internal procedure UpdateData(Document: Variant)
    var
        DataTypeManagement: Codeunit "Data Type Management";
        RecRef: RecordRef;
        EmptyGuid: Guid;
    begin
        if Rec.IsTemporary() then
            Rec.DeleteAll();
        if not DataTypeManagement.GetRecordRef(Document, RecRef) then
            exit;
        if GetSystemId(RecRef.Field(RecRef.SystemIdNo).Value) = EmptyGuid then begin
            CurrPage.Update(false);
            exit;
        end;
        SetRelatedRecord(Document);
        Load();
        CurrPage.Update(false);
    end;

    internal procedure GetSystemId(SystemID: Guid): Guid
    begin
        exit(SystemID);
    end;
}