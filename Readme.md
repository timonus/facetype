# FaceType

FaceType is an App for the iOS designed to showcase the beauty of typography. It boils down into three pretty basic view controllers.

`TempFontsViewController` → `TSFontViewController` → `TSGlyphViewController`

Each of which showcases fonts at a particular level of detail.

## Issues

- Sizing calculations aren't currently super accurate, glyphs may step out of their bounds particularly in `TSFontViewController`

## Todo

- Add a proper `TSFontsViewController` for initially chossing a font, I have a design in mind but have yet to implement it.
- Add a [lot of fonts](dafont.com), as well as the code utilized to get said fonts
- Add a build step that automagially adds fonts in the bundle into  the Info plist.
- Add in-App font download/addition

## Notes

- The App is currently only designed to support the iPad well, although enabling iPhone support doesn't *completley* kill it. Feel free to [fork it](github.com/tijoinc/facetype) if this is a feature you really desire.
- The App is currently only designed to support portrait orientations well, although enabling landscape doesn't *completley* kill it. Feel free to [fork it](github.com/tijoinc/facetype) if this is a feature you really desire.