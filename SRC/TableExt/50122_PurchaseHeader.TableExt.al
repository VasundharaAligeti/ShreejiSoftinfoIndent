tableextension 50122 PurchaseHeaderTableExt extends "Purchase Header"
{
    fields
    {
        field(50122; "Indent No"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Indent No';
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