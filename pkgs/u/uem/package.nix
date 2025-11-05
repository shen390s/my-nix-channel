{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkgs,
}:

let
  pname = "uem";
  version = "0.1";
  meta = {
    description = "Universal Emacs Manager";
    homepage = "https://github.com/shen390s/uem";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.i01011001 ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = pname;
  version = version;
  
  src = fetchFromGitHub {
    owner = "shen390s";
    repo = "uem";
    rev = "develop";
    hash = "sha256-WLQak+5dbD4Zo3EgnW5YVhj5tNPJlkXYdd4lNLzRlq0=";
  };

  nativeBuildInputs = [ pkgs.roswell ];
  doCheck = true;

  buildPhase = ''
     set +e
     export HOME=/build
     env
     ros version
     find .
     mkdir -p $HOME/.roswell
     cat >$HOME/.roswell/init.lisp <<EOF
     ;; (ql:quickload 'asdf-driver)
     (let ((cwd (parse-native-namestring (sb-posix:getcwd)
                                    nil
                                    *default-pathname-defaults*
                                    :as-directory t)))
          (push cwd
                asdf:*central-registry*))
     EOF

     ros -l $HOME/.roswell/init.lisp build roswell/uem.ros
  '';          
})
