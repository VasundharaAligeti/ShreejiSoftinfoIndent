//namespace PractceHimaniSymbol.PractceHimaniSymbol;

page 50121 IndentSubform
{
    ApplicationArea = All;
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = PurchRequestLine;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        ItemNoOnAfterValidate();
                    end;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(LocationCode; Rec.LocationCode)
                {
                    ToolTip = 'Specifies the value of the LocationCode field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(UnitofMeasure; Rec.UnitofMeasure)
                {
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                    ShowMandatory = true;
                }
                field(Qty; Rec.Qty)
                {
                    ToolTip = 'Specifies the value of the Qty Received field.';
                    ShowMandatory = true;
                }
                field(QtyReceived; Rec.QtyReceived)
                {
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(Process; Rec.Process)
                {
                }
                field(IndentStatus; Rec.IndentStatus)
                {
                    Editable = false;
                }
                field(RequiredDate; Rec.RequiredDate)
                {
                    ToolTip = 'Specifies the value of the Required Date field.';
                }
                field(VariantCode; Rec.VariantCode)
                {
                    ToolTip = 'Specifies the value of the Variant Code field.';
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        ItemNoOnAfterValidate();
    end;

    procedure ItemNoOnAfterValidate()
    var
        purchaseReqHeader: Record PurchaseRequestHeader;
    begin
        purchaseReqHeader.GET(Rec.DocumentNo);
        IF Rec.Type <> Rec.Type::" " THEN BEGIN
            Rec.Validate("Shortcut Dimension 1 Code", purchaseReqHeader."Shortcut Dimension 1 Code");
            rec.Validate("Shortcut Dimension 2 Code", purchaseReqHeader."Shortcut Dimension 2 Code");
            rec.Validate("Shortcut Dimension 3 Code", purchaseReqHeader."Shortcut Dimension 3 Code");
            rec.Validate("Shortcut Dimension 4 Code", purchaseReqHeader."Shortcut Dimension 4 Code");
        END;
    end;
}
