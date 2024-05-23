table 50120 PurchRequestLine
{
    DataClassification = CustomerContent;
    Caption = 'Purchase Request Line';

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
            TableRelation = if (Type = const("G/L Account")) "G/L Account" else if (Type = const(Item)) Item else if (Type = const(ChargeItem)) "Item Charge" else if (Type = const(FixedAsset)) "Fixed Asset" else if (Type = const(" ")) "Standard Text";
            trigger OnValidate()
            var
                StdTxt: Record "Standard Text";
                ItemCharge: Record "Item Charge";
                FixedAsset: Record "Fixed Asset";
                GenLedAcc: Record "G/L Account";
                item: Record Item;
            begin
                case Type of
                    Type::" ":
                        begin
                            StdTxt.GET(No);
                            Description := StdTxt.Description;
                        end;
                    Type::ChargeItem:
                        begin
                            ItemCharge.GET(No);
                            Description := ItemCharge.Description;
                        end;
                    Type::FixedAsset:
                        begin
                            FixedAsset.GET(No);
                            FixedAsset.TESTFIELD(Inactive, FALSE);
                            FixedAsset.TESTFIELD(Blocked, FALSE);
                            Description := FixedAsset.Description;
                        end;
                    Type::"G/L Account":
                        begin
                            GenLedAcc.GET(No);
                            GenLedAcc.CheckGLAcc;
                            GenLedAcc.TESTFIELD("Direct Posting", TRUE);
                            Description := GenLedAcc.Name;
                            UnitofMeasure := '';
                        end;
                    Type::Item:
                        begin
                            item.GET(No);
                            Description := item.Description;
                            UnitofMeasure := item."Base Unit of Measure";
                        end;
                end;
            end;
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
            TableRelation = if (Type = const(Item)) "Item Variant".Code where("Item No." = field(No));
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
            TableRelation = Location;
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
            Caption = 'Indent Raise';
            trigger OnValidate()
            var
                Text000: Label 'Qty Receive must not be greater than Qty';
                Text001: Label 'Qty Received is equal to Qty';
            begin
                if Rec.QtyReceive > Rec.Qty then
                    Error(Text000);
                if Rec.QtyReceive + Rec.QtyReceived > Rec.Qty then
                    Error(Text001);
            end;
        }
        field(13; QtyReceived; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Indent Raised';
            Editable = false;
        }
        field(15; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 1 Code';
            CaptionClass = '1,2,1';
        }
        field(16; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 2 Code';
            CaptionClass = '1,2,2';
        }
        field(17; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 3 Code';
            CaptionClass = '1,2,3';
        }
        field(18; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Shortcut Dimension 4 Code';
            CaptionClass = '1,2,4';
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
        key(Key1; DocumentNo, LineNo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }


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
    var

    begin

    end;

}