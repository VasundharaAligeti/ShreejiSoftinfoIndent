table 50122 "Posted Purch Req Header"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; IndentNo; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Indent No.';

        }
        field(2; IndentDate; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Indent Date';
        }
        field(3; IndentName; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Indenter Name';

        }
        field(4; IndentReceiptDate; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Indent Receipt Date';
        }
        field(5; "No. Series"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series';

        }
        field(6; Status; Enum "Indent Document Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(7; InvoiceNO; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice No';
        }
        field(8; VersionNo; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Version No';
        }
        field(13; "Fully Processed"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Fully Processed';
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
    }

    keys
    {
        key(Key1; IndentNo, VersionNo)
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