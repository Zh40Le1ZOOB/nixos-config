{ lib }:
{
  flavorOption = lib.types.enum [
    "latte"
    "frappe"
    "macchiato"
    "mocha"
  ];
  accentOption = lib.types.enum [
    "blue"
    "flamingo"
    "green"
    "lavender"
    "maroon"
    "mauve"
    "peach"
    "pink"
    "red"
    "rosewater"
    "sapphire"
    "sky"
    "teal"
    "yellow"
  ];
}
