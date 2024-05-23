pageextension 50122 PurchaseOrderPageExt extends "Purchase Order"
{
    layout
    {
        addlast(General)
        {
            field("Indent No"; Rec."Indent No")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}