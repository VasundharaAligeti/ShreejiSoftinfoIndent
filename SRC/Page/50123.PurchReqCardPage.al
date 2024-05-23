//namespace PractceHimaniSymbol.PractceHimaniSymbol;

page 50123 PurchaseReqCardPage
{
    Caption = 'Purchase Req Card Page';
    PageType = Document;
    UsageCategory = Administration;
    SourceTable = PurchaseRequestHeader;
    //ApplicationArea = all;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(IndentNo; Rec.IndentNo)
                {
                    ToolTip = 'Specifies the value of the Indent No. field.';
                    ApplicationArea = all;
                    ShowMandatory = true;
                }
                field(IndentName; Rec.IndentName)
                {
                    ToolTip = 'Specifies the value of the Indenter Name field.';
                    ApplicationArea = all;
                    ShowMandatory = true;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        if rec.IndentName = '' then
                            Error('Must enter Indenter Name');
                    end;
                }
                field(IndentReceiptDate; Rec.IndentReceiptDate)
                {
                    ToolTip = 'Specifies the value of the Indent Receipt Date field.';
                    ApplicationArea = all;
                    Visible = false;
                }
                field(IndentDate; Rec.IndentDate)
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Fully Processed"; Rec."Fully Processed")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

            }
            group(Dimensions)
            {
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }

            }
            part(IndentSubform; IndentSubform)
            {
                Caption = 'Lines';
                //Provider=inden;
                SubPageLink = DocumentNo = field(IndentNo);
                ApplicationArea = all;
                //UpdatePropagation = Both;
            }
        }

    }

    actions
    {
        area(Processing)
        {
            group(Post)
            {
                Caption = 'Post';
                Image = Post;
                action(PostToReq)
                {
                    ApplicationArea = All;
                    Caption = 'Post to Requisition';
                    Image = Post;
                    PromotedIsBig = true;
                    Promoted = true;
                    trigger OnAction()
                    var
                        ReqLine: Record "Requisition Line";
                        Text000: Label 'Qty Received must not be greater than Qty';
                        IsQtyEqual: Boolean;
                    begin

                        IndentLine.Reset();
                        IndentLine.SetRange(DocumentNo, Rec.IndentNo);
                        IndentLine.SetFilter(Type, '<>%1', IndentLine.Type::" ");
                        if IndentLine.FindSet() then begin
                            repeat
                                // if IndentLine.QtyReceive <> 0 then begin
                                //     IndentLine.QtyReceived += IndentLine.QtyReceive;
                                //     if IndentLine.QtyReceived > IndentLine.Qty then
                                //         Error(Text000);

                                //     IndentLine.Modify();
                                //     CurrPage.Update();
                                // end;
                                IndentLine.QtyReceived := IndentLine.Qty;
                                if (IndentLine.Type = IndentLine.Type::"G/L Account") then
                                    IndentLine.TestField(Qty)
                                else begin
                                    IndentLine.TestField(Qty);
                                    IndentLine.TestField(UnitofMeasure);
                                end;
                            until IndentLine.Next() = 0;
                        end;
                        IndentLine.Reset();
                        IndentLine.SetRange(DocumentNo, Rec.IndentNo);
                        IndentLine.SetRange(Process, true);
                        IndentLine.SetRange(IndentStatus, '');
                        if IndentLine.FindSet() then
                            repeat
                                ProcessNewEntry();
                            until IndentLine.Next() = 0;
                        IndentLine.RESET;
                        IndentLine.SetRange(IndentLine.DocumentNo, Rec.IndentNo);
                        IndentLine.SetRange(IndentLine.Process, true);
                        IndentLine.SetRange(IndentLine.IndentStatus, '');
                        if IndentLine.FindSet() then
                            repeat
                                IndentLine.IndentStatus := 'Processed';
                                IndentLine.MODIFY;
                            until IndentLine.Next() = 0;
                        MESSAGE('%1 Indent has been converted to Enquiry', Rec.IndentNo);
                        InitPostedIndent();

                        IndentLine.Reset();
                        IndentLine.SetRange(IndentLine.DocumentNo, Rec.IndentNo);
                        IndentLine.SetRange(IndentLine.Process, false);
                        IndentLine.SetFilter(IndentStatus, '<>%1', 'Processed');
                        if IndentLine.IsEmpty then begin
                            Rec."Fully Processed" := true;
                        end;
                        if Rec."Fully Processed" = true then begin
                            IndentLine.Reset();
                            IndentLine.SetRange(DocumentNo, Rec.IndentNo);
                            if not IndentLine.IsEmpty then begin
                                IndentLine.DeleteAll();
                                Rec.Delete();
                            end;
                        end;
                        /*IsQtyEqual := false;
                        if IndentLine.FindSet() then
                            repeat
                                if IndentLine.QtyReceived = IndentLine.Qty then
                                    IsQtyEqual := true
                                else
                                    exit;
                                Message('done');
                            until IndentLine.Next() = 0;
                        if IsQtyEqual then begin
                            if not IndentLine.IsEmpty then begin
                                IndentLine.DeleteAll();
                                Rec.Delete();
                            end;
                        end;*/
                    end;
                }
            }
            action(Statistic)
            {
                ApplicationArea = All;
                Caption = 'Statistic';
                Promoted = true;
                Image = Statistics;
                PromotedIsBig = true;
                trigger OnAction()
                begin

                end;
            }
            action(Released)
            {
                ApplicationArea = All;
                Caption = 'Released';
                Promoted = true;
                Image = ReleaseDoc;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Released;
                    Rec.Modify();
                end;
            }
            action(Reopen)
            {
                ApplicationArea = All;
                Caption = 'Reopen';
                Promoted = true;
                Image = ReOpen;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Open;
                    rec.Modify();
                end;
            }
            group(Print)
            {
                action("&Print")
                {
                    ApplicationArea = All;
                    Caption = 'Print';
                    Promoted = true;
                    Image = Report;
                    PromotedIsBig = true;
                    PromotedCategory = Report;
                    trigger OnAction()
                    var
                        indentheader: Record PurchaseRequestHeader;
                    begin
                        indentheader.SetRange(IndentNo, Rec.IndentNo);
                        Report.RunModal(Report::PurchReqReport, true, true, indentheader);
                    end;
                }
            }
            group(RequestApproval)
            {
                Caption = 'Request Approval';
                action(SendApprovalReq)
                {
                    ApplicationArea = All;
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Promoted = true;
                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit ApprovalMgt;
                    begin
                        ApprovalMgt.onSendIndentForApproval(Rec);
                    end;
                }
                action(CancelApprovalReq)
                {
                    ApplicationArea = All;
                    Caption = 'Cancel Approval Request';
                    Image = CancelApprovalRequest;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Promoted = true;
                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit ApprovalMgt;
                        workFlowMgt: Codeunit "Workflow Webhook Management";
                    begin
                        ApprovalMgt.onCancelIndentForApproval(Rec);
                    end;
                }
            }
        }
    }
    procedure Process()
    var
        ReqLine: Record "Requisition Line";
        stringLen: Integer;
        indentNoL_Code: Code[20];
    begin
        indentLine.Reset();
        indentLine.SetRange(indentLine.DocumentNo, Rec.IndentNo);
        if indentLine.FindSet() then
            repeat
                ReqLine.Reset();
                ReqLine.SetRange("Worksheet Template Name", 'REQ');
                ReqLine.SETRANGE(ReqLine."Journal Batch Name", 'DEFAULT');
                ReqLine.SETRANGE(ReqLine.Type, IndentLine.Type);
                ReqLine.SETRANGE(ReqLine."No.", IndentLine.No);
                if ReqLine.FindSet() then begin
                    repeat
                        ReqLine.Quantity := ReqLine.Quantity + IndentLine.Qty;
                        stringLen := StrLen(ReqLine.IndentNo);
                        ReqLine.IndentNo := COPYSTR(ReqLine.IndentNo, 1, stringLen) + ',' + IndentLine.DocumentNo;
                        IF ReqLine."Due Date" > IndentLine.RequiredDate THEN
                            ReqLine."Due Date" := IndentLine.RequiredDate;

                    until ReqLine.Next() = 0;
                    ReqLine.MODIFY;
                END ELSE BEGIN
                    ProcessNewEntry();
                END;
            until indentLine.Next() = 0;
    end;

    procedure ProcessNewEntry()
    var
        ReqLine: Record "Requisition Line";
        ReqLine2: Record "Requisition Line";
        GLSetup_lRec: Record "General Ledger Setup";
        DimSetID_Line: Integer;
        DimensionSetEntry_lTMPRec: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
    begin
        GLSetup_lRec.GET;
        DimSetID_Line := 0;
        IF IndentLine."Shortcut Dimension 1 Code" <> '' THEN BEGIN
            DimensionSetEntry_lTMPRec.DELETEALL;
            DimensionSetEntry_lTMPRec.RESET;
            DimensionSetEntry_lTMPRec.INIT;
            DimensionSetEntry_lTMPRec."Dimension Code" := GLSetup_lRec."Global Dimension 1 Code";
            DimensionSetEntry_lTMPRec.VALIDATE("Dimension Value Code", IndentLine."Shortcut Dimension 1 Code");
            DimensionSetEntry_lTMPRec.INSERT;
        END;
        IF IndentLine."Shortcut Dimension 2 Code" <> '' THEN BEGIN
            DimensionSetEntry_lTMPRec.RESET;
            DimensionSetEntry_lTMPRec.INIT;
            DimensionSetEntry_lTMPRec."Dimension Code" := GLSetup_lRec."Global Dimension 2 Code";
            DimensionSetEntry_lTMPRec.VALIDATE("Dimension Value Code", IndentLine."Shortcut Dimension 2 Code");
            DimensionSetEntry_lTMPRec.INSERT;
        END;

        IF IndentLine."Shortcut Dimension 3 Code" <> '' THEN BEGIN
            DimensionSetEntry_lTMPRec.RESET;
            DimensionSetEntry_lTMPRec.INIT;
            DimensionSetEntry_lTMPRec."Dimension Code" := GLSetup_lRec."Shortcut Dimension 3 Code";
            DimensionSetEntry_lTMPRec.VALIDATE("Dimension Value Code", IndentLine."Shortcut Dimension 3 Code");
            DimensionSetEntry_lTMPRec.INSERT;
        END;
        IF IndentLine."Shortcut Dimension 4 Code" <> '' THEN BEGIN
            DimensionSetEntry_lTMPRec.RESET;
            DimensionSetEntry_lTMPRec.INIT;
            DimensionSetEntry_lTMPRec."Dimension Code" := GLSetup_lRec."Shortcut Dimension 4 Code";
            DimensionSetEntry_lTMPRec.VALIDATE("Dimension Value Code", IndentLine."Shortcut Dimension 4 Code");
            DimensionSetEntry_lTMPRec.INSERT;
        END;

        DimSetID_Line := DimMgt.GetDimensionSetID(DimensionSetEntry_lTMPRec);
        ReqLine.INIT;
        ReqLine."Worksheet Template Name" := 'REQ';
        ReqLine."Journal Batch Name" := 'DEFAULT';
        reqLine2.RESET;
        reqLine2.SETRANGE(reqLine2."Worksheet Template Name", 'REQ');
        reqLine2.SETRANGE(reqLine2."Journal Batch Name", 'DEFAULT');
        IF reqLine2.FindLast() THEN BEGIN
            ReqLine."Line No." := reqLine2."Line No." + 10000;
        END ELSE BEGIN
            ReqLine."Line No." := 10000;
        END;

        ReqLine.Validate(Type, IndentLine.Type);
        ReqLine.Validate("No.", IndentLine.No);
        ReqLine.Description := IndentLine.Description;
        ReqLine.Validate("Unit of Measure Code", IndentLine.UnitofMeasure);
        ReqLine.IndentNo := IndentLine.DocumentNo;
        ReqLine."Due Date" := IndentLine.RequiredDate;
        ReqLine.Validate("Variant Code", IndentLine.VariantCode);
        ReqLine.Validate(Quantity, IndentLine.Qty);
        ReqLine.Validate("Shortcut Dimension 1 Code", IndentLine."Shortcut Dimension 1 Code");
        ReqLine.Validate("Shortcut Dimension 2 Code", IndentLine."Shortcut Dimension 2 Code");
        ReqLine."Dimension Set ID" := DimSetID_Line;
        //IndentLine.MODIFY;
        ReqLine.INSERT;
    end;


    procedure InitPostedIndent()
    var
        postedIndentHeader: Record "Posted Purch Req Header";
        PostedIndentLine: Record PostedPurchReqline;
        indentHeader: Record PurchaseRequestHeader;
        IndentLine: Record PurchRequestLine;
        versionNo: Integer;
    begin
        postedIndentHeader.SetRange(IndentNo, Rec.IndentNo);
        if postedIndentHeader.FindLast() then begin
            postedIndentHeader.Init();
            postedIndentHeader.TransferFields(Rec);
            postedIndentHeader.VersionNo := postedIndentHeader.VersionNo + 1;
            postedIndentHeader.Insert(true);
            PostedIndentLine.SetRange(DocumentNo, Rec.IndentNo);
            if PostedIndentLine.FindLast() then begin
                versionNo := PostedIndentLine.VersionNo + 1;
                IndentLine.Reset();
                IndentLine.SetRange(DocumentNo, Rec.IndentNo);
                if IndentLine.FindSet() then
                    repeat
                        PostedIndentLine.Init();
                        PostedIndentLine.TransferFields(IndentLine);
                        PostedIndentLine.VersionNo := versionNo;
                        PostedIndentLine.Insert(true);
                    until IndentLine.Next() = 0;
            end;
        end
        else begin
            postedIndentHeader.Init();
            postedIndentHeader.TransferFields(Rec);
            postedIndentHeader.VersionNo := 1;
            postedIndentHeader.Insert(true);
            PostedIndentLine.Reset();
            IndentLine.Reset();
            IndentLine.SetRange(DocumentNo, Rec.IndentNo);
            if IndentLine.FindSet() then
                repeat
                    PostedIndentLine.Init();
                    PostedIndentLine.TransferFields(IndentLine);
                    PostedIndentLine.VersionNo := 1;
                    PostedIndentLine.Insert(true);
                until IndentLine.Next() = 0;

        end;
    end;

    trigger OnOpenPage()
    begin
        gPageEditable := Rec.Status <> Rec.Status::Approved;
    end;

    trigger OnAfterGetRecord()
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalMgt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalMgt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalMgt.CanCancelApprovalForRecord(Rec.RecordId);
        WorkflowBhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanReqApprovalForFlow, CanCancelApprovalForFlow);
        gPageEditable := Rec.Status <> Rec.Status::Approved;
    end;

    var
        IndentLine: Record PurchRequestLine;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        ApprovalMgtCu: Codeunit ApprovalMgt;
        WorkflowBhookMgt: Codeunit "Workflow Webhook Management";

        OpenApprovalEntriesExistForCurrUser, OpenApprovalEntriesExist, CanCancelApprovalForRecord,
        CanReqApprovalForFlow, CanCancelApprovalForFlow,
        gPageEditable : boolean;


}
