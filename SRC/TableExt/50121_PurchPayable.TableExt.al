tableextension 50121 PurchPayable extends "Purchases & Payables Setup"
{
    fields
    {
        field(50102; "Indent No."; Code[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Indent No.';
            TableRelation = "No. Series";
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