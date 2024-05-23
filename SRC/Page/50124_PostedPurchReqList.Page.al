page 50124 "Posted Purch Req List"
{
    PageType = List;
    Caption = 'Posted Purchase Request List';
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "Posted Purch Req Card";
    SourceTable = "Posted Purch Req Header";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(IndentNo; Rec.IndentNo)
                {
                    ApplicationArea = All;
                }
                field(IndentDate; Rec.IndentDate)
                {
                    ApplicationArea = All;
                }
                field(IndentName; Rec.IndentName)
                {
                    ApplicationArea = All;
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }

            }
        }
        area(Factboxes)
        {

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
}