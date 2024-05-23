table 50123 PostedPurchReqline
{
    DataClassification = CustomerContent;
    Caption = 'Posted Purchase Request line';
    fields
    {
        field(1; DocumentNo; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
        }
        field(2; No; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';

        }
        field(3; Type; enum IndentType)
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
        }
        field(4; VariantCode; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Variant Code';
        }
        field(5; Description; text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(6; UnitofMeasure; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Unit of Measure';
        }
        field(7; LocationCode; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Location Code';
        }
        field(8; RequiredDate; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Required Date';
        }
        field(9; Remarks; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Remarks';
        }
        field(10; Qty; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty';
        }
        field(11; LineNo; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No';
        }
        field(12; QtyReceive; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty Receive';
        }
        field(13; QtyReceived; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Qty Received';
        }
        field(14; VersionNo; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Version No';
        }
        field(15; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 1 Code';
        }
        field(16; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 2 Code';
        }
        field(17; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 3 Code';
        }
        field(18; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 4 Code';
        }
        field(19; Process; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Process';
        }
        field(20; IndentStatus; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Indent Status';
        }

    }

    keys
    {
        key(Key1; DocumentNo, LineNo, VersionNo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}