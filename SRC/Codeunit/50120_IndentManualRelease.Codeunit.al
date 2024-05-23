codeunit 50120 "Indent Manual Release"
{
    TableNo = PurchaseRequestHeader;

    trigger OnRun()
    var
        ReleaseIndentDocument: Codeunit "Release Indent Document";
    begin
        ReleaseIndentDocument.PerformManualRelease(Rec);
    end;
}