table 50121 PurchaseRequestHeader
{
    DataClassification = CustomerContent;
    Caption = 'Purchase Request Header';

    fields
    {
        field(1; IndentNo; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Indent No.';
            trigger OnValidate()
            var
                InventorySetup: Record "Inventory Setup";
                NoSeriesMgt: Codeunit NoSeriesManagement;
                PurchasesSetup: Record "Purchases & Payables Setup";
            begin
                IF IndentNo <> xRec.IndentNo THEN BEGIN
                    InventorySetup.GET;
                    NoSeriesMgt.TestManual(PurchasesSetup."Indent No.");
                    "No. Series" := '';
                END;
                Rec.InvoiceNO := Rec.IndentNo;
            end;
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
            TableRelation = Employee;

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
            TableRelation = "No. Series";
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
        field(9; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");

            end;
        }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(11; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(12; "Shortcut Dimension 4 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(13; "Fully Processed"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Fully Processed';
        }

    }

    keys
    {
        key(Key1; IndentNo)
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
    var
        PurchasesSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        IF IndentNo = '' THEN BEGIN
            PurchasesSetup.GET;
            PurchasesSetup.TESTFIELD("Indent No.");
            NoSeriesMgt.InitSeries(PurchasesSetup."Indent No.", xRec."No. Series", 0D, IndentNo, "No. Series");

        END;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        DimensionManagement.ValidateDimValueCode(1, "Shortcut Dimension 1 Code");
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        ApprovalManagement: Codeunit "Approvals Mgmt.";
    begin
        ApprovalManagement.DeleteApprovalEntries(Rec.RecordId);
    end;

    trigger OnRename()
    begin

    end;

    procedure PerformManualRelease(var IndentHeader: Record PurchaseRequestHeader)
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        NoOfSelected: Integer;
        NoOfSkipped: Integer;
    begin
        NoOfSelected := IndentHeader.Count();
        IndentHeader.SetFilter(Status, '<>%1', IndentHeader.Status::Released);
        NoOfSkipped := NoOfSelected - IndentHeader.Count;
        BatchProcessingMgt.BatchProcess(IndentHeader, Codeunit::"Indent Manual Release", Enum::"Error Handling Options"::"Show Error", NoOfSelected, NoOfSkipped);
    end;

    procedure PerformManualReopen(var IndentHeader: Record PurchaseRequestHeader)
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        NoOfSelected: Integer;
        NoOfSkipped: Integer;
    begin
        NoOfSelected := IndentHeader.Count();
        IndentHeader.SetFilter(Status, '<>%1', IndentHeader.Status::Open);
        NoOfSkipped := NoOfSelected - IndentHeader.Count;
        BatchProcessingMgt.BatchProcess(IndentHeader, Codeunit::"Indent Manual Reopen", Enum::"Error Handling Options"::"Show Error", NoOfSelected, NoOfSkipped);
    end;

}