{
  lib,
  stdenv,
  fetchurl,
  undmg,
}:
stdenv.mkDerivation rec {
  pname = "exifcleaner";
  version = "3.6.0";

  src = fetchurl {
    url = "https://github.com/szTheory/exifcleaner/releases/download/v${version}/ExifCleaner-${version}.dmg";
    sha256 = "sha256-RZspawAKfNYUcTdy6bTs8WBNO7EJJqsjRujqiORN8yM=";
  };

  nativeBuildInputs = [undmg];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications

    # Copy the app bundle preserving structure and permissions
    cp -R "ExifCleaner.app" "$out/Applications/"

    # Fix permissions recursively
    chmod -R u+w "$out/Applications/ExifCleaner.app"

    # Create symlink for command line usage
    # mkdir -p $out/bin
    # ln -s "$out/Applications/ExifCleaner.app/Contents/MacOS/ExifCleaner" "$out/bin/exifcleaner"

    # runHook postInstall
  '';

  # Post-install fixup for Electron apps
  # postFixup = ''
  #   # Ensure the main executable is executable
  #   chmod +x "$out/Applications/ExifCleaner.app/Contents/MacOS/ExifCleaner"

  #   # Fix helper app permissions if they exist
  #   if [ -d "$out/Applications/ExifCleaner.app/Contents/Frameworks" ]; then
  #     find "$out/Applications/ExifCleaner.app/Contents/Frameworks" -name "*.app" -type d -exec chmod -R +x {}/Contents/MacOS/ \; 2>/dev/null || true
  #   fi

  #   # Also check for Electron Framework helpers in different possible locations
  #   for helper_dir in \
  #     "$out/Applications/ExifCleaner.app/Contents/Frameworks/Electron Framework.framework/Versions/A/Helpers" \
  #     "$out/Applications/ExifCleaner.app/Contents/Frameworks/ExifCleaner Helper.app/Contents/MacOS" \
  #     "$out/Applications/ExifCleaner.app/Contents/MacOS"; do
  #     if [ -d "$helper_dir" ]; then
  #       chmod +x "$helper_dir"/* 2>/dev/null || true
  #     fi
  #   done
  # '';

  meta = with lib; {
    description = "Cross-platform desktop GUI app to clean metadata from images, videos, PDFs, and other files";
    homepage = "https://github.com/szTheory/exifcleaner";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = [];
    mainProgram = "exifcleaner";
  };
}
