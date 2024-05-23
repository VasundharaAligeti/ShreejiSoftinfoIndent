codeunit 50121 "Release Indent Document"
{
    var
        PreviewMode: Boolean;
        Text003: Label 'The approval process must be cancelled or completed to reopen this document.';
        SkipWhseRequestOperations: Boolean;

    procedure PerformManualRelease(var IndentHeader: Record PurchaseRequestHeader)
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
    begin
        OnPerformManualReleaseOnBeforeTestIndentPrepayment(IndentHeader, PreviewMode);
        // if PrepaymentMgt.TestPurchasePrepayment(PurchHeader) then
        //     Error(UnpostedPrepaymentAmountsErr, PurchHeader."Document Type", PurchHeader."No.");

        OnBeforeManualReleaseIndentDoc(IndentHeader, PreviewMode);
        //PerformManualCheckAndRelease(PurchHeader);
        if IndentHeader.Status = IndentHeader.Status::Released then
            exit;
        IndentHeader.Status := IndentHeader.Status::Released;
        OnAfterManualReleaseIndentDoc(IndentHeader, PreviewMode);
    end;

    procedure PerformManualReopen(var IndentHeader: Record PurchaseRequestHeader)
    begin
        if IndentHeader.Status = IndentHeader.Status::"Pending Approval" then
            Error(Text003);

        OnBeforeManualReopenIndentDoc(IndentHeader, PreviewMode);
        Reopen(IndentHeader);
        OnAfterManualReopenIndentDoc(IndentHeader, PreviewMode);
    end;

    procedure Reopen(var IndentHeader: Record PurchaseRequestHeader)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeReopenIndentDoc(IndentHeader, PreviewMode, IsHandled, SkipWhseRequestOperations);
        if IsHandled then
            exit;

        if IndentHeader.Status = IndentHeader.Status::Open then
            exit;
        // if PurchHeader."Document Type" in [PurchHeader."Document Type"::Order, PurchHeader."Document Type"::"Return Order"] then
        //     if not SkipWhseRequestOperations then
        //         WhsePurchRelease.Reopen(PurchHeader);
        IndentHeader.Status := IndentHeader.Status::Open;
        OnReopenOnBeforeIndentHeaderModify(IndentHeader);
        IndentHeader.Modify(true);

        OnAfterReopenIndentDoc(IndentHeader, PreviewMode, SkipWhseRequestOperations);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPerformManualReleaseOnBeforeTestIndentPrepayment(var IndentHeader: Record PurchaseRequestHeader; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeManualReleaseIndentDoc(var IndentHeader: Record PurchaseRequestHeader; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterManualReleaseIndentDoc(var IndentHeader: Record PurchaseRequestHeader; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeManualReopenIndentDoc(var IndentHeader: Record PurchaseRequestHeader; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnReopenOnBeforeIndentHeaderModify(var IndentHeader: Record PurchaseRequestHeader)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReopenIndentDoc(var IndentHeader: Record PurchaseRequestHeader; PreviewMode: Boolean; SkipWhseRequestOperations: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReopenIndentDoc(var IndentHeader: Record PurchaseRequestHeader; PreviewMode: Boolean; var IsHandled: Boolean; SkipWhseRequestOperations: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterManualReopenIndentDoc(var IndentHeader: Record PurchaseRequestHeader; PreviewMode: Boolean)
    begin
    end;

    var
        myInt: Integer;
}