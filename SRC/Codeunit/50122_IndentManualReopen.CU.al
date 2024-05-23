codeunit 50122 "Indent Manual Reopen"
{
    TableNo = PurchaseRequestHeader;

    trigger OnRun()
    var
        ReleaseIndentDocument: Codeunit "Release Indent Document";
    begin
        ReleaseIndentDocument.PerformManualReopen(Rec);
    end;
}