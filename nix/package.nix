{
  lib,
  stdenv,
  cargo-tauri,
  glib-networking,
  # libayatana-appindicator,
  nodejs,
  openssl,
  pkg-config,
  pnpm,
  rustPlatform,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "blmu";
  version = "nightly";
  src = ../.;

  postPatch = ''
    cp nix/default-vite-config.ts vite.config.ts
  '';

  useFetchCargoVendor = true;
  cargoLock.lockFile = ../src-tauri/Cargo.lock;

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname;
    src = ../.;
    hash = "sha256-EFXMp8eE4SPJxo20Ulfa0ycV06uE9CBwDXNHbCqBTuE=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook

    nodejs
    pkg-config
    pnpm.configHook
    rustPlatform.cargoCheckHook
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      glib-networking
      # libayatana-appindicator
      webkitgtk_4_1
    ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  # This example depends on the actual `api` package to be built in-tree
  # preBuild = ''
  #   pnpm --filter '@tauri-apps/api' build
  # '';

  # No one should be actually running this, so lets save some time
  # buildType = "debug";
  # doCheck = false;

  meta = {
    mainProgram = "blmu";
    description = "A BiliBili Music Helper";
    homepage = "https://github.com/Elecleus/blmu";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Elecleus ];
    platforms = lib.platforms.unix;
  };
})
