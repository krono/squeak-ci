HDTestReport runPackage: 'Parsing-Derivatives-Test'.

"Throw away the dirty image."
WorldState addDeferredUIMessage: [ SmalltalkImage current snapshot: false andQuit: true ].