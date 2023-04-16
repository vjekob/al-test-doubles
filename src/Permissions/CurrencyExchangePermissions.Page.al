page 50101 "Demo Curr. Exch. Permissions"
{
    Caption = 'Currency Exchange Permissions';
    PageType = List;
    SourceTable = "Demo Currency Exch. Permission";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Permissions)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }

                field("From Currency Code"; Rec."From Currency Code")
                {
                    ApplicationArea = All;
                }

                field("To Currency Code"; Rec."To Currency Code")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}
