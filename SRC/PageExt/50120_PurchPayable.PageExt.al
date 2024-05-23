pageextension 50120 PurchPayable extends "Purchases & Payables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Indent No."; Rec."Indent No.")
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