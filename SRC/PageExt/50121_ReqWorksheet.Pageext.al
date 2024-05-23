pageextension 50121 ReqWorksheet extends "Req. Worksheet"
{
    layout
    {
        addafter("No.")
        {
            field(IndentNo; Rec.IndentNo)
            {
                ApplicationArea = all;
                Caption = 'Indent No.';
            }

        }
        modify("Variant Code")
        {
            Visible = true;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(CarryOutActionMessage)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                Message('hii');
            end;
        }
    }

    var
        myInt: Integer;
}