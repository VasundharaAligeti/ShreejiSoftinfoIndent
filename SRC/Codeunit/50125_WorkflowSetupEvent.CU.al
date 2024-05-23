codeunit 50125 WorkflowSetupEvent
{

    local procedure InsertIndentApprovalWorkFLowTemplete()
    var
        workflow: record Workflow;
    begin
        WorkFLowSetup.InsertWorkflowTemplate(workflow, IndentWorkflowCodeTxt, IndnetCategoryDescTxt, IndnetCategoryTxt);
        InsertIndentWorkflowDetails(workflow);
        WorkFLowSetup.MarkWorkflowAsTemplate(workflow);
    end;

    local procedure InsertIndentWorkflowDetails(var Workflow: Record Workflow)
    var
        workflowStepArgument: Record "Workflow Step Argument";
        indentHeader: Record PurchaseRequestHeader;
        BlankDateFormula: DateFormula;
    begin
        WorkFLowSetup.InitWorkflowStepArgument(workflowStepArgument, workflowStepArgument."Approver Type"::"Workflow User Group", workflowStepArgument."Approver Limit Type"::"Direct Approver", 0, '', BlankDateFormula, true);
        indentHeader.Init();

        WorkFLowSetup.InsertDocApprovalWorkflowSteps(Workflow,
        BuildIndentPrepTypeConditions(Enum::"Indent Document Status"::Open),
        workfloweventhandlingExt.RunWorkflowOnSendIndentForApprovalCode,
        BuildIndentPrepTypeConditions(Enum::"Indent Document Status"::"Pending Approval"),
        workfloweventhandlingExt.RunWorkflowOnCancelIndentApprovalRequestCode,
        WorkflowStepArgument, TRUE);
    end;
    //  InsertDocApprovalWorkflowSteps(
    //           Workflow,
    //           BuildIncomingDocumentTypeConditions(IncomingDocument.Status::New),
    //           WorkflowEventHandling.RunWorkflowOnSendIncomingDocForApprovalCode(),
    //           BuildIncomingDocumentTypeConditions(IncomingDocument.Status::"Pending Approval"),
    //           WorkflowEventHandling.RunWorkflowOnCancelIncomingDocApprovalRequestCode(),
    //           WorkflowStepArgument, true);
    procedure BuildIndentPrepTypeConditions(Status: Enum "Indent Document Status"): Text
    var
        IndentHeader: Record PurchaseRequestHeader;
    begin
        IndentHeader.SETRANGE(Status, Status);
        EXIT(STRSUBSTNO(IndentHeaderTypeCondnTxt, WorkFLowSetup.Encode(IndentHeader.GETVIEW(FALSE))));

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', true, true)]
    local procedure OnAddWorkflowCategoriesToLibrary()
    begin
        WorkFLowSetup.InsertWorkflowCategory(IndnetCategoryTxt, IndnetCategoryDescTxt);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', true, true)]
    local procedure OnAfterInsertApprovalsTableRelations()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        WorkFLowSetup.InsertTableRelation(DATABASE::PurchaseRequestHeader, 0, DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnInsertWorkflowTemplates', '', true, true)]
    local procedure OnInsertWorkflowTemplates()
    begin
        InsertIndentApprovalWorkFLowTemplete();
    end;

    var

        WorkFLowSetup: Codeunit "Workflow Setup";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        workflowResponseHandling: Codeunit "Workflow Response Handling";
        workfloweventhandlingExt: Codeunit ApprovalMgt;

        IndentWorkflowCodeTxt: TextConst ENU = 'INDT';
        IndentWorkflowDescriptionTxt: TextConst ENU = 'Indent Workflow';
        IndnetCategoryTxt: TextConst ENU = 'INDENT';
        IndnetCategoryDescTxt: TextConst ENU = 'Indent Documents';
        IndentHeaderTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Indent Header">%1</DataItem></DataItems></ReportParameters>';
}