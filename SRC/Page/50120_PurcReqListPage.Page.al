page 50120 PurchReqListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Purchase Request List';
    SourceTable = PurchaseRequestHeader;
    Editable = false;
    CardPageId = PurchaseReqCardPage;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(IndentNo; Rec.IndentNo)
                {
                    ApplicationArea = All;
                }
                field(IndentDate; Rec.IndentDate)
                {
                    ApplicationArea = All;
                }
                field(IndentName; Rec.IndentName)
                {
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'Post';
                Image = Post;
                PromotedIsBig = true;
                Promoted = true;
                trigger OnAction()
                var
                    ReqLine: Record "Requisition Line";
                    IndentLinePage: Page PurchaseReqCardPage;
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
                            IndentLinePage.ProcessNewEntry();
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
                    IndentLinePage.InitPostedIndent();

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
            action(Statistic)
            {
                ApplicationArea = All;
                Caption = 'Statistic';
                Image = Statistics;
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                begin

                end;
            }
            group(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;

                action(Released)
                {
                    ApplicationArea = All;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedIsBig = true;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Release the document to the next stage of processing. You must reopen the document before you can make changes to it.';
                    trigger OnAction()
                    var
                        IndentHeader: Record PurchaseRequestHeader;
                    begin
                        CurrPage.SetSelectionFilter(IndentHeader);
                        Rec.PerformManualRelease(IndentHeader);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = All;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedIsBig = true;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';

                    trigger OnAction()
                    var
                        IndentHeader: Record PurchaseRequestHeader;
                    begin
                        CurrPage.SetSelectionFilter(IndentHeader);
                        Rec.PerformManualReopen(IndentHeader);
                    end;
                }

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
        }
    }
    var
        indentLine: Record PurchRequestLine;

}