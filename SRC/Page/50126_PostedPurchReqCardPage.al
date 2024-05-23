page 50126 "Posted Purch Req Card"
{
    SourceTable = "Posted Purch Req Header";
    Editable = false;
    PageType = Document;
    UsageCategory = Administration;
    Caption = 'Posted Purch Req Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(IndentNo; Rec.IndentNo)
                {
                    ToolTip = 'Specifies the value of the Indent No. field.';
                    ApplicationArea = all;
                }
                field(IndentName; Rec.IndentName)
                {
                    ToolTip = 'Specifies the value of the Indenter Name field.';
                    ApplicationArea = all;
                }
                field(IndentReceiptDate; Rec.IndentReceiptDate)
                {
                    ToolTip = 'Specifies the value of the Indent Receipt Date field.';
                    ApplicationArea = all;
                }
                field(IndentDate; Rec.IndentDate)
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }

            }
            group(Dimensions)
            {
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = all;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
            }
            part(IndentLine; postedIndentSubform)
            {
                Caption = 'Lines';
                SubPageLink = DocumentNo = field(IndentNo);
                ApplicationArea = all;
                //UpdatePropagation = Both;
            }
        }

    }


    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}