codeunit 50123 ProcessLogicCodeunit
{
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Req. Wksh.-Make Order", 'OnAfterInsertPurchOrderHeader', '', true, true)]
    local procedure OnAfterInsertPurchOrderHeader(var RequisitionLine: Record "Requisition Line"; var PurchaseOrderHeader: Record "Purchase Header"; CommitIsSuppressed: Boolean; SpecialOrder: Boolean)
    begin
        PurchaseOrderHeader."Indent No" := RequisitionLine.IndentNo;
    end;

    var
        myInt: Integer;
}