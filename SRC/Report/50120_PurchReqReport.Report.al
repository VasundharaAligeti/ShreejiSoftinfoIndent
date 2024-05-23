report 50120 PurchReqReport
{
    Caption = 'Purchase Request Report';
    DefaultLayout = RDLC;
    RDLCLayout = './Src/ReportLayout/IndentReport.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;


    dataset
    {
        dataitem(IndentHeader; PurchaseRequestHeader)
        {
            column(IndentNo; IndentNo)
            {
            }
            column(IndentName; IndentName)
            {
            }
            column(IndentDate; IndentDate)
            {
            }
            column(IndentReceiptDate; IndentReceiptDate)
            {
            }
            column(Des_lbl; Des_lbl)
            {
            }
            column(ItemNo_Lbl; ItemNo_lbl)
            {
            }
            column(LocCode_lbl; LocCode_lbl)
            {
            }
            column(Qty_lbl; Qty_lbl)
            {
            }
            column(Remarks_lbl; Remarks_lbl)
            {
            }
            column(RequiredDate_lbl; RequiredDate_lbl)
            {
            }
            column(UnitOfMeas_lbl; UnitOfMeas_lbl)
            {
            }
            column(Department_lbl; Department_lbl)
            {
            }
            column(Hod_lbl; Hod_lbl)
            {
            }
            column(IndentDate_lbl; IndentDate_lbl)
            {
            }
            column(Indentname_lbl; Indentname_lbl)
            { }
            column(IndentNo_lbl; IndentNo_lbl)
            { }
            column(PrepareBy_lbl; PrepareBy_lbl)
            { }
            column(Report_lbl; Report_lbl)
            { }
            column(Stores_lbl; Stores_lbl)
            { }
            column(Authorized_lbl; Authorized_lbl)
            { }
            dataitem(IndentLine; PurchRequestLine)
            {
                DataItemLink = DocumentNo = field(IndentNo);
                RequestFilterFields = DocumentNo, No;
                column(DocumentNo; DocumentNo)
                {
                }
                column(No; No)
                {
                }
                column(Description; Description)
                {
                }
                column(LocationCode; LocationCode)
                {
                }
                column(QtyReceived; Qty)
                {
                }
                column(Remarks; Remarks)
                {
                }
                column(RequiredDate; RequiredDate)
                {
                }
                column(Type; Type)
                {
                }
                column(VariantCode; VariantCode)
                {
                }
                column(UnitofMeasure; UnitofMeasure)
                {
                }
                column(LineNo; LineNo)
                {
                }
            }

        }
    }

    requestpage
    {

        layout
        {
            area(Content)
            {

            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }


    var
        ItemNo_lbl: Label 'Item No.';
        Des_lbl: Label 'Description';
        Remarks_lbl: Label 'Remarks';
        UnitOfMeas_lbl: Label 'Unit of Measure';
        Qty_lbl: Label 'Qty Recieved';
        LocCode_lbl: Label 'Location Code';
        RequiredDate_lbl: Label 'Required Date';
        IndentNo_lbl: Label 'Purchase Indent No';
        Indentname_lbl: Label 'Indenter Name';
        IndentDate_lbl: Label 'Purchase Indent Date';
        Report_lbl: Label 'PURCHASE REQUISITION INDENT';
        PrepareBy_lbl: Label 'Prepare By';
        Department_lbl: Label 'Department Head';
        Stores_lbl: Label 'Stores Officer';
        Hod_lbl: Label 'HOD(Stores)';
        Authorized_lbl: Label 'Authorised Signatory';



}