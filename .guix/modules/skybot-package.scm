(define-module (skybot-package)
  #:use-module (guix)
  #:use-module (guix packages)
  #:use-module (guix git)
  #:use-module (guix git-download)
  #:use-module (guix build-system pyproject)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages xml)
  #:use-module (git bindings)
  #:use-module (git oid)
  #:use-module (git reference)
  #:use-module (git repository)
  #:use-module (ice-9 exceptions)
  #:use-module (srfi srfi-11))

(define vcs-file?
  (or (git-predicate (dirname (dirname (current-source-directory))))
      (const #t)))

(define-public skybot
  (let ((base-version "0.0.1")
	(revision "1"))
    (let*-values (((_working-dir commit _ref) (repository-info (current-source-directory))))
      (package
	(name "skybot")
	(version (if commit
		     (git-version base-version revision commit)
		     (string-append base-version "-dev")))
	(source (local-file "../.." "skybot-checkout"
			    #:recursive? #t
			    #:select? vcs-file?))
	(build-system pyproject-build-system)
	(arguments '(#:test-backend 'custom
		     #:test-flags '("test/")))
	(inputs (list
		 python-setuptools
		 python-setuptools-scm
		 python-lxml
		 python-future))
	(native-inputs (list python-mock))
	(synopsis "Python IRC bot")
	(description "Skybot is a Python-based IRC bot framework with an emphasis on simplicity and extensibility.")
	(home-page "https://github.com/rmmh/skybot")
	(license license:unlicense)))))

skybot
