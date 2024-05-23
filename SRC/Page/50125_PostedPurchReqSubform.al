//namespace PractceHimaniSymbol.PractceHimaniSymbol;

page 50125 postedIndentSubform
{
    ApplicationArea = All;
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = PostedPurchReqline;

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
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(LocationCode; Rec.LocationCode)
                {
                    ToolTip = 'Specifies the value of the LocationCode field.';
                }
                field(UnitofMeasure; Rec.UnitofMeasure)
                {
                    ToolTip = 'Specifies the value of the Unit of Measure field.';
                }
                field(Qty; Rec.Qty)
                {
                    ToolTip = 'Specifies the value of the Qty Received field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
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
}
