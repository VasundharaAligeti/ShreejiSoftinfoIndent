enum 50120 IndentType
{
    Extensible = true;

    value(0; " ") { Caption = ' '; }
    value(1; "G/L Account") { Caption = 'G/L Account'; }
    value(2; "Item") { Caption = 'Item'; }
    value(3; "ChargeItem")
    {
        Caption = 'Charge Item';
    }
    value(4; "FixedAsset")
    {
        Caption = 'Fixed Asset';
    }
}