tableextension 50120 RequisitionLine extends "Requisition Line"
{
    fields
    {
        field(50000; IndentNo; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Indent No.';
        }
        modify("No.")
        {
            TableRelation = if (Type = const("G/L Account")) "G/L Account" else if (Type = const(Item)) Item else if (Type = const(ChargeItem)) "Item Charge" else if (Type = const(FixedAsset)) "Fixed Asset" else if (Type = const(" ")) "Standard Text";
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}