codeunit 50124 ApprovalMgt
{

    procedure RunWorkflowOnSendIndentForApprovalCode(): Code[128]
    begin
        exit('RunWorkflowOnSendIndentDocForApproval'); //jay 
    end;

    procedure RunWorkflowOnCancelIndentApprovalRequestCode(): Code[128]
    begin
        exit('RunWorkflowOnCancelIndentApprovalRequest'); //jay
    end;

    procedure ShowIndentApprovalStatus(IndentHeader: Record PurchaseRequestHeader)
    var
        ApprovalMgt: Codeunit "Approvals Mgmt.";
    begin
        IndentHeader.FIND;
        CASE IndentHeader.Status OF
            IndentHeader.Status::Released:
                MESSAGE(DocStatusChangedMsg, IndentHeader.IndentNo, IndentHeader.Status);
            IndentHeader.Status::"Pending Approval":
                IF ApprovalMgt.HasOpenApprovalEntries(IndentHeader.RECORDID) THEN
                    MESSAGE(PendingApprovalMsg);
        END;
    end;

    procedure CheckPurchaseApprovalPossible(var indentHeader: Record PurchaseRequestHeader): Boolean
    begin
        if IsIndentApprovalsWorkflowEnabled(indentHeader) then
            Error(Nothingtoapprov);
        exit(true);
    end;

    procedure IsIndentApprovalsWorkflowEnabled(var indentHeader: Record PurchaseRequestHeader): Boolean
    var
        myInt: Integer;
    begin
        exit(WorkFLowManagement.CanExecuteWorkflow(indentHeader, RunWorkflowOnSendIndentForApprovalCode));
    end;

    //     CheckPurchaseApprovalsWorkflowEnabled(VAR PurchaseHeader : Record "Purchase Header") : Boolean
    // IF NOT IsPurchaseApprovalsWorkflowEnabled(PurchaseHeader) THEN
    //   ERROR(NoWorkflowEnabledErr);

    // EXIT(TRUE);

    //     LOCAL ShowIndentApprovalStatus(IndentHeader : Record "Indent Header")
    // IndentHeader.FIND;
    //  CASE IndentHeader."Approval Status" OF 
    //    IndentHeader."Approval Status"::Released:
    //      MESSAGE(DocStatusChangedMsg,IndentHeader."No.",IndentHeader."Approval Status");
    //    IndentHeader."Approval Status"::"Pending Approval":
    //      IF HasOpenApprovalEntries(IndentHeader.RECORDID) THEN
    //        MESSAGE(PendingApprovalMsg);
    //  END;
    [IntegrationEvent(false, false)]
    procedure onSendIndentForApproval(var IndentHeader: Record PurchaseRequestHeader)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure onCancelIndentForApproval(var IndentHeader: Record PurchaseRequestHeader)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ApprovalMgt, 'onSendIndentForApproval', '', true, true)]
    procedure RunWorkflowOnSendIndentDocForApproval(var IndentHeader: Record PurchaseRequestHeader)    //jay made loca to global
    begin
        WorkFLowManagement.HandleEvent(RunWorkflowOnSendIndentForApprovalCode, IndentHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ApprovalMgt, 'onCancelIndentForApproval', '', true, true)]
    procedure RunWorkflowOnCancelIndentApprovalRequest(var IndentHeader: Record PurchaseRequestHeader)
    begin
        WorkFLowManagement.HandleEvent(RunWorkflowOnCancelIndentApprovalRequestCode, IndentHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkFlowEventHandling.AddEventToLibrary(RunWorkflowOnSendIndentForApprovalCode, Database::PurchaseRequestHeader, PurchReqDocSendForApprovalEventDescTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(RunWorkflowOnCancelIndentApprovalRequestCode, Database::PurchaseRequestHeader, PurchDocApprReqCancelledEventDescTxt, 0, false);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelIndentApprovalRequestCode:
                WorkFlowEventHandling.AddEventPredecessor(RunWorkflowOnCancelIndentApprovalRequestCode, RunWorkflowOnSendIndentForApprovalCode);
            WorkFlowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                WorkFlowEventHandling.AddEventPredecessor(WorkFlowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendIndentForApprovalCode);
            WorkFlowEventHandling.RunWorkflowOnRejectApprovalRequestCode:
                WorkFlowEventHandling.AddEventPredecessor(WorkFlowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendIndentForApprovalCode);
            WorkFlowEventHandling.RunWorkflowOnDelegateApprovalRequestCode:
                WorkFlowEventHandling.AddEventPredecessor(WorkFlowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendIndentForApprovalCode);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeShowCommonApprovalStatus', '', false, false)]
    local procedure OnBeforeShowCommonApprovalStatus(var RecRef: RecordRef; var IsHandle: Boolean)
    var
        indentHeader: record PurchaseRequestHeader;
    begin
        case RecRef.Number of
            DATABASE::PurchaseRequestHeader:
                begin
                    RecRef.SetTable(indentHeader);
                    ShowIndentApprovalStatus(indentHeader);
                    IsHandle := true;
                end;
        end;
    end;


    //check
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        indentHeader: record PurchaseRequestHeader;
    begin
        case RecRef.Number of
            DATABASE::PurchaseRequestHeader:
                begin
                    RecRef.SetTable(indentHeader);
                    ApprovalEntryArgument."Document No." := Format(indentHeader.IndentNo);

                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    procedure SubOnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        indentHeader: record PurchaseRequestHeader;
    begin
        case RecRef.Number of
            DATABASE::PurchaseRequestHeader:
                begin
                    RecRef.SetTable(indentHeader);
                    indentHeader.Validate(Status, indentHeader.Status::"Pending Approval");
                    indentHeader.Modify(true);
                    Variant := indentHeader;
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        recRef: RecordRef;
        indentHeader: record PurchaseRequestHeader;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
    begin
        recRef.Get(ApprovalEntry."Record ID to Approve");
        case recRef.Number of
            DATABASE::PurchaseRequestHeader:
                begin
                    recRef.SetTable(indentHeader);
                    if not ApprovalMgt.HasOpenOrPendingApprovalEntries(ApprovalEntry."Record ID to Approve") then begin
                        indentHeader.Status := indentHeader.Status::Approved;
                        indentHeader.Modify();
                    end;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        recRef: RecordRef;
        indentHeader: record PurchaseRequestHeader;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
    begin
        recRef.Get(ApprovalEntry."Record ID to Approve");
        case recRef.Number of
            DATABASE::PurchaseRequestHeader:
                begin
                    recRef.SetTable(indentHeader);
                    indentHeader.Status := indentHeader.Status::Open;
                    indentHeader.Modify();
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        indentHeader: record PurchaseRequestHeader;
    begin
        case RecRef.Number of
            DATABASE::PurchaseRequestHeader:
                begin
                    RecRef.SetTable(indentHeader);
                    indentHeader.Validate(Status, indentHeader.Status::Released);
                    indentHeader.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        indentHeader: record PurchaseRequestHeader;
    begin
        case RecRef.Number of
            DATABASE::PurchaseRequestHeader:
                begin
                    RecRef.SetTable(indentHeader);
                    indentHeader.Validate(Status, indentHeader.Status::Open);
                    indentHeader.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnConditionalCardPageIDNotFound', '', true, true)]
    local procedure OnConditionalCardPageIDNotFound(RecordRef: RecordRef; var CardPageID: Integer)
    begin
        case RecordRef.Number of
            DATABASE::PurchaseRequestHeader:
                CardPageID := Page::PurchaseReqCardPage;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure SubOnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    begin
        case ResponseFunctionName of
            workflowResponseHandling.SendApprovalRequestForApprovalCode:
                workflowResponseHandling.AddResponsePredecessor(WorkFlowResponseHandling.SendApprovalRequestForApprovalCode, RunWorkflowOnSendIndentForApprovalCode);
            WorkFlowResponseHandling.SetStatusToPendingApprovalCode:
                WorkFlowResponseHandling.AddResponsePredecessor(WorkFlowResponseHandling.SetStatusToPendingApprovalCode, RunWorkflowOnSendIndentForApprovalCode);
            WorkFlowResponseHandling.CancelAllApprovalRequestsCode:
                WorkFlowResponseHandling.AddResponsePredecessor(WorkFlowResponseHandling.CancelAllApprovalRequestsCode, RunWorkflowOnCancelIndentApprovalRequestCode);
            WorkFlowResponseHandling.OpenDocumentCode:
                WorkFlowResponseHandling.AddResponsePredecessor(WorkFlowResponseHandling.OpenDocumentCode, RunWorkflowOnCancelIndentApprovalRequestCode);
            WorkFlowResponseHandling.CreateApprovalRequestsCode:
                WorkFlowResponseHandling.AddResponsePredecessor(WorkFlowResponseHandling.CreateApprovalRequestsCode, RunWorkflowOnSendIndentForApprovalCode);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnBeforeReleaseDocument', '', false, false)]
    local procedure ReleaseDocument(VAR Variant: Variant)
    var
        RecRef: RecordRef;
        indentHeader: Record PurchaseRequestHeader;
    begin
        case RecRef.Number of
            DATABASE::PurchaseRequestHeader:
                begin
                    RecRef.SetTable(indentHeader);
                    indentHeader.Validate(Status, indentHeader.Status::Released);
                    indentHeader.Modify();
                    Variant := indentHeader;
                end;
        end;
    end;

    var
        WorkFlowEventHandling: Codeunit "Workflow Event Handling";
        WorkFlowResponseHandling: Codeunit "Workflow Response Handling";
        WorkFLowManagement: Codeunit "Workflow Management";
        PurchDocReleasedEventDescTxt: Label 'Indent is Realeased';
        pendingApprovalMsg: Label 'An approval request for indent has been sent';
        PurchDocApprReqCancelledEventDescTxt: Label 'An approval request for indent has been cancelled';
        noWorkfloeEnabelledError: Label 'No approval workflow for this record type is enabled';
        PurchReqDocSendForApprovalEventDescTxt: Label 'Approval of a Indent is requested';
        Nothingtoapprov: Label 'There is nothing to approve.';
        DocStatusChangedMsg: Label '%1 %2 has been automatically approved. The status has been changed to %3.';

}